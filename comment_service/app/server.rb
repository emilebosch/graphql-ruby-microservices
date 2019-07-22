require "drb/drb"

url = "druby://0.0.0.0:8787"

class CommentService
  def get_comment(id)
    { comment: "Comment {id} #{Time.now}" }
  end

  def get_comments
    [{ comment: "Comment {id} #{Time.now}" }]
  end
end

$SAFE = 1
DRb.start_service(url, CommentService.new)
DRb.thread.join
