require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @glossary = glossaries(:en_es)
  end

  context 'create' do
    should 'create term' do
      valid_attrs = { source_term: 'test', target_term: 'prueba' }

      assert_difference('Term.count') do
        post glossary_terms_url(@glossary), params: valid_attrs, as: :json
      end

      assert_response :created

      term = Term.last

      assert_record_attributes(term, valid_attrs)
    end

    should 'not create term with invalid source_term and target_term' do
      assert_no_difference('Term.count') do
        post glossary_terms_url(@glossary), params: { source_term: '', target_term: '' }, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: source_term"
        },
        response.parsed_body
      )
    end

    should 'not create term with invalid target_term' do
      assert_no_difference('Term.count') do
        post glossary_terms_url(@glossary), params: { source_term: 'en', target_term: '' }, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: target_term"
        },
        response.parsed_body
      )
    end
  end
end