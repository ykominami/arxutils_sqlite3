require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs  << "test"
end

#desc "Run test"
#task default: :test

# Defining a task called default that depends on the tasks setup, makeconfig, migrate, and acr.

desc "setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"
task default: %w[setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr]

desc "delete setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"
task bootstrap: %w[delete setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr]

desc "setup makeconfig migrate acr"
task scfma: %w[setup makeconfig migrate acr]

desc "delete setup makeconfig"
task dsc: %w[delete setup makeconfig]

desc "delete setup"
task ds: %w[delete setup]

desc "setup"
task s: %w[setup]

desc "setup makeconfig"
task sc: %w[setup makeconfig]

desc "delete setup makeconfig migrate"
task dscm: %w[delete setup makeconfig migrate]

desc "setup makeconfig migrate"
task scm: %w[setup makeconfig migrate]

desc "delete setup makeconfig migrate acr"
task dscma: %w[delete setup makeconfig migrate acr]

desc "setup makeconfig migrate acr"
task scma: %w[setup makeconfig migrate acr]

desc "migrate acr"
task ma: %w[migrate acr]

desc "delete_db migrate acr"
task bma: %w[delete_db migrate acr]

desc "delete_db"
task b: %w[delete_db]

# コマンドラインで指定したクラス名を含むオプション指定用ハッシュの定義を含むRubyスクリ
# プトファイルの生成
desc "produce setting.yml, db_scheme.yml.sample and opts.rb.sample with class name Enop"
task :setup do
  sh "bundle exec arxutils_sqlite3 --cmd=s --klass=Enop"
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


