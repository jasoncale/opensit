module UsersHelper
  # Display a hyperlinked user avatar
  # default size: 50x50
  def avatar(user, size = 0)
    if user.avatar.blank?
      if size.zero? 
        link_to user_path(user) do
          image_tag('http://placehold.it/50x50', :alt => user.username, :title => user.username)
        end
      else 
        link_to user_path(user) do
          image_tag('http://placehold.it/100x100', :alt => user.username, :title => user.username)
        end
      end
    else
      if size.zero?
        link_to user_path(user) do
          image_tag(user.avatar.small_thumb, :alt => user.username, :title => user.username)
        end
      else
        link_to user_path(user) do
          image_tag(user.avatar.thumb, :alt => user.username, :title => user.username)
        end
      end
    end
  end

  # Return a hyperlinked username / name
  # Pass plain for an unlinked name
  def username(user, plain = false)
    if plain
      if user.first_name.blank?
        user.username
      else
        "#{user.first_name} #{user.last_name}"
      end
    else
      if user.first_name.blank?
        link_to user.username, user_path(user.id)
      else
        link_to "#{user.first_name} #{user.last_name}", user_path(user.id)
      end
    end
  end

  # Unlinked username / name
  def full_name(user)

  end

  # Return link to website
  def website(user)
    link_to user.website, user.website
  end
end
