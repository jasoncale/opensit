desc "Find object_type and object_id for existing notifications"
task :update_old_notifications => :environment do
  Notification.all.each do |notification|

    # if like
    if notification.message.include? 'like'
      like = Like.find_by(
        likeable_type: 'Sit',
        likeable_id: notification.link.split("/").last.to_i,
        user_id: notification.initiator
      )
      notification.update(object_type: 'like', object_id: like.nil? ? nil : like.id)

    # elsif comment
    elsif notification.message.include? 'comment'
      comment = Comment.find(notification.link.split("-").last.to_i)
      notification.update(object_type: 'comment', object_id: comment.nil? ? nil : comment.id)

    # elsif follow
    elsif notification.message.include? 'follow'
      follow = Relationship.find_by(
        follower_id: notification.initiator,
        followed_id: notification.user_id
      )
      notification.update(object_type: 'follow', object_id: follow.nil? ? nil : follow.id)

    end

    if notification.object_type.nil? or notification.object_id.nil?
      puts "PROBLEM: id #{notification.id}"
    end

  end
end
