class NumerologicalStructureReading
  STRUCTURE_LABELS = {
    struggle: '闘争',
    input: '入力',
    ego: '自我',
    expression: '表現',
    get: '取得',
    passive: '受動的',
    center: '中心',
    active: '能動的',
    control_by: '受剋',
    generates: '相生',
    control: '打剋',
    self: '主',
    other: '客'
  }.freeze

  SCORE_KEYS = {
    passive: :back_structure,
    center: :center_structure,
    active: :front_structure
  }.freeze

  STRUCTURE_KEYS = [:struggle, :input, :ego, :expression, :get].freeze
  ORIENTATION_KEYS = [:passive, :center, :active].freeze
  FLOW_KEYS = [:control_by, :generates, :control].freeze
  PERSPECTIVE_KEYS = [:self, :other].freeze

  STRUCTURE_RESULTS = {
    struggle: '現実から鍛えられるほど力が出る構造です。責任、競争、批判、負荷がきっかけになりやすく、逃げずに受け止めることで粘りや突破力が育ちます。',
    input: '学び、保護、導きから力を得る構造です。叩かれて伸びるより、安定した環境で知識や技術を深めるほど本来の強みが出ます。',
    ego: '自分の納得感と守備本能が軸になる構造です。周囲に合わせるだけでは動きにくく、自分で意味を見つけたときに強い粘りが出ます。',
    expression: '気持ちや才能を外へ流す構造です。伝える、教える、面倒を見る、表現する場を持つほど、内側のエネルギーが自然に消化されます。',
    get: '対象へ働きかけ、現実的に得ていく構造です。人、財、情報、役割を自分の行動でつかみに行くほど、人生が動きやすくなります。'
  }.freeze

  CONCRETE_STRUCTURE_RESULTS = {
    struggle: '白虎型の具体像です。攻撃されたり、責任や負荷を受けたりするほど力が出ます。周囲から認められて安住するより、不当な扱いや競争から這い上がる場面で粘りが出ます。集団協調より一匹狼的に自分で道を切り開く傾向があり、スポーツ、鍛錬、難関資格のように負荷を力へ変える世界と相性があります。',
    input: '玄武型の具体像です。生まれ持って保護され、導かれることで伸びる才能型です。厳しく叩かれるより、守られた安定環境で好きなことを深めるほど力が出ます。感情を激しく出すより理性が勝ちやすく、知的で信頼できる人物像になりやすい一方、面白みや熱量は外から見えにくいことがあります。',
    ego: '騰陀型の具体像です。何より自分の意思と納得が優先します。助けられても攻撃されても大きく動揺しにくく、孤立無援のように頼れるものが自分しかない状況で自我が目覚めます。頑固で不器用ですが、困難の中で強い意志力と守備本能を発揮します。',
    expression: '朱雀型の具体像です。気持ちが前に出て、目の前の対象や環境に心を動かされやすい型です。人を助けたい本能があり、誰かの役に立っている実感で自己確立します。教育、奉仕、表現活動に向きますが、支える対象がないと力が空回りし、自己犠牲や相手をだめにする関係に傾くこともあります。',
    get: '青龍型の具体像です。気持ちも行動も前へ向かい、未知のものに興味を持つ開拓者型です。既存のレールにおとなしく乗るより、自分の思い通りに動いて道を作ります。人とぶつかっても後に引きにくく、失敗からの立ち直りも早い一方、枠にはまった生き方や過保護とは相性がよくありません。'
  }.freeze

  PATTERN_RESULTS = {
    [:front, :generates, :self] => '前に出る力、相生の自然な流れ、主観構造が重なるため、情緒的で自己本位な面が出やすい型です。これは悪い意味ではなく、人間味や面倒見として表れます。',
    [:front, :generates, :other] => '前に出る力と相生の流れは強い一方、客観構造が抑えとして働きます。感情的にはなりにくいものの、我が道を行くマイペースさが出やすい型です。',
    [:front, :control, :self] => '前に出る力と剋の意識性がありながら、主観構造が強い型です。派手さよりも、自分の領域や足元を守りながら動く傾向が出ます。',
    [:front, :control, :other] => '前に出る力、剋の意識性、客観構造が重なるため、行動面の自己流が出やすい型です。中心人物になれる積極性、サービス精神、場を動かす力があります。',
    [:back, :generates, :self] => '後ろから来る動機、相生の自然な流れ、主観構造が重なるため、無理せず流れに任せ、守られながら生きる傾向があります。目上や身近な人との関係が行動の支えになります。',
    [:back, :generates, :other] => '後ろから来る動機と相生の流れに、客観構造が加わる型です。好きなことには前向きですが、興味のないものには気持ちも行動も向きにくく、専門研究や創造に向きます。',
    [:back, :control, :self] => '後ろから来る動機と剋の意識性に、主観構造が加わる型です。自分の枠をはみ出すことを嫌い、人に従いながら自分のポジションを確保していきます。',
    [:back, :control, :other] => '後ろから来る動機、剋の意識性、客観構造が重なるため、平穏に安住しにくく、環境によって生き方が変化しやすい型です。周囲の言動にすばやく反応します。'
  }.freeze

  STAR_STRUCTURE_KEYS = {
    '牽牛星' => :struggle,
    '車騎星' => :struggle,
    '玉堂星' => :input,
    '龍高星' => :input,
    '石門星' => :ego,
    '貫索星' => :ego,
    '調舒星' => :expression,
    '鳳閣星' => :expression,
    '司禄星' => :get,
    '禄存星' => :get
  }.freeze

  STAR_REPETITION_RESULTS = {
    struggle: '精神的な闘争心が強まり、出来事への反応が早くなります。周囲からは不安定に見えても、本人は動的に考えている方が安定します。',
    input: '論理的思考が多くなり、行動より手段を論じやすくなります。感情が表に出にくく、精神のあり方が外からわかりにくいため誤解されやすくなります。',
    ego: '守りの本能と頑固さが強まります。一歩一歩確認しながら進むため、途中で簡単に方向転換しにくく、生き方には不器用さが出ます。',
    expression: '表現することが先行します。話す、書く、描く、演じるなどに能力が向きますが、出力過多で消耗しやすく、方向が定まらないと無鉄砲さも出ます。',
    get: '自意識や権力意識、引力が強まります。愛情構造なので本人の自覚は情的でも、周囲からは自己中心的で薄情に見えることがあります。'
  }.freeze

  def self.call(structure, key)
    new(structure).reading_for(key)
  end

  def initialize(structure)
    @structure = structure || {}
  end

  def reading_for(key)
    key = key.to_sym

    case key
    when :overview
      overview_reading
    when *STRUCTURE_KEYS
      structure_reading(key)
    when *ORIENTATION_KEYS
      orientation_reading(key)
    when *FLOW_KEYS
      flow_reading(key)
    when *PERSPECTIVE_KEYS
      perspective_reading(key)
    else
      ''
    end
  end

  private

  attr_reader :structure

  def overview_reading
    orientation = orientation_axis
    flow = flow_axis
    perspective = perspective_axis

    [
      overview_structure_section,
      overview_axis_section(orientation, flow, perspective),
      overview_pattern_section
    ].compact.join("\n\n")
  end

  def structure_reading(key)
    value = score(key)
    top_key, top_value = ranked(STRUCTURE_KEYS).first
    second_key, second_value = ranked(STRUCTURE_KEYS).second
    position = key == top_key ? '最も強く出ています' : "五構造の中では#{rank_in(STRUCTURE_KEYS, key)}番目です"

    [
      "#{label(key)}は#{value}で、#{position}。",
      STRUCTURE_RESULTS[key],
      CONCRETE_STRUCTURE_RESULTS[key],
      repeated_star_reading_for(key),
      "最上位は#{label(top_key)}#{top_value}、次点は#{label(second_key)}#{second_value}です。差が大きいほど、#{label(top_key)}の性質から先に消化されやすくなります。"
    ].compact.join("\n")
  end

  def orientation_reading(key)
    return passive_reading if key == :passive
    return active_reading if key == :active
    return center_reading if key == :center

    orientation_summary(orientation_axis)
  end

  def flow_reading(key)
    value = score(key)
    control_total = control_total_value
    axis = flow_axis

    [
      "#{label(key)}は#{value}です。相生は#{score(:generates)}、剋の合計は#{control_total}です。",
      flow_summary(axis),
      pattern_reading
    ].join("\n")
  end

  def perspective_reading(key)
    value = score(key)
    axis = perspective_axis

    [
      "#{label(key)}は#{value}です。主は#{score(:self)}、客は#{score(:other)}です。",
      perspective_summary(axis),
      pattern_reading
    ].join("\n")
  end

  def passive_reading
    value = score(:passive)
    active = score(:active)
    center = score(:center)
    struggle = score(:struggle)
    input = score(:input)

    [
      "受動的は#{value}です。能動的#{active}との差は#{(value - active).abs}、中心は#{center}です。",
      passive_position_text(value, active, center),
      passive_component_text(struggle, input),
      dominant_structure_reading,
      repeated_star_reading,
      passive_modifier_text,
      pattern_reading
    ].compact.join("\n")
  end

  def active_reading
    value = score(:active)
    passive = score(:passive)
    center = score(:center)
    expression = score(:expression)
    get = score(:get)

    [
      "能動的は#{value}です。受動的#{passive}との差は#{(value - passive).abs}、中心は#{center}です。",
      active_position_text(value, passive, center),
      active_component_text(expression, get),
      dominant_structure_reading,
      repeated_star_reading,
      active_modifier_text,
      pattern_reading
    ].compact.join("\n")
  end

  def center_reading
    value = score(:center)
    passive = score(:passive)
    active = score(:active)

    [
      "中心は#{value}です。受動的#{passive}、能動的#{active}と比べて、自我の軸がどれだけ行動全体を支えているかを見ます。",
      center_position_text(value, passive, active),
      CONCRETE_STRUCTURE_RESULTS[:ego],
      repeated_star_reading_for(:ego),
      '中心が強いほど、外から押されるか自分から出るか以前に、自分が納得できるか、守るべき線があるかが重要になります。中心が弱い場合は、受動的・能動的の偏りがそのまま行動姿勢として出やすくなります。',
      pattern_reading
    ].compact.join("\n")
  end

  def orientation_axis
    active = score(:active)
    passive = score(:passive)
    center = score(:center)
    gap = (active - passive).abs

    return :center if center > active && center > passive && center - [active, passive].max >= 8
    return :balanced if gap < 8

    active > passive ? :front : :back
  end

  def flow_axis
    generates = score(:generates)
    control_total = control_total_value
    gap = (generates - control_total).abs

    return :balanced if gap < 8

    generates > control_total ? :generates : :control
  end

  def perspective_axis
    self_value = score(:self)
    other_value = score(:other)
    gap = (self_value - other_value).abs

    return :balanced if gap < 8

    self_value > other_value ? :self : :other
  end

  def overview_structure_section
    top_structures = ranked(STRUCTURE_KEYS).first(2).map { |key, value| "#{label(key)}#{value}" }.join('、')
    lines = [
      "【目立つ構造】\nこの命式では、五構造では#{top_structures}が目立ちます。",
      dominant_structure_reading,
      repeated_star_reading
    ].compact

    lines.join("\n")
  end

  def overview_axis_section(orientation, flow, perspective)
    [
      "【行動の出方】\n#{orientation_summary(orientation)}",
      "【流れの質】\n#{flow_summary(flow)}",
      "【主観・客観】\n#{perspective_summary(perspective)}"
    ].join("\n\n")
  end

  def overview_pattern_section
    "【総合パターン】\n#{pattern_reading}"
  end

  def dominant_structure_reading
    ranked(STRUCTURE_KEYS).first(2).map do |key, value|
      "具体像として、#{label(key)}#{value}は#{CONCRETE_STRUCTURE_RESULTS[key]}"
    end.join("\n")
  end

  def repeated_star_reading
    repeated_star_entries = star_names.zip(star_counts).filter_map do |star_name, count|
      next if star_name.blank? || count.to_i < 3

      structure_key = STAR_STRUCTURE_KEYS[star_name]
      next unless structure_key

      "#{star_name}が#{count}個あるため、同じ陽占が3つ以上の偏りとしては、#{STAR_REPETITION_RESULTS[structure_key]}"
    end

    return nil if repeated_star_entries.blank?

    repeated_star_entries.join("\n")
  end

  def repeated_star_reading_for(structure_key)
    repeated = star_names.zip(star_counts).select do |star_name, count|
      STAR_STRUCTURE_KEYS[star_name] == structure_key && count.to_i >= 3
    end
    return nil if repeated.blank?

    repeated.map do |star_name, count|
      "#{star_name}が#{count}個あるため、この#{label(structure_key)}はさらに偏りとして出やすくなります。#{STAR_REPETITION_RESULTS[structure_key]}"
    end.join("\n")
  end

  def passive_position_text(value, active, center)
    if value > active && value > center
      intensity = gap_intensity(value - [active, center].max)
      "#{intensity}受動的が前後構造の主軸です。自分から押し出すより、環境、役割、人からの期待、責任、学びなど、自分以外から来るものが行動の引き金になりやすい命式です。"
    elsif value < active
      '受動的は能動的より小さいため、この命式の主な動き方は自分発です。ただし受動的の数値は、外から来る役割や責任にどう反応するかを見る補助線になります。'
    elsif value < center
      '受動的は中心より小さいため、外から押される力よりも、自分の納得感や守備本能が行動の前提になります。'
    else
      '受動的と能動的の差は大きくありません。外から来たものに反応する面と、自分から出る面の両方を持つため、場面ごとに読み分けます。'
    end
  end

  def active_position_text(value, passive, center)
    if value > passive && value > center
      intensity = gap_intensity(value - [passive, center].max)
      "#{intensity}能動的が前後構造の主軸です。行動の動機が自分側にあり、やりたいこと、表現したいこと、得たいものが人生を動かしやすい命式です。"
    elsif value < passive
      '能動的は受動的より小さいため、この命式は自分から押し切るより、外から来る役割や環境に応じて動く場面が多くなります。能動的の数値は、本人発の欲求や表現がどれだけ出せるかを見る補助線です。'
    elsif value < center
      '能動的は中心より小さいため、自分から前に出る力よりも、自我の納得感や守るべき線が行動の軸になります。'
    else
      '能動的と受動的の差は大きくありません。自分から出る力と、外から来たものに反応する力をどちらも持つため、場面ごとに切り替わります。'
    end
  end

  def center_position_text(value, passive, active)
    if value > passive && value > active
      intensity = gap_intensity(value - [passive, active].max)
      "#{intensity}中心が前後構造の主軸です。能動・受動のどちらかに単純化するより、自我の強さ、納得感、守備本能を先に読みます。"
    elsif value < passive && value < active
      '中心は受動的・能動的より小さいため、自我そのものより、外から受ける力と自分から出る力のバランスが行動姿勢を作ります。'
    else
      '中心は前後構造の中で中間的な位置です。自我は補助軸として働き、受動的・能動的のどちらが優勢かを調整します。'
    end
  end

  def passive_component_text(struggle, input)
    if struggle > input
      "受動的の内訳では闘争#{struggle}が入力#{input}を上回ります。外から来るものは、保護や学びよりも、責任、競争、批判、負荷として入りやすく、それに反応して強くなる読みです。"
    elsif input > struggle
      "受動的の内訳では入力#{input}が闘争#{struggle}を上回ります。外から来るものは、厳しい圧力よりも、学び、保護、導き、知識として入りやすく、受け取って深めることで力になります。"
    else
      "受動的の内訳は闘争#{struggle}、入力#{input}で同程度です。外からの負荷で鍛えられる面と、学びや保護を受け取る面が並びます。"
    end
  end

  def active_component_text(expression, get)
    if expression > get
      "能動的の内訳では表現#{expression}が取得#{get}を上回ります。前に出る力は、財や対象を得ることよりも、伝える、教える、面倒を見る、才能を表す方向に出やすい読みです。"
    elsif get > expression
      "能動的の内訳では取得#{get}が表現#{expression}を上回ります。前に出る力は、気持ちを表すことよりも、人、財、情報、役割など現実の対象をつかみに行く方向に出やすい読みです。"
    else
      "能動的の内訳は表現#{expression}、取得#{get}で同程度です。伝える力と、現実の対象を得る力が並びます。"
    end
  end

  def passive_modifier_text
    case perspective_axis
    when :self
      '主観構造が強いため、外から来るものを受ける場合でも、情や身内感覚、自分のポジションを守る意識を通して反応します。'
    when :other
      '客観構造が強いため、外から来るものを受ける場合でも、感情より観察、分析、対象への関心として反応しやすくなります。'
    else
      '主客の差が小さいため、外から来るものに対して、情的に受ける面と冷静に観察する面が混在します。'
    end
  end

  def active_modifier_text
    case perspective_axis
    when :self
      '主観構造が強いため、自分から出る力は、情、好悪、個人的な納得、人間関係の近さを伴って表れやすくなります。'
    when :other
      '客観構造が強いため、自分から出る力は、感情的な押し出しより、対象への興味、観察、サービス精神、行動規範として表れやすくなります。'
    else
      '主客の差が小さいため、自分から出る力は、情的な動機と客観的な判断の両方を使って表れます。'
    end
  end

  def gap_intensity(gap)
    return 'かなりはっきりと' if gap >= 20
    return 'やや' if gap < 12

    ''
  end

  def orientation_summary(axis)
    case axis
    when :front
      '前後構造では能動的が優勢です。行動の動機が自分側にあり、やりたいこと、表現したいこと、得たいものが人生を動かしやすい命式です。'
    when :back
      '前後構造では受動的が優勢です。環境、役割、人からの期待、責任、学びなど、自分以外から来るものが行動の引き金になりやすい命式です。'
    when :center
      '前後構造では中心が強く、自分の納得感や守備本能が軸になりやすい命式です。外から押されるか自分から出るか以前に、自分自身の意味づけが重要になります。'
    else
      '前後構造は大きく偏らず、受けて動く面と自分から出る面の両方を持ちます。場面によって行動の出方が変わりやすい命式です。'
    end
  end

  def flow_summary(axis)
    case axis
    when :generates
      '相生が剋より優勢です。自然な流れ、好きなこと、学び、表現を育てることで気が燃焼しやすく、無理に戦うより関心領域を深める生き方に向きます。'
    when :control
      '剋の合計が相生より優勢です。何事も無意識では済ませにくく、対象や環境に反応しながら、理解力、対応力、開拓精神を発揮しやすい命式です。'
    else
      '相生と剋の差は大きくありません。自然な流れに任せる力と、対象へ意識的に向かう力の両方を使えます。どちらか一方に固定しない読みが必要です。'
    end
  end

  def perspective_summary(axis)
    case axis
    when :self
      '主が客より優勢です。情、個人的な納得、身内感覚、主体性が行動の根にあります。理屈だけでなく、気持ちが通るかどうかが大切です。'
    when :other
      '客が主より優勢です。個人的感情より、対象への興味、観察、探究心、冷静さが前に出やすい命式です。自分の感情以外の要素で行動が展開します。'
    else
      '主客の差は大きくありません。情的な納得と客観的な観察の両方を使えるため、相手や場面によって見え方が変わります。'
    end
  end

  def pattern_reading
    orientation = orientation_axis
    flow = flow_axis
    perspective = perspective_axis

    return '中心が強いため、まず自我の強さと納得感を見ます。そのうえで、能動・受動、相生・剋、主・客の偏りを補助線として読むと安定します。' if orientation == :center
    return '主要軸の差が小さいため、ひとつの型に決めつけず、バランス型として読みます。偏りが少ないこと自体が特徴です。' if [orientation, flow, perspective].include?(:balanced)

    PATTERN_RESULTS[[orientation, flow, perspective]]
  end

  def control_total_value
    score(:control_by) + score(:control)
  end

  def ranked(keys)
    keys.map { |key| [key, score(key)] }.sort_by { |_, value| -value }
  end

  def rank_in(keys, key)
    ranked(keys).map(&:first).index(key) + 1
  end

  def score(key)
    structure.fetch(SCORE_KEYS.fetch(key, key), 0).to_i
  end

  def star_names
    structure.fetch(:ten_major_star_name, [])
  end

  def star_counts
    structure.fetch(:stem_count, [])
  end

  def label(key)
    STRUCTURE_LABELS.fetch(key)
  end
end
