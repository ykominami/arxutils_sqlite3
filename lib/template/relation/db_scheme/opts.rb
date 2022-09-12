@opts = {
  db_dir: Arxutils_Sqlite3::Config::DB_DIR,
  relation: {
    module: %w[<%= klass %> Dbutil],
    filename: "dbrelation.rb",
    dir: "lib"
  }
}
