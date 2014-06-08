class Service < ActiveRecord::Base
  # column :user_id
  belongs_to :user

  # column :uid
  # column :provider
  # column :created_at
  # column :updated_at
end
