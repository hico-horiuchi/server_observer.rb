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
end
