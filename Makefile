install:
	bundle install

lint:
	bundle exec rubocop .

format_soft:
	bundle exec rubocop . -a

format_hard:
	bundle exec rubocop . -A

test:
	rake test
