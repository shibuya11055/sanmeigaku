# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    # Deviseのデフォルトのnewメソッドを呼び出す
    super
    # ビューでユーザー保存のエラーメッセージではなく、確認メール専用のメッセージを表示するためのフラグを設定
    @confirmation_context = true
  end

  # POST /resource/confirmation
  def create
    # メールアドレスが空の場合は専用のエラーメッセージを表示
    if resource_params[:email].blank?
      self.resource = resource_class.new
      # Deviseの標準エラーメッセージだけを使用し、重複を避ける
      resource.errors.add(:email, :blank)
      # フラッシュメッセージでは確認メール再送信の文脈に合った文言を使用
      flash.now[:alert] = '処理に失敗しました'
      @confirmation_context = true
      return render :new
    end

    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      # ログイン画面にリダイレクトして適切なフラッシュメッセージを設定
      flash[:notice] = '確認メールを送信しました。'
      redirect_to new_user_session_path
    else
      flash.now[:alert] = '処理に失敗しました'
      @confirmation_context = true
      respond_with(resource)
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
