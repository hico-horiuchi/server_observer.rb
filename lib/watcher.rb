class Watcher
  def initialize(list)
    @list = YAML.load_file list
  end

  def watch
    alerts = []

    @list.each do |server|
      ip_address = server['ip_address']
      services = server['services'].split(',').map &:strip
      down_services = []

      services.each do |service|
        pinger = Net::Ping::TCP.new ip_address, service
        down_services << service unless pinger.ping?
      end

      alerts << make_alert(ip_address, down_services) unless down_services.empty?
    end

    alerts
  end

  private

  def make_alert(ip_address, services)
    alert = "[#{ip_address}] #{services.shift}"
    services.each { |service| alert += ", #{service}" }
    alert += " is down!"
  end
end
