require "test_helper"

class TermTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:source_term)
    should validate_presence_of(:target_term)
  end
end