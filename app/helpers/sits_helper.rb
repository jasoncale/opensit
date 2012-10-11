module SitsHelper
  
  ##
  # Display a user avatar
  # default without size: 30x30
  #
  def avatar(user, size = 0)
    if user.avatar.blank?
      size.zero? ? image_tag('http://placehold.it/50x50') : image_tag('http://placehold.it/100x100')
    else
      size.zero? ? image_tag(user.avatar.small_thumb) : image_tag(user.avatar.thumb) 
    end
  end
  
  ##
  # Print a hyperlinked username
  #
  def username(user)
    link_to user.username, user_path(user.id)
  end
end
