source 'http://ruby.taobao.org'
ruby '2.0.0'
gem 'rails', '~> 4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '>= 3.0.0.0'
gem 'bootstrap-will_paginate'
gem 'font-awesome-rails'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'mysql2', '0.3.13'
gem 'rolify'
gem 'simple_form'
gem 'acts-as-taggable-on'

# For linux
gem 'therubyracer', :platform=>:ruby
gem 'puma'

#page caching
# http://www.rubytutorial.io/page-caching-with-rails-4
gem 'actionpack-page_caching'
#gem 'rails-observers' #manually remove the cache pages on raincms

#Liquid templete html
gem 'liquid'

#add :git to bugfix open dialog error
gem "ckeditor", :git => "git@github.com:galetahub/ckeditor.git"
#File upload
gem 'paperclip'
gem 'paperclip-qiniu'

#Excel processing
# gem 'roo', '>=1.11.2' 
# gem 'rubyzip', "~> 0.9.9" #fix the error: cannot load such file -- zip/zipfilesystem

#Wizard
#gem 'wicked'


#I18n
gem 'rails-i18n', '~> 4.0.0.pre' # For 4.0.x
gem 'i18n_yaml_generator'

#Queue
#gem 'sidekiq'

#Markdown syntax
gem "nokogiri"
gem "htmlentities"
gem 'slodown'

#Send Mail
gem 'mailgun'

#Pinyin.t('中国', splitter: '-') => "zhong-guo"
gem 'chinese_pinyin'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
end
group :development, :test do
  gem 'rspec-rails'
end
group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end
