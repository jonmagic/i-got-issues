class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.string   :name,      :null => false
      t.integer  :row_order, :null => false, :default => 0

      t.timestamps
    end
  end
end
