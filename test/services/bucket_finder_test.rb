require 'test_helper'

class BucketCreatorTest < ActiveSupport::TestCase
  include UserHelpers

  test "authorized user can find bucket for team" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :team_id   => bucket.team_id,
        :bucket_id => bucket.id
      }

      found_bucket = BucketFinder.process(user, params)

      assert_equal bucket, found_bucket
    end
  end

  test "authorized user cannot find bucket for wrong team" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :team_id   => 744774,   # when-apps owners team
        :bucket_id => bucket.id
      }

      assert_raises(ActiveRecord::RecordNotFound) { BucketFinder.process(user, params) }
    end
  end

  test "unauthorized user cannot find bucket for team" do
    VCR.use_cassette method_name do
      bucket = buckets(:unauthorized_read)
      params = {
        :team_id   => bucket.team_id,
        :bucket_id => bucket.id
      }

      assert_raises(NotAuthorized) { BucketFinder.process(user, params) }
    end
  end
end
