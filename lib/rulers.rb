require "rulers/version"
require "rulers/routing"

module Rulers
  class Application
    def call(env)
      begin
        if env['PATH_INFO'] == '/favicon.ico'
          return [404, {'Content-Type' => 'text/html'}, []]
        end

        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'}, [text]]
      rescue
        [500, {'Content-Type' => 'text/html'},
          ["Whoops!! Internal Server Error"]]
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
