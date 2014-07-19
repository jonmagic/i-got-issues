require 'test_helper'

class BucketCreatorTest < ActiveSupport::TestCase
  def user
    @user ||= begin
      user = User.new(:login => "jonmagic-test")
      user.github_client = Octokit::Client.new(:access_token => TEST_ACCESS_TOKEN)
      user
    end
  end

  test "team member can create bucket" do
    VCR.use_cassette method_name do
      params = {
        :team_id => 203770, # member of https://github.com/orgs/hoytus/teams/team-b
        :bucket => { :name => "foo" }
      }

      assert_difference("Bucket.count", 1) { BucketCreator.process(user, params) }
    end
  end

  test "non-team member cannot create bucket" do
    VCR.use_cassette method_name do
      params = {
        :team_id => 203768, # not a member of https://github.com/orgs/hoytus/teams/owners
        :bucket => { :name => "foo" }
      }

      assert_raises(NotAuthorized) { BucketCreator.process(user, params) }
    end
  end
end
