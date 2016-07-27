class IntApi::MarketplacesController < ApplicationController

  #skip_filter :fetch_community, :check_http_auth

  before_filter :set_access_control_headers

  NewMarketplaceForm = Form::NewMarketplace

  # Creates a marketplace and an admin user for that marketplace
  def create
    form = NewMarketplaceForm.new(params)
    return render status: 400, json: form.errors unless form.valid?

    # As there's no community yet, we store the global service name to thread
    # so that mail confirmation email is sent from global service name instead
    # of the just created marketplace's name
    ApplicationHelper.store_community_service_name_to_thread(APP_CONFIG.global_service_name)

    marketplace = MarketplaceService::API::Marketplaces.create(
      params.slice(:marketplace_name,
                   :marketplace_type,
                   :marketplace_country,
                   :marketplace_language)
            .merge(payment_process: :preauthorize)
    )

    # Create initial trial plan
    plan = {
      expires_at: Time.now.change({ hour: 9, min: 0, sec: 0 }) + 31.days
    }
    PlanService::API::Api.plans.create_initial_trial(community_id: marketplace[:id], plan: plan)

    if marketplace
      TransactionService::API::Api.settings.provision(
        community_id: marketplace[:id],
        payment_gateway: :paypal,
        payment_process: :preauthorize,
        active: true)
    end

    user = UserService::API::Users.create_user({
        given_name: params[:admin_first_name],
        family_name: params[:admin_last_name],
        email: params[:admin_email],
        password: params[:admin_password],
        locale: params[:marketplace_language]},
        marketplace[:id]).data

    auth_token = UserService::API::AuthTokens.create_login_token(user[:id])
    url = URLUtils.append_query_param(marketplace[:url], "auth", auth_token[:token])

    assign_onboarding_feature_flag(community_id: marketplace[:id])

    # TODO handle error cases with proper response

    render status: 201, json: {"marketplace_url" => url, "marketplace_id" => marketplace[:id]}
  end

  def login
    if params[:email].present?
      person_id = Email.select('person_id').find_by_address params[:email].to_s
      person = Person.find person_id.person_id 
      if !person_signed_in?
        sign_in(person)
      end      
    end
    render json: {
      status: 200,
      message: "Successfully created Login.",
      person_id: person_id.person_id
    }.to_json
  end 
  
  def signup
    if params.present?
      @current_community = Community.first
      puts "*"*500 , params , "*"*500
      # Make person a member of the current community
      @person = UserService::API::Users.create_user({
          given_name: params[:first_name],
          family_name: params[:last_name],
          email: params[:email],
          password: params[:password],
          locale: params[:marketplace_language]},
          1 )
      render  json: ["Successful"], status:  200 
    else
      render json: ["Unsuccessful"] , status: 400
    end

  end

  def create_prospect_email
    email = params[:email]
    render json: [ "Email missing from payload" ], :status => 400 and return if email.blank?

    ProspectEmail.create(:email => email)

    head 200, content_type: "application/json"
  end

  private

  def set_access_control_headers
    # TODO change this to more strict setting when done testing
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def assign_onboarding_feature_flag(community_id:)
    if(rand < 0.5)
      FeatureFlagService::API::Api.features.enable(community_id: community_id, features: [:onboarding_redesign_v1])
    end
  end

end
