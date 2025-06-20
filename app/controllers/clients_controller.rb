class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients.order(created_at: :desc)

    # 検索パラメータがある場合は名前で絞り込み
    if params[:search].present?
      @clients = @clients.where("fullname LIKE ?", "%#{params[:search]}%")
    end
  end

  def show
    # 算命学分析のためのデータを準備
    @date = @client.birthday
    @gender = @client.gender

    # 算命学の分析結果を取得
    @result = FortuneAnalysis.preload(
      sexagenary_cycle_year: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
      sexagenary_cycle_month: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
      sexagenary_cycle_day: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } }
    ).find_by(birthday: @date)

    if @result
      # 結果が見つかった場合のみ計算処理を実行
      @year_heavenly_void = @result.sexagenary_cycle_year.heavenly_void
      @day_heavenly_void = @result.sexagenary_cycle_day.heavenly_void

      @day_stem = @result.sexagenary_cycle_day.stem
      @month_stem = @result.sexagenary_cycle_month.stem
      @year_stem = @result.sexagenary_cycle_year.stem

      @day_branch = @result.sexagenary_cycle_day.branch
      @month_branch = @result.sexagenary_cycle_month.branch
      @year_branch = @result.sexagenary_cycle_year.branch

      basic_results = build_basic_results
      @stem_unions = basic_results.stem_unions
      @youth_sub_star, @middle_age_sub_star, @old_age_sub_star = basic_results.branch_and_stem_sub_star
      @abnormals = basic_results.abnormals
      @year_qi_stem, @month_qi_stem, @day_qi_stem = basic_results.birth_qi
      @birth_voids = basic_results.birth_voids
      @has_birth_voids = has_birth_voids

      # 算命学計算ラッパークラスを初期化
      calculator = FortuneAnalysisCalculateWrapper.new(calculate_params)

      # 基本的な情報のみを取得
      @numerological, @beast_type, @total_energy, @numerological_structure = calculator.numerological_calculator
      @phase_method = calculator.phase_method
    end
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

    if @client.save!
      redirect_to @client, notice: '顧客情報を作成しました。'
    else
      @jobs = Job.all
      @occupations = Occupation.all
      render :new
    end
  end

  def update
    if @client.update!(client_params)
      redirect_to @client, notice: '顧客情報を更新しました。'
    else
      @jobs = Job.all
      @occupations = Occupation.all
      render :edit
    end
  end

  def destroy
    @client.destroy!
    redirect_to clients_url, notice: '顧客情報を削除しました。'
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(
      :fullname, :birthday, :gender, :email, :phone,
      :postal_code, :address, :occupation_id, :job_id,
      :blood_type, :marital_status, :birthplace, :memo
    )
  end

  def calculate_params
    # 位相法の分析に必要なパラメータを構築
    {
      result: @result,
      date: @date,
      gender: @gender,
      day_stem: @day_stem,
      month_stem: @month_stem,
      year_stem: @year_stem,
      day_branch: @day_branch,
      month_branch: @month_branch,
      year_branch: @year_branch,
      day_qi_stem: nil, # これは簡易表示のため省略
      month_qi_stem: nil,
      year_qi_stem: nil,
      day_heavenly_void: @day_heavenly_void
    }
  end

  # 各中殺を持つかどうか
  def has_birth_voids
    {
      has_birth_day_void: @birth_voids[:birth_day_void].present? ||
                            @birth_voids[:day_position_void].present? ||
                            @birth_voids[:day_residence_void].present?,
      has_birth_month_void: @birth_voids[:birth_month_void].present?,
      has_birth_year_void: @birth_voids[:birth_year_void].present?,
      has_compatible_void: @birth_voids[:compatible_void].present?,
      has_double_birth_void: @birth_voids[:double_birth_void].present?,
      has_complete_void: @birth_voids[:complete_void].present?
    }
  end

  def build_basic_results
    basic_results = FortuneAnalysisBasicResults.new(@day_stem,
                                                    @month_stem,
                                                    @year_stem,
                                                    @day_branch,
                                                    @month_branch,
                                                    @year_branch,
                                                    @year_heavenly_void,
                                                    @day_heavenly_void,
                                                    @date,
                                                    @result)
  end
end
