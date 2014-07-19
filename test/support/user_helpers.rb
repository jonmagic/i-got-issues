module UserHelpers
  def user
    @user ||= begin
      user = User.new(:login => "jonmagic-test")
      user.github_client = Octokit::Client.new(:access_token => TEST_ACCESS_TOKEN)
      user
    end
  end
end
