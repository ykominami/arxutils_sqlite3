require "bundler/gem_tasks"
=begin
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs  << "test"
end

desc "Run test"
task default: :test
=end

#=begin
task default: %w[setup makeconfig migrate integrate]

task cmi: %w[makeconfig migrate integrate]

# コマンドラインで指定したクラス名を含むオプション指定用ハッシュの定義を含むRubyスクリ
# プトファイルの生成
task :setup do
  sh "bundle exec ruby exe/arxutils_sqlite3 --cmd=s --klass=Enop"
end
# DB構成情報の生成
task :makeconfig do
  sh "bundle exec ruby exe/arxutils_sqlite3 --cmd=c"
end
# マイグレート用スクリプトファイルの生成とマイグレートの実行
task :migrate do
  sh "bundle exec ruby exe/arxutils_sqlite3 --cmd=m --yaml=config/db_scheme.yml"
end
task :integrate do
  sh "bundle exec ruby exe/arxutils_sqlite3 --cmd=i"
end

task :delete do
  sh "bundle exec ruby exe/arxutils_sqlite3 --cmd=d"
end

#=end

