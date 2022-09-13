# frozen_string_literal: true

RSpec.describe Arxutils_Sqlite3 do
  let(:config) { Arxutils_Sqlite3::Config.new }
  let(:cli) { Arxutils_Sqlite3::Cli.new(config) }
  let(:env) { "production" }
  let(:dbconfig) { Arxutils_Sqlite3::Config::DBCONFIG_SQLITE3 }
  let(:banner) { 'Usage: bundle exec arxutils_sqlite3 --cmd=(s|c|m|i|d|b) -y yaml_file --klass=class' } 

  it "has a version number" do
    expect(Arxutils_Sqlite3::VERSION).not_to be_nil
  end

  it "makeconfig" , cmd: :c do
    exit_code = 30
    db_scheme_ary, opts, env = TestData.setup
    relation = opts[:relation]
    cli.rm_dbconfig(dbconfig)
    ret = cli.makeconfig(dbconfig, relation, banner, exit_code, opts)
    expect(ret).to be_nil
  end

  it "migrate" , cmd: :i do
    db_scheme_ary, opts, env = TestData.setup
    relation = opts[:relation]
    klass = "Enop"
    yaml_fname = "config/db_scheme.yml"
    yaml_pn = Pathname.new(yaml_fname)

    ret = cli.migrate(yaml_pn, relation, klass, dbconfig, env)
    expect(ret).to eq([])
  end
end
