require 'bundler'

begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'tiny-presto'
require 'presto-client'
