module ServiceAudit
  def log(actor, target, params={})
    return if target.new_record?
    return if target.changed?

    AuditEntry.create do |entry|
      entry.actor_id          = actor.id
      entry.actor_login       = actor.login
      entry.actor_email       = actor.email
      entry.service_class     = service_class
      entry.target_class      = target.class.name
      entry.target_id         = target.id
      entry.target_attributes = target.attributes
      entry.target_changes    = target.previous_changes
      entry.controller_params = params if params.present?
    end
  end

  def service_class
    self.class.name
  end
end
