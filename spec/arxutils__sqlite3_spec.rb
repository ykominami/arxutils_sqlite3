# frozen_string_literal: true

RSpec.describe Arxutils_Sqlite3 do
  let(:config) { Arxutils_Sqlite3::Config.new }
  let(:var_self) { TestEnv.var_self_value }
  let(:ary) { config.setupx(var_self) }
  let(:opts) { ary[0] }
  let(:mod) { ary[1] }
  let(:acrecord) { 'config/opts.rb' }
  let(:db_scheme_file) { 'config/db_scheme.yml' }
  let(:env) { 'production' }
  let(:dbconfig) { Arxutils_Sqlite3::Config::DBCONFIG_SQLITE3 }
  let(:banner) { 'Usage: bundle exec arxutils_sqlite3 --cmd=(s|cds|co|c|f|m|a|d|del|b|y|dm) -y yaml_file --mod=mod' }
  let(:cli) { Arxutils_Sqlite3::Cli.new(config, dbconfig, env, acrecord, db_scheme_file, mod) }

  it 'has a version number' do
    expect(Arxutils_Sqlite3::VERSION).not_to be_nil
  end

  it 'cli setup', cmd: :s do
    #     expect {
    #       cli.setup(klass)
    #     }.to_not raise_error(StandardError)
    expect(cli.setup(mod)).to be(:SUCCESS)
  end

  it 'cli copy_db_scheme', cmd: :cds do
    #     expect {
    #       cli.copy_db_scheme
    #     }.to_not raise_error(StandardError)
    expect(cli.copy_db_scheme).to be_nil
  end

  it 'cli copy_opts_file', cmd: :co do
    expect(cli.copy_opts_file).to be_nil
    #     expect {
    #       cli.copy_opts_file
    #     }.to_not raise_error(StandardError)
  end

  it 'cli makeconfig', cmd: :c do
    expect(cli.makeconfig(opts)).to be_nil
    #     expect {
    #       cli.makeconfig(acrecord, banner, 30, opts)
    #     }.to_not raise_error(StandardError)
  end

  it 'cli setup_for_migrate', cmd: :f do
    # puts opts

    # yaml_fname = db_scheme_file
    # acrecord = opts[:acrecord]
    # yaml_pn = Pathname.new(yaml_fname)
    #     expect {
    #       cli.setup_for_migrate(yaml_pn, acrecord, klass)
    #     }.to_not raise_error(StandardError)
    expect(cli.setup_for_migrate).to be(:SUCCESS)
  end

  it 'cli migrate', cmd: :m do
    expect(cli.migrate).to eq([])
    #     expect {
    #       cli.migrate
    #     }.to_not raise_error(StandardError)
  end

  it 'cli acr', cmd: :a do
    expect(cli.acr).to be(:SUCCESS)
    #     expect {
    #       cli.acr
    #     }.to_not raise_error(StandardError)
  end
end
