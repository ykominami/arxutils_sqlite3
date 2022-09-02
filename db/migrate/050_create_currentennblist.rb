class CreateCurrentennblist < ActiveRecord::Migration[6.0]
  def self.up
    execute <<-SQL
      CREATE VIEW currentennblists AS SELECT id as org_id,
stack , notebook , count , tag_count , start_datetime    
      FROM ennblists where not exists (select * from invalidennblists where invalidennblists.org_id = ennblists.id )
    SQL
  end

  def self.down
    execute <<-SQL
      DROP VIEW currentennblists
    SQL
  end
end
