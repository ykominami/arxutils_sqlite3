task default: %w[setup migrate integrate]

task :setup do
  sh "bundle exec ruby bin/arxutils-cli --cmd=s --klass=Enop"
end

task :migrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=m"
end

task :integrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=i"
end

task :remigrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=r -y config/db_scheme.yml"
end
