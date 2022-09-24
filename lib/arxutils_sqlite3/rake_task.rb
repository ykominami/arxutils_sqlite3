# Defining a task called default that depends on the tasks setup, makeconfig, migrate, and acr.
require "arxutils_sqlite3"
config = Arxutils_Sqlite3::Config.new

klass = nil
setting = config.load_setting_yaml_file
klass = setting[:klass]
klass = config.default_klass if klass.nil?

desc_arxutils_sqlite3 = "setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"

desc desc_arxutils_sqlite3.to_s
task arxutils_sqlite3: %w[arx:setup arx:copy_db_scheme arx:copy_opts arx:makeconfig arx:make_migrate_script arx:migrate arx:acr]

desc desc_arxutils_sqlite3.to_s
task "arx:arxutils_sqlite3": %w[arxutils_sqlite3]

desc "delete setup copy_db_scheme copy_opts makeconfig make_migrate_script migrate acr"
task "arx:bootstrap": %w[arx:delete arxutils_sqlite3]

desc "migrate acr"
task "arx:ma": %w[arx:migrate arx:acr]

desc "delete_db"
task "arx:b": %w[arx:delete_db]

desc "delete setting.yaml"
task "arx:ds": %w[arx:delete_setting]

# コマンドラインで指定したクラス名を含むオプション指定用ハッシュの定義を含むRubyスクリ
# プトファイルの生成
desc "produce setting.yml, db_scheme.yml.sample and opts.rb.sample with class name #{klass}"
task "arx:setup" do
  sh "bundle exec arxutils_sqlite3 --cmd=s --klass=#{klass}"
end

desc "copy from db_scheme.yml.sample to db_scheme.yml"
task "arx:copy_db_scheme" do
  sh "bundle exec arxutils_sqlite3 --cmd=cds"
end

desc "copy from opts.rb.sample to opts.rb"
task "arx:copy_opts" do
  sh "bundle exec arxutils_sqlite3 --cmd=co"
end

# DB構成情報の生成
desc "produce sqlite3.yml"
task "arx:makeconfig" do
  sh "bundle exec arxutils_sqlite3 --cmd=c"
end

# マイグレート用スクリプトファイルの生成
desc "produce migration scripts"
task "arx:make_migrate_script" do
  sh "bundle exec arxutils_sqlite3 --cmd=f --yaml=config/db_scheme.yml"
end
# マイグレートの実行
desc "execute migration"
task "arx:migrate" do
  sh "bundle exec arxutils_sqlite3 --cmd=m"
end

desc "call ActiveRecord instance method"
task "arx:acr" do
  sh "bundle exec arxutils_sqlite3 --cmd=a"
end

desc "delete configuration files adn migration scripts and db files"
task "arx:delete" do
  sh "bundle exec arxutils_sqlite3 --cmd=d"
end

desc "delete db files"
task "arx:delete_db" do
  sh "bundle exec arxutils_sqlite3 --cmd=b"
end

desc "delete setting yaml"
task "arx:delete_setting" do
  sh "bundle exec arxutils_sqlite3 --cmd=y"
end

desc "delete migrate scripts"
task "arx:delete_migrate" do
  sh "bundle exec arxutils_sqlite3 --cmd=dm"
end