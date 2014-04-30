class Watcher
  def initialize(list)
    @list = YAML.load_file list
  end

  def watch
    messages = []

    @list.each do |server|
      ip_address = server['ip_address']
      services = server['services'].split(',').map &:strip
      services.each do |service|
        pinger = Net::Ping::TCP.new ip_address, service
        messages << "[#{ip_address}] #{service} is down!" unless pinger.ping?
      end
    end

    messages
  end
end
