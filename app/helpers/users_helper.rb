module UsersHelper
  # Display a hyperlinked user avatar
  # default size: 50x50
  def avatar(user, size = 0)
    if user.avatar.blank?
      if size.zero? 
        link_to user_path(user) do
          image_tag 'http://placehold.it/50x50', size: "50x50", alt: user.username, title: user.username, class: 'img-circle'
        end
      else 
        link_to user_path(user) do
          image_tag 'http://placehold.it/200x200', size: "200x200", alt: user.username, title: user.username
        end
      end
    else
      if size.zero?
        link_to user_path(user) do
          image_tag user.avatar.url(:small_thumb), size: "50x50", alt: user.username, title: user.username, class: 'img-circle'
        end
      else
        link_to user_path(user) do
          image_tag user.avatar.url(:thumb), size: "200x200", alt: user.username, title: user.username
        end
      end
    end
  end

  # Return a hyperlinked username / name
  # Pass plain for an unlinked name
  def username(user, plain = false)
    user.display_name if plain = false
    link_to "#{user.display_name}", user_path(user.id)
  end

  # Return link to website
  def website(user)
    link_to user.website, user.website
  end

  def timeline(dates)
    current_year = Time.now.year
    dates.map do |l|
      type, count = l
      if type.to_s.size == 4
        current_year = type
        '<div class="year">' + link_to("#{type}", "?y=#{type}") + " <span class=\"count\">(#{count})</span></div>"
      else
        "<li>" + link_to("#{Date::MONTHNAMES[type]}", "?y=#{current_year}&m=#{type}") + " <span class=\"count\">(#{count})</span></li>"
      end
    end.join(' ').html_safe
  end
end
