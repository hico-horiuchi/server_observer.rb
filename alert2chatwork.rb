#!/usr/local/bin/ruby

ENV['BUNDLE_GEMFILE'] = File.expand_path File.join(File.dirname($0), 'Gemfile')
require 'bundler'
Bundler.require

current_directory = File.expand_path File.dirname(__FILE__)
require File.expand_path File.join(current_directory, 'lib/watcher.rb')
require File.expand_path File.join(current_directory, 'lib/alerter.rb')

watcher = Watcher.new 'list.yml'
messages = watcher.watch

alerter = Alerter.new 'config.yml'
alerter.alert messages
