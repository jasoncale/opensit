module SitsHelper
  
  # Display a user avatar
  # default without size: 50x50
  def avatar(user, size = 0)
    if user.avatar.blank?
      size.zero? ? image_tag('http://placehold.it/50x50') : image_tag('http://placehold.it/100x100')
    else
      size.zero? ? image_tag(user.avatar.small_thumb) : image_tag(user.avatar.thumb) 
    end
  end

  # Return a hyperlinked username
  def username(user)
    if user.first_name.empty?
      link_to user.username, user_path(user.id)
    else
      link_to "#{user.first_name} #{user.last_name}", user_path(user.id)
    end
  end

  # Return location
  def location(user)
    "#{user.city}, #{user.country}"
  end
  
end
