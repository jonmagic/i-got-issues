require 'test_helper'

class BucketsFinderTest < ActiveSupport::TestCase
  include UserHelpers

  test "authorized user can find buckets for team" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :team_id   => bucket.team_id
      }

      assert BucketsFinder.process(user, params).any?
    end
  end

  test "unauthorized user cannot find buckets for team" do
    VCR.use_cassette method_name do
      bucket = buckets(:unauthorized_read)
      params = {
        :team_id   => bucket.team_id
      }

      assert_raises(NotAuthorized) { BucketsFinder.process(user, params) }
    end
  end
end
