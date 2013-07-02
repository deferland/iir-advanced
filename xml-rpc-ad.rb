require 'xmlrpc/client'
require 'pp'
# The settings are the  HTTP Headers - the PHP client sets many, but this is the minimum requirement
settings = {:cookies => [], :remote_addr => '0.0.0.0'}

# 'what' in our case is a Direct Selection
params = [
  what = 'zone:1',
  campaignId = 0,
  target = '',
  source = 'source1',
  withText = false,
  xmlContext = []
]

b = nil
begin
  server = XMLRPC::Client.new2("http://www.instrumentsinreach.com/openx/www/delivery/axmlrpc.php")
  b = server.call('openads.view', settings, *params)
  puts "HTML:"
  pp b['html']
  puts "Response:"
  pp b
rescue Exception => e
  puts e.message
end