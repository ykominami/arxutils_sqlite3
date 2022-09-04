class CreateEnnblist < ActiveRecord::Migration[6.0]
  def self.up
    create_table :ennblists do |t|
      t.column :stack, :string, null: false

      t.column :notebook, :string, null: false

      t.column :count, :integer, null: false

      t.column :tag_count, :integer, null: false

      t.column :start_datetime, :datetime, null: false
    end
  end

  def self.down
    drop_table :ennblists
  end
end
