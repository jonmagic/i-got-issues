require 'test_helper'

class AccessTest < Capybara::Rails::TestCase
  test "unauthenticated user can access login" do
    visit "/"
    assert page.has_content? \
      "Please authenticate with GitHub to continue using the Issues application"
  end

  test "unauthenticated user cannot access teams" do
    visit "/teams"
    assert page.has_content? \
      "Please authenticate with GitHub to continue using the Issues application"
  end

  test "unauthenticated user cannot access a team" do
    visit team_path(prioritized_issues(:pi1).bucket.team)
    assert page.has_content? \
      "Please authenticate with GitHub to continue using the Issues application"
  end

  test "authenticated user can access teams" do
    VCR.use_cassette __name__ do
      login users("jonmagic-test")
      visit "/teams"
      assert page.has_content? "Team B"
    end
  end

  test "authenticated user can access a team" do
    VCR.use_cassette __name__ do
      login users("jonmagic-test")
      visit "/teams/203770"
      assert page.has_content? "Current"
      assert page.has_content? "Backlog"
      assert page.has_content? "Icebox"
      assert page.has_content? "fix the copy"
      assert page.has_content? "Fails when .env file doesn't exist"
      assert page.has_content? "It's dangerous to go alone. Take this!"
      assert page.has_css? ".js-write-access"
    end
  end

  test "authenticated user visiting / without default team is redirected to teams" do
    VCR.use_cassette __name__ do
      login users("jonmagic")
      visit "/"
      assert page.has_content? "Team B"
    end
  end

  test "authenticated user visiting / with default team is redirected to default team" do
    VCR.use_cassette __name__ do
      login users("jonmagic-test")
      visit "/"
      assert page.has_content? "Current"
      assert page.has_content? "Backlog"
      assert page.has_content? "Icebox"
      assert page.has_content? "fix the copy"
      assert page.has_content? "Fails when .env file doesn't exist"
      assert page.has_content? "It's dangerous to go alone. Take this!"
      assert page.has_css? ".js-write-access"
    end
  end

  test "authenticated user without default team cannot access team in another org" do
    VCR.use_cassette __name__ do
      login users("jonmagic")
      visit "/teams/15000"
      assert page.has_content? "Team B"
    end
  end

  test "authenticated user can read but not write to team they don't belong to" do
    VCR.use_cassette __name__ do
      login users("juliamae")
      visit "/teams/203770"
      refute page.has_css? ".js-write-access"
    end
  end
end
