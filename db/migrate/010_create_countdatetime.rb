class CreateCountdatetime < ActiveRecord::Migration[6.0]
  def self.up
    create_table :countdatetimes do |t|
    
      t.column :countdatetime, :datetime, :null => false
    
    end
  end

  def self.down
    drop_table :countdatetimes
  end
end
