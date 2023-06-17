class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      token = encode_token({ user_id: user.id })
      render json: { user: user.as_json_response(token) }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end
