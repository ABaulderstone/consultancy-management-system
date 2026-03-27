module Users::Sluggable
  private
    def generate_slug(first_name:, last_name:, user_id:)
      base = "#{first_name} #{last_name}".parameterize
      "#{base}-#{user_id}"
    end

    def update_slug!(profile)
      new_slug = generate_slug(first_name: profile.first_name, last_name: profile.last_name, user_id: profile.user_id)
      return if new_slug == profile.slug
      if profile.slug.present?
        SlugHistory.create!(slug: profile.slug, user_id: profile.user_id, expires_at: Time.current + 30.days)
      end
      profile.update_column(:slug, new_slug)
    end
end
