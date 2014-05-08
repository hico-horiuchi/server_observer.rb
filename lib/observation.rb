module Observation
  class Server
    include Observation
    require 'net/ping'
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def observe(service)
      pinger = Net::Ping::TCP.new @ip_address, service
      pinger.ping?
    end
  end
end
