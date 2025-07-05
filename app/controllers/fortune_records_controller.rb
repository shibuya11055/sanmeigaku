class FortuneRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fortune_record, only: [:show, :edit, :update, :destroy]
  before_action :set_client, only: [:new, :create]

  def index
    @fortune_records = FortuneRecord.includes(:client).order(start_at: :desc)
  end

  def show
  end

  def new
    @fortune_record = @client.fortune_records.build
  end

  def create
    @fortune_record = @client.fortune_records.build(fortune_record_params)
    if @fortune_record.save
      redirect_to @fortune_record, notice: 'カルテを作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @fortune_record.update(fortune_record_params)
      redirect_to @fortune_record, notice: 'カルテを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fortune_record.destroy
    redirect_to fortune_records_path, notice: 'カルテを削除しました。'
  end

  private

  def set_fortune_record
    @fortune_record = FortuneRecord.find(params[:id])
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  def fortune_record_params
    params.require(:fortune_record).permit(:start_at, :end_at, :amount, :content, :category, :consultation_method)
  end
end
