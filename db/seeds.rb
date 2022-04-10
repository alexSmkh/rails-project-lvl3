# frozen_string_literal: true

users = []
categories = []

5.times do
  users << User.create(
    name: Faker::Internet.username,
    email: Faker::Internet.email
  )

  categories << Category.create(name: Faker::Commerce.department)
end

15.times do
  category = categories.sample

  bulletin = Bulletin.new(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph_by_chars(number: 1000),
    user: users.sample,
    category: category
  )

  url = Faker::LoremFlickr.image(size: '250x250', search_terms: [category.name])
  filename = File.basename(URI.parse(url).path)
  file = URI.open(url)
  bulletin.attach(io: file, filename: filename)
end
