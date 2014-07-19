require 'test_helper'

class BucketCreatorTest < ActiveSupport::TestCase
  include UserHelpers

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
