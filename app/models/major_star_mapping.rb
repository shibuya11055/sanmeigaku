# ten_major_star_mappingと役割が被っているが、無駄なSQLを発行しないために利用している
class MajorStarMapping < ActiveHash::Base
  self.data = [
    { main_stem: '甲', sub_stem: '甲', ten_major_star: '貫索星' },
    { main_stem: '甲', sub_stem: '乙', ten_major_star: '石門星' },
    { main_stem: '甲', sub_stem: '丙', ten_major_star: '鳳閣星' },
    { main_stem: '甲', sub_stem: '丁', ten_major_star: '調舒星' },
    { main_stem: '甲', sub_stem: '戊', ten_major_star: '禄存星' },
    { main_stem: '甲', sub_stem: '己', ten_major_star: '司禄星' },
    { main_stem: '甲', sub_stem: '庚', ten_major_star: '車騎星' },
    { main_stem: '甲', sub_stem: '辛', ten_major_star: '牽牛星' },
    { main_stem: '甲', sub_stem: '壬', ten_major_star: '龍高星' },
    { main_stem: '甲', sub_stem: '癸', ten_major_star: '玉堂星' },
    { main_stem: '乙', sub_stem: '乙', ten_major_star: '貫索星' },
    { main_stem: '乙', sub_stem: '甲', ten_major_star: '石門星' },
    { main_stem: '乙', sub_stem: '丁', ten_major_star: '鳳閣星' },
    { main_stem: '乙', sub_stem: '丙', ten_major_star: '調舒星' },
    { main_stem: '乙', sub_stem: '己', ten_major_star: '禄存星' },
    { main_stem: '乙', sub_stem: '戊', ten_major_star: '司禄星' },
    { main_stem: '乙', sub_stem: '辛', ten_major_star: '車騎星' },
    { main_stem: '乙', sub_stem: '庚', ten_major_star: '牽牛星' },
    { main_stem: '乙', sub_stem: '癸', ten_major_star: '龍高星' },
    { main_stem: '乙', sub_stem: '壬', ten_major_star: '玉堂星' },
    { main_stem: '丙', sub_stem: '丙', ten_major_star: '貫索星' },
    { main_stem: '丙', sub_stem: '丁', ten_major_star: '石門星' },
    { main_stem: '丙', sub_stem: '戊', ten_major_star: '鳳閣星' },
    { main_stem: '丙', sub_stem: '己', ten_major_star: '調舒星' },
    { main_stem: '丙', sub_stem: '庚', ten_major_star: '禄存星' },
    { main_stem: '丙', sub_stem: '辛', ten_major_star: '司禄星' },
    { main_stem: '丙', sub_stem: '壬', ten_major_star: '車騎星' },
    { main_stem: '丙', sub_stem: '癸', ten_major_star: '牽牛星' },
    { main_stem: '丙', sub_stem: '甲', ten_major_star: '龍高星' },
    { main_stem: '丙', sub_stem: '乙', ten_major_star: '玉堂星' },
    { main_stem: '丁', sub_stem: '丁', ten_major_star: '貫索星' },
    { main_stem: '丁', sub_stem: '丙', ten_major_star: '石門星' },
    { main_stem: '丁', sub_stem: '己', ten_major_star: '鳳閣星' },
    { main_stem: '丁', sub_stem: '戊', ten_major_star: '調舒星' },
    { main_stem: '丁', sub_stem: '辛', ten_major_star: '禄存星' },
    { main_stem: '丁', sub_stem: '庚', ten_major_star: '司禄星' },
    { main_stem: '丁', sub_stem: '癸', ten_major_star: '車騎星' },
    { main_stem: '丁', sub_stem: '壬', ten_major_star: '牽牛星' },
    { main_stem: '丁', sub_stem: '乙', ten_major_star: '龍高星' },
    { main_stem: '丁', sub_stem: '甲', ten_major_star: '玉堂星' },
    { main_stem: '戊', sub_stem: '戊', ten_major_star: '貫索星' },
    { main_stem: '戊', sub_stem: '己', ten_major_star: '石門星' },
    { main_stem: '戊', sub_stem: '庚', ten_major_star: '鳳閣星' },
    { main_stem: '戊', sub_stem: '辛', ten_major_star: '調舒星' },
    { main_stem: '戊', sub_stem: '壬', ten_major_star: '禄存星' },
    { main_stem: '戊', sub_stem: '癸', ten_major_star: '司禄星' },
    { main_stem: '戊', sub_stem: '甲', ten_major_star: '車騎星' },
    { main_stem: '戊', sub_stem: '乙', ten_major_star: '牽牛星' },
    { main_stem: '戊', sub_stem: '丙', ten_major_star: '龍高星' },
    { main_stem: '戊', sub_stem: '丁', ten_major_star: '玉堂星' },
    { main_stem: '己', sub_stem: '己', ten_major_star: '貫索星' },
    { main_stem: '己', sub_stem: '戊', ten_major_star: '石門星' },
    { main_stem: '己', sub_stem: '辛', ten_major_star: '鳳閣星' },
    { main_stem: '己', sub_stem: '庚', ten_major_star: '調舒星' },
    { main_stem: '己', sub_stem: '癸', ten_major_star: '禄存星' },
    { main_stem: '己', sub_stem: '壬', ten_major_star: '司禄星' },
    { main_stem: '己', sub_stem: '乙', ten_major_star: '車騎星' },
    { main_stem: '己', sub_stem: '甲', ten_major_star: '牽牛星' },
    { main_stem: '己', sub_stem: '丁', ten_major_star: '龍高星' },
    { main_stem: '己', sub_stem: '丙', ten_major_star: '玉堂星' },
    { main_stem: '庚', sub_stem: '庚', ten_major_star: '貫索星' },
    { main_stem: '庚', sub_stem: '辛', ten_major_star: '石門星' },
    { main_stem: '庚', sub_stem: '壬', ten_major_star: '鳳閣星' },
    { main_stem: '庚', sub_stem: '癸', ten_major_star: '調舒星' },
    { main_stem: '庚', sub_stem: '甲', ten_major_star: '禄存星' },
    { main_stem: '庚', sub_stem: '乙', ten_major_star: '司禄星' },
    { main_stem: '庚', sub_stem: '丙', ten_major_star: '車騎星' },
    { main_stem: '庚', sub_stem: '丁', ten_major_star: '牽牛星' },
    { main_stem: '庚', sub_stem: '戊', ten_major_star: '龍高星' },
    { main_stem: '庚', sub_stem: '己', ten_major_star: '玉堂星' },
    { main_stem: '辛', sub_stem: '辛', ten_major_star: '貫索星' },
    { main_stem: '辛', sub_stem: '庚', ten_major_star: '石門星' },
    { main_stem: '辛', sub_stem: '癸', ten_major_star: '鳳閣星' },
    { main_stem: '辛', sub_stem: '壬', ten_major_star: '調舒星' },
    { main_stem: '辛', sub_stem: '乙', ten_major_star: '禄存星' },
    { main_stem: '辛', sub_stem: '甲', ten_major_star: '司禄星' },
    { main_stem: '辛', sub_stem: '丁', ten_major_star: '車騎星' },
    { main_stem: '辛', sub_stem: '丙', ten_major_star: '牽牛星' },
    { main_stem: '辛', sub_stem: '己', ten_major_star: '龍高星' },
    { main_stem: '辛', sub_stem: '戊', ten_major_star: '玉堂星' },
    { main_stem: '壬', sub_stem: '壬', ten_major_star: '貫索星' },
    { main_stem: '壬', sub_stem: '癸', ten_major_star: '石門星' },
    { main_stem: '壬', sub_stem: '甲', ten_major_star: '鳳閣星' },
    { main_stem: '壬', sub_stem: '乙', ten_major_star: '調舒星' },
    { main_stem: '壬', sub_stem: '丙', ten_major_star: '禄存星' },
    { main_stem: '壬', sub_stem: '丁', ten_major_star: '司禄星' },
    { main_stem: '壬', sub_stem: '戊', ten_major_star: '車騎星' },
    { main_stem: '壬', sub_stem: '己', ten_major_star: '牽牛星' },
    { main_stem: '壬', sub_stem: '庚', ten_major_star: '龍高星' },
    { main_stem: '壬', sub_stem: '辛', ten_major_star: '玉堂星' },
    { main_stem: '癸', sub_stem: '癸', ten_major_star: '貫索星' },
    { main_stem: '癸', sub_stem: '壬', ten_major_star: '石門星' },
    { main_stem: '癸', sub_stem: '乙', ten_major_star: '鳳閣星' },
    { main_stem: '癸', sub_stem: '甲', ten_major_star: '調舒星' },
    { main_stem: '癸', sub_stem: '丁', ten_major_star: '禄存星' },
    { main_stem: '癸', sub_stem: '丙', ten_major_star: '司禄星' },
    { main_stem: '癸', sub_stem: '己', ten_major_star: '車騎星' },
    { main_stem: '癸', sub_stem: '戊', ten_major_star: '牽牛星' },
    { main_stem: '癸', sub_stem: '辛', ten_major_star: '龍高星' },
    { main_stem: '癸', sub_stem: '庚', ten_major_star: '玉堂星' }
  ]
end
