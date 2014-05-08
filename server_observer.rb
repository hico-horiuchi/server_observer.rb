#!/usr/local/bin/ruby

def full_path(file_name)
  File.expand_path File.join(File.dirname($0), file_name)
end

def make_alert(ip_address, downed)
  alert = "[#{ip_address}] #{downed.shift}"
  downed.each { |service| alert += ", #{service}" }
  alert += " is down!"
end

ENV['BUNDLE_GEMFILE'] = full_path('Gemfile')

require 'yaml'
require 'bundler/setup'
require full_path('lib/observation.rb')
require full_path('lib/notification.rb')

list = YAML.load_file full_path('config/list.yml')
setting = YAML.load_file full_path('config/setting.yml')
notifer = Notification::Chat.new setting['api'], setting['room_id']

list.each do |server|
  observer = Observation::Server.new(server['ip_address'])
  services = server['services'].split(',').map &:strip
  downed = []

  services.each do |service|
    downed << service unless observer.observe service
  end

  unless downed.empty?
    notifer.notify make_alert(observer.ip_address, downed)
  end
end
