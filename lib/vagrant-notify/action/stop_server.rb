module Vagrant
  module Notify
    module Action
      class StopServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          if env[:machine].state.id == :running
            env[:machine].communicate.sudo('rm /usr/bin/notify-send; exit 0')
            env[:machine].communicate.sudo('mv /usr/bin/{notify-send.bkp,notify-send}; exit 0')
          end

          @app.call env

          pid = env[:notify_data][:pid]

          Process.kill('KILL', pid.to_i) rescue nil

          env[:notify_data][:pid]  = nil
          env[:notify_data][:port] = nil
        end
      end
    end
  end
end
