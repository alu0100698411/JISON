source 'https://rubygems.org'
ruby '2.0.0'

gem "sinatra"
gem "sinatra-contrib"
gem "sinatra-flash"
gem "thin"
gem 'data_mapper'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'
gem 'sass'

group :development do
  gem 'dm-sqlite-adapter'
  gem 'do_sqlite3'
end

#bundle install --without production
group :production do
  gem 'pg'
  gem 'dm-postgres-adapter' 
end
