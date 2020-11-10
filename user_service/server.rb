$stdout.sync = true
require "drb/drb"

class UserService
  def users
    @user ||= [
      { name: "Emile" },
      { name: "Wiebe" },
      { name: "Rene" },
    ]
  end

  def get_users
    users
  end

  def create_user(name)
    new_user = { name: name }
    users << new_user
    new_user
  end

  def get_user(id)
    users[id]
  end
end

$SAFE = 1
url = "druby://0.0.0.0:8787"
DRb.start_service(url, UserService.new)
DRb.thread.join
