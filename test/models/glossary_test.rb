require "test_helper"

class GlossaryTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:source_language_code)
    should validate_inclusion_of(:source_language_code).in_array(LanguageCodeService.codes)

    should validate_presence_of(:target_language_code)
    should validate_inclusion_of(:target_language_code).in_array(LanguageCodeService.codes)

    should should validate_uniqueness_of(:source_language_code).scoped_to(:target_language_code)
  end
end