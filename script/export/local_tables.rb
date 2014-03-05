require 'rubygems'
require 'active_record'

class LocalBase < ActiveRecord::Base
		self.abstract_class = true
		#self.pluralize_table_names = false
		self.store_full_sti_class = false
end

db_config = YAML::load_file(File.join(File.dirname(__FILE__), '..', '..', 'config', 'database.yml'))
LocalBase.establish_connection db_config['development']
LocalBase.connection.execute("set names 'utf8'")

class ForagerPost < LocalBase
end

class ForagerRunKey < LocalBase
end

class AdminForager < LocalBase
end

class AdminChannel < LocalBase
end

class AdminPage < LocalBase
end

