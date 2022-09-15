# Defining a task called default that depends on the tasks setup, makeconfig, migrate, and acr.
require "arxutils_sqlite3"
config = Arxutils_Sqlite3::Config.new

klass = nil
setting = config.load_setting_yaml_file
klass = setting[:klass]

desc "setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"
task arxutil_sqlite3: %w[setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr]

desc "delete setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"
task bootstrap: %w[delete arxutil_sqlite3]

desc "migrate acr"
task ma: %w[migrate acr]

desc "delete_db"
task b: %w[delete_db]

# コマンドラインで指定したクラス名を含むオプション指定用ハッシュの定義を含むRubyスクリ
# プトファイルの生成
desc "produce setting.yml, db_scheme.yml.sample and opts.rb.sample with class name #{klass}"
task :setup do
  sh "bundle exec arxutils_sqlite3 --cmd=s --klass=#{klass}"
end

desc "copy from db_scheme.yml.sample to db_scheme.yml"
task :copy_db_scheme do
  sh "bundle exec arxutils_sqlite3 --cmd=cds"
end

desc "copy from opts.rb.sample to opts.rb"
task :copy_opts do
  sh "bundle exec arxutils_sqlite3 --cmd=co"
end

# DB構成情報の生成
desc "produce sqlite3.yml"
task :makeconfig do
  sh "bundle exec arxutils_sqlite3 --cmd=c"
end

# マイグレート用スクリプトファイルの生成
desc "produce migration scripts"
task :make_migrate_script do
  sh "bundle exec arxutils_sqlite3 --cmd=f --yaml=config/db_scheme.yml"
end
# マイグレートの実行
desc "execute migration"
task :migrate do
  sh "bundle exec arxutils_sqlite3 --cmd=m"
end

desc "call ActiveRecord instance method"
task :acr do
  sh "bundle exec arxutils_sqlite3 --cmd=a"
end

desc "delete configuration files adn migration scripts and db files"
task :delete do
  sh "bundle exec arxutils_sqlite3 --cmd=d"
end

desc "delete db files"
task :delete_db do
  sh "bundle exec arxutils_sqlite3 --cmd=b"
end
