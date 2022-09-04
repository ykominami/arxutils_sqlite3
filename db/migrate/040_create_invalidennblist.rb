class CreateInvalidennblist < ActiveRecord::Migration[6.0]
  def self.up
    create_table :invalidennblists do |t|
      t.column :org_id, :int, null: false
      t.column :count_id, :int, null: true
    end
  end

  def self.down
    drop_table :invalidennblists
  end
end
