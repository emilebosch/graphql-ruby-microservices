require "drb/drb"

class UserService
  def get_users
    [{ name: "Emile" }, { name: "Chris" }, { name: "Karens" }]
  end

  def get_user(id)
    { name: "Emile #{id} #{Time.now}" }
  end
end

$SAFE = 1
url = "druby://0.0.0.0:8787"
DRb.start_service(url, UserService.new)
DRb.thread.join
