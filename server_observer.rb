#!/usr/bin/env ruby
$:.unshift(File.dirname(File.expand_path(__FILE__)))

require 'yaml'
require 'bundler/setup'
require 'lib/observation'
require 'lib/notification'

def make_alert(downed)
  alert = downed.shift
  downed.each { |service| alert += ", #{service}" }
  alert += ' is down!'
end

list = YAML.load_file(File.expand_path('../config/list.yml', __FILE__))
setting = YAML.load_file(File.expand_path('../config/setting.yml', __FILE__))

unless setting['chat'].nil?
  set = setting['chat']
  chat = Notification::Chat.new set['api'], set['room_id']
end

unless setting['growl'].nil?
  set = setting['growl']
  growl = Notification::Growl.new set['appname'], set['host'], set['password'], set['port']
end

list.each do |server|
  observer = Observation::Server.new(server['ip_address'])
  services = server['services'].split(',').map &:strip
  downed = []

  services.each do |service|
    downed << service unless observer.observe service
  end

  unless downed.empty?
    alert = make_alert(downed)
    chat.notify "[#{observer.ip_address}] #{alert}" unless chat.nil?
    growl.notify observer.ip_address, alert, File.expand_path('../alert.png', __FILE__) unless growl.nil?
  end
end
