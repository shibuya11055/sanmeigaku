# == Schema Information
#
# Table name: stem_lineages
#
#  id                          :bigint           not null, primary key
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  day_stem_id                 :bigint           not null
#  f_grandfather_stem_id       :bigint           not null
#  f_grandmother_stem_id       :bigint           not null
#  f_stem_id                   :bigint           not null
#  father_in_law_stem_id       :bigint           not null
#  female_child_spouse_stem_id :bigint           not null
#  female_child_stem_id        :bigint           not null
#  m_grandfather_stem_id       :bigint           not null
#  m_grandmother_stem_id       :bigint           not null
#  m_stem_id                   :bigint           not null
#  male_child_spouse_stem_id   :bigint           not null
#  male_child_stem_id          :bigint           not null
#  mother_in_law_stem_id       :bigint           not null
#  spouse_stem_id              :bigint           not null
#
# Indexes
#
#  index_stem_lineages_on_day_stem_id                  (day_stem_id)
#  index_stem_lineages_on_f_grandfather_stem_id        (f_grandfather_stem_id)
#  index_stem_lineages_on_f_grandmother_stem_id        (f_grandmother_stem_id)
#  index_stem_lineages_on_f_stem_id                    (f_stem_id)
#  index_stem_lineages_on_father_in_law_stem_id        (father_in_law_stem_id)
#  index_stem_lineages_on_female_child_spouse_stem_id  (female_child_spouse_stem_id)
#  index_stem_lineages_on_female_child_stem_id         (female_child_stem_id)
#  index_stem_lineages_on_m_grandfather_stem_id        (m_grandfather_stem_id)
#  index_stem_lineages_on_m_grandmother_stem_id        (m_grandmother_stem_id)
#  index_stem_lineages_on_m_stem_id                    (m_stem_id)
#  index_stem_lineages_on_male_child_spouse_stem_id    (male_child_spouse_stem_id)
#  index_stem_lineages_on_male_child_stem_id           (male_child_stem_id)
#  index_stem_lineages_on_mother_in_law_stem_id        (mother_in_law_stem_id)
#  index_stem_lineages_on_spouse_stem_id               (spouse_stem_id)
#
# Foreign Keys
#
#  fk_rails_...  (day_stem_id => stems.id)
#  fk_rails_...  (f_grandfather_stem_id => stems.id)
#  fk_rails_...  (f_grandmother_stem_id => stems.id)
#  fk_rails_...  (f_stem_id => stems.id)
#  fk_rails_...  (father_in_law_stem_id => stems.id)
#  fk_rails_...  (female_child_spouse_stem_id => stems.id)
#  fk_rails_...  (female_child_stem_id => stems.id)
#  fk_rails_...  (m_grandfather_stem_id => stems.id)
#  fk_rails_...  (m_grandmother_stem_id => stems.id)
#  fk_rails_...  (m_stem_id => stems.id)
#  fk_rails_...  (male_child_spouse_stem_id => stems.id)
#  fk_rails_...  (male_child_stem_id => stems.id)
#  fk_rails_...  (mother_in_law_stem_id => stems.id)
#  fk_rails_...  (spouse_stem_id => stems.id)
#
require "test_helper"

class StemLineageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
