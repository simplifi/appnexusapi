require "rubygems"
require "bundler/setup"
require "faraday"
require "appnexusapi/version"
require "appnexusapi/error"

module AppnexusApi
  autoload :Connection, "appnexusapi/connection"

  dir = File.dirname(__FILE__) + "/appnexusapi"
  files = Dir.glob(File.expand_path("{*resource,*service}.rb", dir)).map{|f| File.basename(f, '.rb')}
  files.each do |file|
    sym = file.capitalize.gsub(/(_(.))/) { |c| $2.upcase }.to_sym
    autoload sym, "appnexusapi/#{file}"
  end

end
