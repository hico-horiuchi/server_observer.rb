class Watcher
  def initialize(ip_address, services)
    @ip_address = ip_address
    @services = services
  end

  def watch
    down_services = []
    @services.each do |service|
      pinger = Net::Ping::TCP.new @ip_address, service
      down_services << service unless pinger.ping?
    end
    make_alert(down_services)
  end

  private

  def make_alert(down_services)
    return '' if down_services.empty?
    alert = "[#{@ip_address}] #{down_services.shift}"
    down_services.each { |service| alert += ", #{service}" }
    alert += " is down!"
  end
end
