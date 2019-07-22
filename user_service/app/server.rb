require "drb/drb"

url = "druby://0.0.0.0:8787"

class UserService
  def get_users
    [{ name: "hello" }, { name: "ok" }]
  end

  def get_user(id)
    return { name: "User {id} #{Time.now}" }
  end
end

$SAFE = 1
DRb.start_service(url, UserService.new)
DRb.thread.join
