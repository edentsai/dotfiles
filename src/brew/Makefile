

brew-bundle-dump:
	@brew bundle dump --describe --file=/dev/stdout \
		| sed -e $$'s/^# /\\\n# /g' \
		| tee Brewfile

brew-bundle-install:
	@brew bundle install --verbose --file=Brewfile
