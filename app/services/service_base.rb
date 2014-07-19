module ServiceBase
  module ClassMethods

    # Public: This is the public interface for a service and takes a User and a
    # params Hash. Can be overwritten in specific services if needed.
    #
    # user   - User instance.
    # params - Hash of params.
    #
    # See service #process for return definition.
    def process(user, params)
      new(user, params).process
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Internal: User passed in at initialization.
  attr_reader :user

  # Internal: Params Hash passed in at initialization.
  attr_reader :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  # Internal: GitHub client for user.
  #
  # Returns an Octokit::Client.
  def github_client
    user.github_client
  end
end
