install:
	bundle install

lint:
	bundle exec slim-lint app/views/
	bundle exec rubocop .

format_soft:
	bundle exec rubocop . -a

format_hard:
	bundle exec rubocop . -A

test:
	rake test
