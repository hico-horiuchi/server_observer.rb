#!/usr/local/bin/ruby
require 'yaml'
require 'bundler'

ENV['BUNDLE_GEMFILE'] = File.expand_path File.join(File.dirname($0), 'Gemfile')
Bundler.require

current_directory = File.expand_path File.dirname(__FILE__)
require File.expand_path File.join(current_directory, 'lib/watcher.rb')
require File.expand_path File.join(current_directory, 'lib/alerter.rb')

messages = []

list = File.expand_path File.join(current_directory, 'list.yml')
YAML.load_file(list).each do |server|
  ip_address = server['ip_address']
  services = server['services'].split(',').map &:strip
  messages << Watcher.new(ip_address, services).watch
end
messages.delete('')

config = File.expand_path File.join(current_directory, 'config.yml')
alerter = Alerter.new config
messages.each do |message|
  alerter.alert message
end
