# frozen_string_literal: true

require "arxutils_sqlite3"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

AR_VERSION = 6.0
TEST_DATA_DIR = Pathname(__FILE__).parent.join("test_data")

# Migrate.migrateのテスト実行用メソッド
class TestData
  def self.setup
    db_scheme_ary = [
      {
        flist: %w[noitem],
        classname: "Countdatetime",
        classname_downcase: "countdatetime",
        items: [
          %w[countdatetime datetime false]
        ],
        plural: "countdatetimes",
        ar_version: AR_VERSION
      },

      {
        flist: %w[noitem],
        classname: "Evnb",
        classname_downcase: "evnb",
        items: [
          %w[time_id integer false],
          %w[ennb_id integer false]
        ],
        plural: "evnbs",
        ar_version: AR_VERSION
      },

      {
        flist: %w[noitem invalid current],
        classname: "Ennblist",
        classname_downcase: "ennblist",
        items: [
          %w[stack string false],
          %w[notebook string false],
          %w[count integer false],
          %w[tag_count integer false],
          %w[start_datetime datetime false]
        ],
        plural: "ennblists",
        ar_version: AR_VERSION
      }
    ]

    opts = {
      db_dir: Arxutils_Sqlite3::Config::DB_DIR,
      relation: {
        module: %w[Enop Dbutil],
        filename: "dbrelation.rb",
        dir: "lib/arxutils_sqlite3/dbutil"
      }
    }
    opts["dbconfig"] = Arxutils_Sqlite3::Config::DBCONFIG_SQLITE3 unless opts["dbconfig"]

    env = ENV.fetch("ENV", nil)
    # env ||= "development"
    env ||= "production"

    [db_scheme_ary, opts, env]
  end
end
