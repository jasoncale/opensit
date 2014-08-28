module UsersHelper

  def small_avatar_of(user, location = nil)
    if location == 'nav'
      image_link = user.avatar.blank? ? image_path('/images/default_50.png') : user.avatar.url(:small_thumb)
      image_tag image_link, size: "38x38", alt: user.username, title: user.username
    else
      image_link = user.avatar.blank? ? image_path('/images/default_50.png') : user.avatar.url(:small_thumb)
      link_to user_path(user) do
        image_tag image_link, size: "50x50", alt: user.username, title: user.username
      end
    end
  end

  def large_avatar_of(user)
    if user.avatar.blank?
      image_tag image_path('/images/default_250.png'), size: "250x170", alt: user.username, title: user.username, class: 'img-circle'
    else
      link_to user_path(user) do
        image_tag user.avatar.url(:thumb), size: "250x250", alt: user.username, title: user.username, class: 'img-circle'
      end
    end
  end

  def sign_up_avatar(user)
    image_tag user.avatar.url(:thumb), size: "70x70", alt: user.username, title: user.username, class: 'img-circle'
  end

  # Return a hyperlinked username / name
  # Pass plain for an unlinked name
  def username(user, plain = false)
    return user.display_name if plain == true
    link_to "#{user.display_name}", user_path(user.username)
  end

  # Return link to website
  def website(user)
    if user.website =~ /^(http|https):\/\//
      link_to user.website, user.website
    else
      link_to user.website, "http://#{user.website}"
    end
  end

  def timeline(dates)
    current_year = Time.now.year
    dates.map do |l|
      type, count = l
      if type.to_s.size == 4
        current_year = type
        "<optgroup label='#{type} (#{count})'>"
      else
        "<option " + (current_year == params[:year].to_i && type == params[:month].to_i ? 'selected ' : '') + "value='" + "#{user_path(params[:username])}/#{params[:id]}?year=#{current_year}&month=#{type}" + "'>" + "#{Date::MONTHNAMES[type]}, #{current_year}</option>"
      end
    end.join(' ').html_safe
  end

  def joined_date(user)
    if Date.today.month == user.created_at.month
      user.created_at.strftime("%d %b")
    else
      "#{time_ago_in_words(user.created_at)} ago"
    end
  end
end
