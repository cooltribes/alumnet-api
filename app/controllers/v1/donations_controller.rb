class V1::DonationsController < V1::BaseController
  skip_before_action :authenticate

  def products
    @products = Product.active.joins(:categories).where(categories: {name: "Donations"}).order('total_price asc')
  end

  def get_product
  	@product = Product.find(params[:id])
  	unless @product.present?
      render json: { error: "Product not found" }, status: 404
    end
  end

  def countries
    @q = Country.ransack(params[:q])
    @countries = @q.result
  end

  def cities
    @country = Country.find(params[:country_id])
    @q = @country.cities.ransack()
    @cities = @q.result.order(name: :asc)
  end

  def committees
    @country = Country.find(params[:country_id])
    other_committee = Committee.find_by(name: "Other")
    @q = @country.committees.ransack(params[:q])
    @committees = @q.result | [other_committee]
    @committees = @q.result.order(name: :asc)
  end

  def details
    @total_sold = UserProduct.where(feature: 'donation').sum(:total_price)
    @donors = UserProduct.where(feature: 'donation').uniq.pluck(:user_id).count
    @countries = UserProduct.where(feature: 'donation').includes(user: :profile).uniq.pluck(:residence_city_id, "profiles.residence_country_id").count
  end

  def update_user
    @user = User.find(params[:user_id])
    if @user.present?
      profile = @user.profile
      name_array = params[:user][:name].split
      first_name = ''
      last_name = ''
      case name_array.size # a_variable is the variable we want to compare
      when 1    #compare to 1
        first_name = name_array[0]
      when 2    #compare to 2
        first_name = name_array[0]
        last_name = name_array[1]
      when 3
        first_name = name_array[0]+name_array[1]
        last_name = name_array[2]
      when 4
        first_name = name_array[0]+name_array[1]
        last_name = name_array[2]+name_array[3]
      else
        first_name = params[:user][:name]
      end
      profile.first_name = first_name
      profile.last_name = last_name
      profile.gender = params[:user][:gender]
      profile.born = params[:user][:birthdate]
      profile.residence_country_id = params[:residence][:country]

      @user.new_password_reset_token
      mailer = GeneralMailer.new
      mailer.user_registration_from_crowdfunding(@user, first_name, params[:password])

      if profile.save
        experience = Experience.new
        experience.exp_type = 0
        experience.name = 'LC Member'
        experience.description = 'I joined AIESEC this year and started one of the most incredible experiences in my life by knowing amazing people, attending to spectacular events, learning incredible skills and...'
        experience.start_date = '01/01/'+params[:experience][:start_year]
        experience.end_date = '31/12/'+params[:experience][:start_year]
        experience.organization_name = ''
        experience.city_id = params[:experience][:city]
        experience.country_id = params[:experience][:country]
        experience.internship = 0
        experience.profile_id = profile.id
        experience.committee_id = params[:experience][:committee]
        experience.aiesec_experience = 'International'
        experience.privacy = 2
        experience.current = false

        if experience.save
          render :user, status: :created,  location: @user
        else
          render json: { errors: experience.errors }, status: :unprocessable_entity
        end
      else
        render json: { errors: profile.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
end