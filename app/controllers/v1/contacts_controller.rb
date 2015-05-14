class V1::ContactsController < V1::BaseController

  def file
    file = params[:file].path
    importer = ContactImporter.new(file)
    if importer.valid?
      render json: { contacts: importer.contacts }
    else
      render json: { errors: importer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def in_alumnet
    sender = SenderInvitation.new(params[:contacts], current_user)
    @users = sender.users_in_alumnet
    render 'v1/users/index'
  end
end