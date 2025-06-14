class UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザー詳細画面
  def show
    @user = current_user
  end

  # ユーザー編集画面
  def edit
    @user = current_user
    @minimum_password_length = Devise.password_length.min
  end

  # ユーザー情報更新
  def update
    @user = current_user
    @minimum_password_length = Devise.password_length.min

    # 現在のパスワードが正しいかチェック
    unless @user.valid_password?(params[:user][:current_password])
      @user.errors.add(:current_password, "が正しくありません")
      render :edit, status: :unprocessable_entity
      return
    end

    # current_passwordは更新対象から除外
    update_params = user_params.except(:current_password)
    if update_params[:password].blank?
      update_params = update_params.except(:password, :password_confirmation)
    end

    if @user.update(update_params)
      # パスワードを変更した場合はもう一度ログインを要求
      bypass_sign_in(@user) if user_params[:password].present?
      redirect_to user_path, notice: 'ユーザー情報が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:fullname, :email, :password, :password_confirmation, :current_password)
  end
end
