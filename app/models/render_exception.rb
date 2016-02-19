class RenderException

  attr_reader :message, :status

  def initialize(exception)
    check_exception(exception)
    self
  end

  def to_json(*)
    { errors: message }
  end

  private

    def check_exception(exception)
      Rollbar.error(exception)
      klass = exception.class
      case
      when klass == Pundit::NotAuthorizedError
        @status, @message = 403, { user: ['not authorized'] }
      when klass == ActiveRecord::RecordNotFound
        @status, @message = 404, { record: ['not found'] }
      else
        if Rails.env.production?
          @status, @message = 500, { server: ['error'] }
        else
          raise exception
        end
      end
    end

end

