require "erubis"

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def render(view_name, locals = {})
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
