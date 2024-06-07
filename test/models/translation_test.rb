require "test_helper"

class TranslationTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:source_text)

    should validate_length_of(:source_text).is_at_most(5000)
  end
end