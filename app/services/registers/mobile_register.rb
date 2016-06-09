module Registers
  class MobileRegister
    attr_accessor :user, :params, :errors

    def initialize(params)
      @errors = []
      @params = params
      @user_params = @params.delete(:user)
      @profile_params = @params.delete(:profile)
      @experience_params = @params.delete(:experience)
    end

    def call
      @user = create_user(@user_params)
      if user.valid?
        update_profile(user, @profile_params) if @profile_params
        create_experience(user, @experience_params) if @experience_params
      end
      is_valid?
    end

    def is_valid?
      @errors.blank?
    end

    private

      def create_user(params)
        params[:password_confirmation] = params[:password]
        user = User.new(params)
        @errors << user.errors.full_messages unless user.save
        user
      end

      def update_profile(user, params)
        city = City.find(params[:residence_city_id])
        params[:gender] = "M"
        params[:residence_country_id] = city.country.id
        @errors << user.profile.errors.full_messages unless user.profile.update(params)
      end

      def create_experience(user, params)
        params[:exp_type] = 1
        experience = Experience.new(params)
        profile = user.profile
        profile.experiences << experience
      end

  end
end