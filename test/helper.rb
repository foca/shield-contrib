$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "shield"
require "shield/contrib"
require "spawn"
require "ohm"
require "rack/test"
require "sinatra/base"
require "haml"

prepare { Ohm.flush }

def setup(&block)
  @_setup = block if block_given?
  @_setup
end

class Cutest::Scope
  include Rack::Test::Methods

  def assert_redirected_to(path)
    assert_equal 302, last_response.status

    fullpath = last_response.headers["Location"].
      gsub(%r{^http://([^/]+)}, "")

    assert_equal path, fullpath
  end

  def session
    last_request.env["rack.session"]
  end
end