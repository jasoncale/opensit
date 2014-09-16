atom_feed do |feed|
  feed.title @title
  feed.updated @updated

  @sits.each do |sit|
    next if sit.updated_at.blank?

    feed.entry(sit) do |entry|
      if sit.title.blank?
        entry.title "#{sit.duration} minute sit"
      else
        entry.title "Diary: #{sit.title}"
      end

      entry.author do |author|
        author.name(sit.user.display_name)
        author.uri("http://diaryforalan.com#{user_path(sit.user)}")
      end
      entry.content sit.body, :type => 'html'
      entry.updated(sit.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
    end
  end
end