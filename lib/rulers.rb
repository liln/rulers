require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

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
        if controller.get_response
          st, hd, rs = controller.get_response.to_a
          [st, hd, [rs.body].flatten]
        else
          text = controller.render_now(act.to_s)
          [200, {'Content-Type' => 'text/html'}, [text]]
        end
      rescue Exception => e
        error = e.inspect + "\n" + e.backtrace.join("\n")
        [500, {'Content-Type' => 'text/text'},
          [error]]
      end
    end
  end
end
