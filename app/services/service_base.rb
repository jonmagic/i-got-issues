module ServiceBase
  module ClassMethods

    # Public: This is the public interface for a service and takes a User and a
    # params Hash. Can be overwritten in specific services if needed.
    #
    # actor  - User instance.
    # params - Hash of params.
    #
    # See service #process for return definition.
    def process(actor, params)
      new(actor, params).process
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Internal: User passed in at initialization.
  attr_reader :actor

  # Internal: Params Hash passed in at initialization.
  attr_reader :params

  def initialize(actor, params)
    @actor = actor
    @params = params
  end
  
  # Internal: GitHub client for actor.
  #
  # Returns an Octokit::Client.
  def github_client
    actor.github_client
  end
end
