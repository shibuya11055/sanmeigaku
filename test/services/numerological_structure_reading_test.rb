require 'test_helper'

class NumerologicalStructureReadingTest < ActiveSupport::TestCase
  test 'overview builds reading from dominant axes' do
    structure = {
      struggle: 10,
      input: 8,
      ego: 14,
      expression: 31,
      get: 28,
      back_structure: 18,
      center_structure: 14,
      front_structure: 59,
      control_by: 10,
      generates: 39,
      control: 28,
      self: 35,
      other: 65,
      ten_major_star_name: %w[牽牛星 車騎星 玉堂星 龍高星 石門星 貫索星 調舒星 鳳閣星 司禄星 禄存星],
      stem_count: [1, 1, 0, 1, 1, 1, 0, 1, 1, 1]
    }

    reading = NumerologicalStructureReading.call(structure, :overview)

    assert_includes reading, "【目立つ構造】\n"
    assert_includes reading, "【行動の出方】\n"
    assert_includes reading, "【流れの質】\n"
    assert_includes reading, "【主観・客観】\n"
    assert_includes reading, "【総合パターン】\n"
    assert_includes reading, "\n\n【行動の出方】"
    assert_includes reading, '表現31'
    assert_includes reading, '朱雀型の具体像'
    assert_includes reading, '青龍型の具体像'
    assert_includes reading, '能動的が優勢'
    assert_includes reading, '相生と剋の差は大きくありません'
    assert_includes reading, '客が主より優勢'
  end

  test 'passive reading describes external motivation' do
    structure = {
      struggle: 24,
      input: 30,
      ego: 16,
      expression: 10,
      get: 8,
      back_structure: 54,
      center_structure: 16,
      front_structure: 18,
      control_by: 24,
      generates: 40,
      control: 8,
      self: 58,
      other: 42,
      ten_major_star_name: %w[牽牛星 車騎星 玉堂星 龍高星 石門星 貫索星 調舒星 鳳閣星 司禄星 禄存星],
      stem_count: [1, 1, 0, 3, 1, 1, 0, 1, 1, 1]
    }

    reading = NumerologicalStructureReading.call(structure, :passive)

    assert_includes reading, '受動的は54'
    assert_includes reading, 'かなりはっきりと受動的が前後構造の主軸'
    assert_includes reading, '自分以外から来るものが行動の引き金'
    assert_includes reading, '入力30が闘争24を上回ります'
    assert_includes reading, '学び、保護、導き、知識'
    assert_includes reading, '玄武型の具体像'
    assert_includes reading, '龍高星が3個'
    assert_includes reading, '論理的思考が多くなり'
    assert_includes reading, '主観構造が強い'
    assert_includes reading, '後ろから来る動機、相生の自然な流れ、主観構造'
  end

  test 'active reading differs from passive reading with component detail' do
    structure = {
      struggle: 24,
      input: 30,
      ego: 16,
      expression: 10,
      get: 8,
      back_structure: 54,
      center_structure: 16,
      front_structure: 18,
      control_by: 24,
      generates: 40,
      control: 8,
      self: 58,
      other: 42,
      ten_major_star_name: %w[牽牛星 車騎星 玉堂星 龍高星 石門星 貫索星 調舒星 鳳閣星 司禄星 禄存星],
      stem_count: [1, 1, 0, 3, 1, 1, 0, 1, 1, 1]
    }

    active_reading = NumerologicalStructureReading.call(structure, :active)
    passive_reading = NumerologicalStructureReading.call(structure, :passive)

    assert_not_equal active_reading, passive_reading
    assert_includes active_reading, '能動的は18'
    assert_includes active_reading, '能動的は受動的より小さい'
    assert_includes active_reading, '表現10が取得8を上回ります'
    assert_includes active_reading, '伝える、教える、面倒を見る'
  end
end
