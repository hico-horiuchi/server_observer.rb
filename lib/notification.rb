module Notification
  class Chat
    include Notification
    require 'chatwork'

    def initialize(api, room_id)
      ChatWork.api_key = api
      @room_id = room_id.to_i
    end

    def notify(message)
      ChatWork::Message.create room_id: @room_id, body: message
    end
  end

  class Growl
    include Notification
    require 'ruby_gntp'
    TIMEOUT = 3

    def initialize(appname, host, password, port)
      @growl = GNTP.new appname, host, password, port
      register
    end

    def register
      begin
        timeout(TIMEOUT) do
          @growl.register notifications: [{ name: 'notification.rb' }]
        end
      rescue Timeout::Error
      end
    end

    def notify(title, text, icon)
      begin
        timeout(TIMEOUT) do
          @growl.notify({ name: 'notification.rb', title: title, text: text, icon: icon })
        end
      rescue Timeout::Error
      end
    end
  end
end
