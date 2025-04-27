class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients.order(created_at: :desc)
  end

  def show
  end

  def new
    @client = current_user.clients.build
    # 職業と職種のリストを取得
    @jobs = Job.all
    @occupations = Occupation.all
  end

  def edit
    # 職業と職種のリストを取得
    @jobs = Job.all
    @occupations = Occupation.all
  end

  def create
    @client = current_user.clients.build(client_params)

    if @client.save
      redirect_to @client, notice: '顧客情報が正常に作成されました。'
    else
      @jobs = Job.all
      @occupations = Occupation.all
      render :new
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: '顧客情報が正常に更新されました。'
    else
      @jobs = Job.all
      @occupations = Occupation.all
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: '顧客情報が正常に削除されました。'
  end

  private
    def set_client
      @client = current_user.clients.find(params[:id])
    end

    def client_params
      params.require(:client).permit(
        :fullname, :birthday, :gender, :email, :phone,
        :postal_code, :address, :occupation_id, :job_id,
        :blood_type, :marital_status, :memo
      )
    end
end
