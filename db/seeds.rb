# frozen_string_literal: true

users = []
category_names = %w[Sport Books IT Cats Dogs]
categories = []

5.times do |i|
  users << User.create(
    name: Faker::Internet.username,
    email: Faker::Internet.email
  )

  categories << Category.create(name: category_names[i])
end

15.times do
  category = categories.sample

  bulletin = Bulletin.new(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph_by_chars(number: 1000),
    user: users.sample,
    category: category,
    state: 'under_moderation'
  )

  url = Faker::LoremFlickr.image(size: '400x400', search_terms: [category.name])
  parsed_url = URI.parse(url)
  filename = File.basename(parsed_url.path)
  bulletin.image.attach(io: parsed_url.open, filename: filename)
  bulletin.save
end
