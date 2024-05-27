source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.7'
# Use jdbcmysql as the database for Active Record
gem 'activerecord-jdbcmysql-adapter'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'

  gem 'zip-zip'

  gem 'warbler'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  # Easy installation and use of web drivers to run system tests with browsers
end

group :production do
  gem 'addressable', '~> 2.8.6'
  gem 'matrix', '~> 0.4.2'
  gem 'regexp_parser', '~> 2.9.2'
  gem 'xpath', '~> 3.2.0'
  gem 'childprocess', '~> 4.1.0'
  gem 'rexml', '~> 3.2.8'
  gem 'rubyzip', '~> 1.2.4'
  gem 'public_suffix', '~> 5.0.5'
  gem 'strscan', '~> 3.1.0'
end

gem 'capybara', '~> 3.36.0'

gem 'webdrivers'

gem 'selenium-webdriver', '~> 4.1.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Gems for warble war
gem 'jruby-openssl'

gem 'sassc', '2.4.0'
