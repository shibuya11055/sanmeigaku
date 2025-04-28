class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients.order(created_at: :desc)
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

      @stem_unions = stem_unions

      @youth_sub_star, @middle_age_sub_star, @old_age_sub_star = calculate_branch_and_stem_sub_star

      # 六親法・数理法・位相法の分析に必要なパラメータを構築
      calculate_params = {
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

      # 算命学計算ラッパークラスを初期化
      calculator = FortuneAnalysisCalculateWrapper.new(calculate_params)

      # 基本的な情報のみを取得
      @stem_lineage = calculator.stem_lineage
      @numerological, @beast_type, @total_energy, @numerological_structure = calculator.numerological_calculator
      @phase_method = calculator.phase_method

      # 陽占図表示に必要なデータ追加
      days = qi_days
      @year_qi_stem = calculate_qi(days, @year_branch)
      @month_qi_stem = calculate_qi(days, @month_branch)
      @day_qi_stem = calculate_qi(days, @day_branch)

      @ten_stars, @twelve_stars = calculate_yang_chart
      @ten_stars_relations = ten_stars_relations

      # 中殺の情報を取得
      @abnormals = []
      @birth_voids = {}
      @has_birth_voids = {}
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
      :blood_type, :marital_status, :birthplace, :memo
    )
  end

  # 以下、陽占図表示に必要なメソッドを定義
  def qi_days
    day = @date.day
    entry_day = LunarCalendarEntry.lunar_birth_day(@date)
    if day >= entry_day
      day - entry_day
    else
      LunarCalendarEntry.lunar_birth_last_day_previous_month(@date) - LunarCalendarEntry.lunar_birth_day_previous_month(@date) + day
    end
  end

  def calculate_qi(days, branch)
    if branch.first_stem.present? && branch.first_stem_period_day >= days
      branch.first_stem
    elsif branch.second_stem.present? && branch.second_stem_period_day >= days
      branch.second_stem
    else
      branch.third_stem
    end
  end

  def calculate_yang_chart
    stems = {
      east: @year_qi_stem,
      south: @month_stem,
      west: @day_qi_stem,
      north: @year_stem,
      center: @month_qi_stem
    }

    # 十大主星の取得
    ten_stars = stems.transform_values do |sub_stem|
      StemTenStarMapping.find_by!(main_stem: @day_stem, sub_stem: sub_stem).ten_major_star
    end

    # 方角ごとの意味
    ten_star_direction = TenStarDirection.new
    ten_stars[:east_message] = ten_star_direction.get_message("east.#{ten_stars[:east].name}")
    ten_stars[:south_message] = ten_star_direction.get_message("south.#{ten_stars[:south].name}")
    ten_stars[:west_message] = ten_star_direction.get_message("west.#{ten_stars[:west].name}")
    ten_stars[:north_message] = ten_star_direction.get_message("north.#{ten_stars[:north].name}")
    ten_stars[:center_message] = ten_star_direction.get_message("center.#{ten_stars[:center].name}")

    # 十二大従星の取得
    branches = {
      first: @day_branch,
      second: @month_branch,
      third: @year_branch
    }

    twelve_stars = branches.transform_values do |branch|
      StemTwelveStarMapping.find_by!(stem: @day_stem, branch: branch).twelve_sub_star
    end

    return ten_stars, twelve_stars
  end

  def ten_stars_relations
    center_id = @ten_stars[:center].element_id
    synergy = TenStarSynergy.new

    top_relation = ElementRelation.find_relation(center_id, @ten_stars[:north].element_id)
    right_relation = ElementRelation.find_relation(center_id, @ten_stars[:east].element_id)
    bottom_relation = ElementRelation.find_relation(center_id, @ten_stars[:south].element_id)
    left_relation = ElementRelation.find_relation(center_id, @ten_stars[:west].element_id)

    top_state = top_relation.state
    right_state = right_relation.state
    bottom_state = bottom_relation.state
    left_state = left_relation.state

    {
      top: ElementRelation.top_icon(top_state),
      right: ElementRelation.right_icon(right_state),
      bottom: ElementRelation.bottom_icon(bottom_state),
      left: ElementRelation.left_icon(left_state),
      top_message: synergy.get_message("north.#{top_state}"),
      right_message: synergy.get_message("east.#{right_state}"),
      bottom_message: synergy.get_message("south.#{bottom_state}"),
      left_message: synergy.get_message("west.#{left_state}")
    }
  end

  def calculate_branch_and_stem_sub_star
    youth_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @year_branch).twelve_sub_star
    middle_age_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @month_branch).twelve_sub_star
    old_age_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @day_branch).twelve_sub_star
    return youth_sub_star, middle_age_sub_star, old_age_sub_star
  end

  def stem_unions
    stem = Stem.new
    day_and_month_ids = stem.union_ids(@day_stem.id, @month_stem.id)
    day_and_year_ids = stem.union_ids(@day_stem.id, @year_stem.id)
    month_and_year_ids = stem.union_ids(@month_stem.id, @year_stem.id)

    day_and_month_union_names = day_and_month_ids.present? ? Stem.find(day_and_month_ids).map(&:name) : nil
    day_and_year_union_names = day_and_year_ids.present? ? Stem.find(day_and_year_ids).map(&:name) : nil
    month_and_year_union_names = month_and_year_ids.present? ? Stem.find(month_and_year_ids).map(&:name) : nil

    {
      day_and_month: {
          title: '日干・月干',
        before: [@day_stem.name, @month_stem.name],
        result: day_and_month_union_names
      },
      day_and_year: {
        title: '日干・年干',
        before: [@day_stem.name, @year_stem.name],
        result: day_and_year_union_names
      },
      month_and_year: {
        title: '月干・年干',
        before: [@month_stem.name, @year_stem.name],
        result: month_and_year_union_names
      }
    }
  end
end
