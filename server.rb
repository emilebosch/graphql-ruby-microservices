require 'drb/drb'
url="druby://localhost:8787"

class TimeServer

	def hello
		"hwereld"
	end
  def get_current_time
    return {time: Time.now}
  end
end

$SAFE = 1
DRb.start_service(url, TimeServer.new)
DRb.thread.join