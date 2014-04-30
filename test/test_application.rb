require_relative "test_helper"
require "erubis"

class TestController < Rulers::Controller
  def index
    "Hello!" # not rendering a view
  end
end

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController,"index"]
  end
end

class RulersAppTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/test/index"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_render
    template = <<TEMPLATE
This template is testing the render! <%= something %>
TEMPLATE

    eruby = Erubis::Eruby.new(template)
    output = eruby.result(:something => "hurrah!")
    assert output.include?("hurrah!")
  end
end
