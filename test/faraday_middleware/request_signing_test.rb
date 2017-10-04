require 'test_helper'
require 'net/http'

class FaradayMiddleware::RequestSigningTest < Minitest::Test
  class FakeApp
    attr_accessor :env

    def call(env)
      self.env = env
      [200, {}, []]
    end
  end

  def test_signs_requests_with_given_key_id_and_secret
    fake_app = FakeApp.new

    connection = Faraday.new do |conn|
      conn.request :request_signing, key_id: "test_key_id", key_secret: "test_key_secret"
      conn.adapter :rack, fake_app
    end

    connection.get("http://example.org/test?foo=bar")

    request = Rack::Request.new(fake_app.env)
    date = request.get_header("HTTP_DATE")
    host = request.get_header("HTTP_HOST")
    signature = request.get_header("HTTP_SIGNATURE")
    http_req = Net::HTTP::Get.new("/test?foo=bar", "Date" => date, "Host" => host, "Signature" => signature) # HttpSignatures only works with Net::HTTPRequest :(
    ks = HttpSignatures::KeyStore.new("test_key_id" => "test_key_secret")
    v = HttpSignatures::Verification.new(message: http_req, key_store: ks)

    assert v.valid?, "signature should have been valid!"
  end
end

