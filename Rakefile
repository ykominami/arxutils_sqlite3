task default: %w[setup makeconfig migrate integrate]

task :setup do
  sh "bundle exec ruby bin/arxutils-cli --cmd=s --klass=Enop"
end

task :makeconfig do
  sh "bundle exec ruby bin/arxutils-cli --cmd=c"
end

task :migrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=m --yaml=config/db_scheme.yml"
end

task :integrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=i"
end

task :remigrate do
  sh "bundle exec ruby bin/arxutils-cli --cmd=r -y config/db_scheme.yml"
end
