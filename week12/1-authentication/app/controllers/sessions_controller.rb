class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(e_mail: params[:session][:e_mail])
    if @user && @user.authenticate(params[:session][:password])
      login @user
      debugger
      remember @user if params[:remember_me] == "1"
      redirect_to user_path @user
    else
      render :new
    end
  end

  def destroy
    log_out if logged_in?
  end

  private

  def session_params
    params.permit(:remember_me)
    params.require(:session).permit(:e_mail, :password)
  end
end