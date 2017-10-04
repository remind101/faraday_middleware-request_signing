require 'faraday_middleware/request_signing/version'
require 'faraday'
require 'http_signatures'
require 'forwardable'

module FaradayMiddleware
  module RequestSigning
    class Middleware  < Faraday::Middleware
      class HttpSignaturesFaradayAdapter
        extend Forwardable
        attr_accessor :signature

        def_delegators :@headers, :[], :fetch
        def_delegators :@faraday_env, :method

        def initialize(faraday_env)
          @faraday_env = faraday_env
          @headers = @faraday_env.request_headers.map { |k, v| [k.downcase, v] }.to_h
        end

        def []=(k, v)
          if k == "Signature"
            self.signature = v
          end
        end

        # :path pseudo-header, as per https://tools.ietf.org/html/rfc7540#section-8.1.2.3
        def path
          @faraday_env.url.request_uri
        end
      end

      def initialize(app, key_id:, key_secret:)
        super(app)
        key = HttpSignatures::Key.new(id: key_id, secret: key_secret)
        algorithm = HttpSignatures::Algorithm::Hmac.new("sha256")
        header_list = HttpSignatures::HeaderList.new(["(request-target)", "host", "date"])
        @signer = HttpSignatures::Signer.new(key: key, algorithm: algorithm, header_list: header_list)
      end

      def call(env)
        env.request_headers["Date"] = Time.now.httpdate
        env.request_headers["Host"] = host_header_value(env)
        env.request_headers["Signature"] = signature_header_value(env)
        @app.call(env)
      end

      private

      def host_header_value(env)
        [env.url.host, (env.url.port unless [80, 443].include?(env.url.port))].compact.join(":")
      end

      def signature_header_value(env)
        adapter = HttpSignaturesFaradayAdapter.new(env)
        @signer.sign(adapter)
        adapter.signature
      end
    end
  end
end

Faraday::Request.register_middleware :request_signing => FaradayMiddleware::RequestSigning::Middleware
