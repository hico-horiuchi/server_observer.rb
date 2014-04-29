class Alerter
  def initialize(config)
    @config = YAML.load_file config
    @api = @config['api']
    @room_id = @config['room_id'].to_i
    ChatWork.api_key = @api
  end

  def alert(messages)
    messages.each do |message|
      ChatWork::Message.create room_id: @room_id, body: message
    end
  end
end
