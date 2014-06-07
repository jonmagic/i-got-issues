class Bucket < ActiveRecord::Base
  include RankedModel

  # Public: Bucket name.
  # column :name
  # Returns a String.
  validates :name, :presence => true

  # Public: Position of bucket.
  # column :row_order
  # Returns an Integer.
  validates :row_order, :presence => true
  ranks :row_order

  # Public: Change position of Bucket.
  #
  # position - Integer or symbol (:first, :last, :up, :down).
  def change_position(position)
    update_attribute :row_order_position, position
  end

  # column :created_at
  # column :updated_at
end
