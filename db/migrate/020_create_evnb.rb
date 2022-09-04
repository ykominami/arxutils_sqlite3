class CreateEvnb < ActiveRecord::Migration[6.0]
  def self.up
    create_table :evnbs do |t|
      t.column :time_id, :integer, null: false

      t.column :ennb_id, :integer, null: false
    end
  end

  def self.down
    drop_table :evnbs
  end
end
