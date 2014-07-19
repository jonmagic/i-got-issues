class AuditEntry < ActiveRecord::Base
  # Public: Actor id.
  # column :actor_id
  # Returns an Integer.
  validates :actor_id, :presence => true

  # Public: Actor login.
  # column :actor_login
  # Returns a String.

  # Public: Actor email.
  # column :actor_email
  # Returns a String.

  # Public: The action the actor is taking on the target.
  # column :service_class
  # Returns a Symbol
  validates :service_class, :presence => true

  # Public: The class name of the target.
  # column :target_class
  # Returns constantized class.
  def target_class
    read_attribute(:target_class).constantize
  end
  validates :target_class, :presence => true

  # Public: Target id.
  # column :target_id
  # Returns an Integer.
  validates :target_id, :presence => true

  # Public: Hash of target attributes after action.
  # column :target_attributes
  # Returns a Hash.

  # Public: Hash of model changes (before/after values).
  # column :target_changes
  # Returns a Hash.

  # Public: Controller params, including controller name, action, and
  # any get/post parameters.
  # column :controller_params
  # Returns a Hash.

  # Public: Created at timestamp.
  # column :created_at
  # Returns an ActiveSupport::TimeWithZone.
end
