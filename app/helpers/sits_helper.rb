module SitsHelper
  
  ##
  # Display a user avatar
  # default without size: 30x30

  def avatar(user, size = 0)
    if user.avatar.blank?
      size.zero? ? image_tag('http://placehold.it/30x30') : image_tag('http://placehold.it/100x100')
    else
      size.zero? ? image_tag(user.avatar.small_thumb) : image_tag(user.avatar.thumb) 
    end
  end
end
