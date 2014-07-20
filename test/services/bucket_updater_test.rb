require 'test_helper'

class BucketUpdaterTest < ActiveSupport::TestCase
  include UserHelpers

  test "team member can update bucket name" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :bucket_id => bucket.id,
        :team_id   => 203770, # member of https://github.com/orgs/hoytus/teams/team-b
        :bucket    => { :name => "Blocked" }
      }

      assert_equal "Current", bucket.name

      updated_bucket = BucketUpdater.process(user, params)

      assert_equal bucket.id, updated_bucket.id
      assert_equal "Blocked", updated_bucket.name
    end
  end

  test "team member can update bucket row order position" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      params = {
        :bucket_id => bucket.id,
        :team_id   => 203770, # member of https://github.com/orgs/hoytus/teams/team-b
        :bucket    => { :row_order_position => 1 }
      }

      assert_equal 0, bucket.row_order

      updated_bucket = BucketUpdater.process(user, params)

      assert_equal bucket.id, updated_bucket.id
      assert_equal 1, updated_bucket.row_order
    end
  end

  test "non-team member cannot update bucket name" do
    VCR.use_cassette method_name do
      bucket = buckets(:unauthorized_write)
      params = {
        :bucket_id => bucket.id,
        :team_id   => 203768, # member of https://github.com/orgs/hoytus/teams/owners
        :bucket    => { :name => "Blocked" }
      }

      assert_raises(NotAuthorized) { BucketUpdater.process(user, params) }
    end
  end

  test "non-team member cannot update bucket row order position" do
    VCR.use_cassette method_name do
      bucket = buckets(:unauthorized_write)
      params = {
        :bucket_id => bucket.id,
        :team_id   => 203768, # member of https://github.com/orgs/hoytus/teams/owners
        :bucket    => { :row_order_position => 1 }
      }

      assert_raises(NotAuthorized) { BucketUpdater.process(user, params) }
    end
  end
end
