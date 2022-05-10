# frozen_string_literal: true

users = []
category_names = %w[Sport Books Cats Dogs Fruits]
categories = []
bulletin_states = [
  Bulletin::STATE_DRAFT,
  Bulletin::STATE_UNDER_MODERATION,
  Bulletin::STATE_PUBLISHED,
  Bulletin::STATE_REJECTED,
  Bulletin::STATE_ARCHIVED
]

5.times do |i|
  users << User.create(
    name: Faker::Internet.username,
    email: Faker::Internet.email
  )

  categories << Category.create(name: category_names[i])
end

45.times do
  category = categories.sample

  bulletin = Bulletin.new(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph_by_chars(number: 1000),
    user: users.sample,
    category: category,
    state: bulletin_states.sample
  )

  url = Faker::LoremFlickr.image(size: '400x400', search_terms: [category.name])
  parsed_url = URI.parse(url)
  filename = File.basename(parsed_url.path)
  bulletin.image.attach(io: parsed_url.open, filename: filename)
  bulletin.save
end
