#!/usr/local/bin/ruby

def full_path(file_name)
  File.expand_path File.join(File.dirname($0), file_name)
end

def make_alert(downed)
  alert = downed.shift
  downed.each { |service| alert += ", #{service}" }
  alert += ' is down!'
end

ENV['BUNDLE_GEMFILE'] = full_path('Gemfile')

require 'yaml'
require 'bundler/setup'
require full_path('lib/observation.rb')
require full_path('lib/notification.rb')

list = YAML.load_file full_path('config/list.yml')
setting = YAML.load_file full_path('config/setting.yml')

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
    growl.notify observer.ip_address, alert, full_path('alert.png') unless growl.nil?
  end
end
