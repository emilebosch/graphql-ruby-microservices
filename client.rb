require 'drb/drb'
require 'benchmark'

DRb.start_service

SERVER_URI="druby://0.0.0.0:8787"

ts = DRbObject.new_with_uri(SERVER_URI)
p ts.get_user(1)

# Benchmark.bm do |x|    
# 	x.report {10000.times {ts.get_current_time}}
# end
