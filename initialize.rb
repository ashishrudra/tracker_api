%w(. ./lib/ ./app/).each do |path|
  $LOAD_PATH << path
end

require "bundler/setup"
Bundler.setup(:default)

require "app"
Bundler.require(:default, GG.env.to_sym)

#Dir.glob("config/initializers/**/*").sort.each do |initializers|
#  require initializers
#end
