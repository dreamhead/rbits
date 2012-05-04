require 'rubygems'
require 'simplecov'
require 'rspec'

SimpleCov.start do
  add_filter 'spec'
end if ENV["COVERAGE"]

require File.expand_path(File.dirname(__FILE__) + '/../lib/rbits')