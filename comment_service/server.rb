require "drb/drb"

class CommentService
  def get_comment(id)
    { comment: "Pretty fancy comment #{id} #{Time.now}" }
  end

  def get_comments
    [{ comment: "Wow so nice #{Time.now}" }]
  end
end

$SAFE = 1
url = "druby://0.0.0.0:8787"
DRb.start_service(url, CommentService.new)
DRb.thread.join
