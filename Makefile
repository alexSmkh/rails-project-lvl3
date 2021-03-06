install:
	bundle install
	bundle exec rails webpacker:install

lint:
	bundle exec slim-lint app/views/
	bundle exec rubocop .

format:
	bundle exec rubocop . -A

tests:
	rake test
	bin/rails test:system
