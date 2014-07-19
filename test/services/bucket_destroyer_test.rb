require 'test_helper'

class BucketDestroyerTest < ActiveSupport::TestCase
  include UserHelpers

  test "team member can destroy a bucket" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :id      => bucket.id,
        :team_id => 203770 # member of https://github.com/orgs/hoytus/teams/team-b
      }

      bucket = BucketDestroyer.process(user, params)

      assert_equal 203770, bucket.team_id
      assert_raises(ActiveRecord::RecordNotFound) { bucket.reload }
    end
  end

  test "non-team member cannot destroy bucket" do
    VCR.use_cassette method_name do
      bucket = buckets(:unauthorized_current)
      params = {
        :id      => bucket.id,
        :team_id => 203768 # not a member of https://github.com/orgs/hoytus/teams/owners
      }

      assert_raises(NotAuthorized) { BucketDestroyer.process(user, params) }
    end
  end
end
