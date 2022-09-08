@opts = {
  db_dir: Arxutils_Sqlite3::Dbutil::DB_DIR,
  relation: {
    module: %w[<%= klass %> Dbutil],
    filename: "dbrelation.rb",
    dir: "lib"
  }
}
