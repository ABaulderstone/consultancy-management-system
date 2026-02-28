module Users
  module EmailGeneratable
    def generate_email(id, first_name, last_name)
      padded_id = id.to_s.rjust(4, "0")
      "#{first_name.downcase}.#{last_name.downcase}.#{padded_id}@example.com"
    end
  end
end
