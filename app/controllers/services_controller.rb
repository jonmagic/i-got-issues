class ServicesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create, :failure]

  def create
    current_service = Service.where(:provider => omnihash[:provider], :uid => omnihash[:uid]).first

    if logged_in?
      if current_service
        flash[:notice] = I18n.t("notifications.provider_already_connected", :provider => omnihash[:provider])
      else
        current_user.services.create!({
          provider: omnihash[:provider],
          uid: omnihash[:uid]
        })

        flash[:notice] = I18n.t("notifications.provider_added", :provider => omnihash[:provider])
      end
    else
      if current_service
        session[:user_id]            = current_service.user.id
        session[:service_id]         = current_service.id
        session[:oauth_token]        = omnihash[:credentials][:token]
        session[:oauth_token_secret] = omnihash[:credentials][:secret]
      else
        user         = User.new
        user.name    = omnihash[:info][:nickname]
        user.email   = omnihash[:info][:email]
        user_service = user.services.build({
          :provider => omnihash[:provider],
          :uid => omnihash[:uid]
        })

        if user.save!
          session[:user_id]            = user.id
          session[:service_id]         = user_service.id
          session[:oauth_token]        = omnihash[:credentials][:token]
          session[:oauth_token_secret] = omnihash[:credentials][:secret]

          flash[:notice] = I18n.t("notifications.account_created")
        end
      end
    end

    redirect_to buckets_path
  end

  def destroy
    service = current_user.services.find(params[:id])
    if service.respond_to?(:destroy) and service.destroy
      flash[:notice] = I18n.t("notifications.provider_unlinked", :provider => service.provider)
      redirect_to root_url
    end
  end

  def failure
    flash[:error] = I18n.t("notifications.authentication_error")
    redirect_to root_url
  end

  private
  def omnihash
    request.env["omniauth.auth"]
  end

  def omniauth_providers
    (OmniAuth::Strategies.local_constants.map(&:downcase) - %i(developer oauth oauth2)).map(&:to_s)
  end

  def redirect_path
    :services
  end
end
