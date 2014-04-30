#!/usr/local/bin/ruby
require 'yaml'

ENV['BUNDLE_GEMFILE'] = File.expand_path File.join(File.dirname($0), 'Gemfile')
require 'bundler'
Bundler.require

current_directory = File.expand_path File.dirname(__FILE__)
require File.expand_path File.join(current_directory, 'lib/watcher.rb')
require File.expand_path File.join(current_directory, 'lib/alerter.rb')

list = File.expand_path File.join(current_directory, 'list.yml')
watcher = Watcher.new list
messages = watcher.watch

config = File.expand_path File.join(current_directory, 'config.yml')
alerter = Alerter.new config
alerter.alert messages
