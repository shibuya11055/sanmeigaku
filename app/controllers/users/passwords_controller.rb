# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    super
    # パスワード再設定用のエラーメッセージを表示するためのフラグを設定
    @password_reset_context = true
  end

  # POST /resource/password
  def create
    # メールアドレスが空の場合は専用のエラーメッセージを表示
    if resource_params[:email].blank?
      self.resource = resource_class.new
      resource.errors.add(:email, :blank)
      flash.now[:alert] = '処理に失敗しました'
      @password_reset_context = true
      return render :new
    end

    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      # ログイン画面にリダイレクトして適切なフラッシュメッセージを設定
      flash[:notice] = I18n.t('devise.passwords.send_instructions')
      redirect_to new_user_session_path
    else
      flash.now[:alert] = '処理に失敗しました'
      @password_reset_context = true
      respond_with(resource)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
