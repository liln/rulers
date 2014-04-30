require "erubis"
require "rulers/file_model"
require "rack/request"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response # Only for Rulers
      @response
    end

    def render(*args)
      response(render_now(*args))
      # can add debug stuff here if we wanted
    end

    def render_now(view_name, locals = {})
      instance_variables.each do |v|
        locals.merge!(v.to_sym => instance_variable_get(v.to_sym))
      end
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      #puts locals
      eruby.result locals
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/,""
      Rulers.to_underscore klass
    end
  end
end
