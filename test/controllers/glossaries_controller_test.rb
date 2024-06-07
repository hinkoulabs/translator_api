require 'test_helper'

class GlossariesControllerTest < ActionDispatch::IntegrationTest
  context 'create' do
    should 'create glossary' do
      valid_attrs = {
        source_language_code: 'fr',
        target_language_code: 'de'
      }

      assert_difference('Glossary.count') do
        post glossaries_url, params: valid_attrs, as: :json
      end

      assert_response :created

      glossary = Glossary.last

      assert_record_attributes(glossary, valid_attrs)

      assert_equal(
        {
          "id" => glossary.id,
          "source_language_code"=>"fr",
          "target_language_code"=>"de",
          "terms"=>[]
        },
        response.parsed_body
      )
    end

    should 'not create glossary with invalid data' do
      post glossaries_url, params: { source_language_code: 'xx', target_language_code: 'yy' }, as: :json

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"Source language code is not included in the list, Target language code is not included in the list"
        },
        response.parsed_body
      )
    end

    should 'not create glossary with missing source_language_code' do
      post glossaries_url, params: { source_language_code: '' }, as: :json

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: source_language_code"
        },
        response.parsed_body
      )
    end

    should 'not create glossary with empty source_language_code' do
      post glossaries_url, params: { source_language_code: '' }, as: :json

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: source_language_code"
        },
        response.parsed_body
      )
    end

    should 'not create glossary with missing target_language_code' do
      post glossaries_url, params: { source_language_code: 'en' }, as: :json

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: target_language_code"
        },
        response.parsed_body
      )
    end
  end

  test 'should show glossary' do
    glossary = glossaries(:en_es)

    get glossary_url(glossary), as: :json

    assert_response :success

    assert_equal(
      {
        "id"=>1,
        "source_language_code"=>"en",
        "target_language_code"=>"es",
        "terms"=>[
          {"id"=>1, "source_term"=>"hello", "target_term"=>"hola"},
          {"id"=>2, "source_term"=>"world", "target_term"=>"mundo"}
        ]
      },
      response.parsed_body
    )
  end

  test 'should get index' do
    get glossaries_url, as: :json

    assert_response :success

    assert_equal(
      [
        {
          "id"=>1,
          "source_language_code"=>"en",
          "target_language_code"=>"es",
          "terms"=>[
            {"id"=>1, "source_term"=>"hello", "target_term"=>"hola"},
            {"id"=>2, "source_term"=>"world", "target_term"=>"mundo"}
          ]
        },
        {
          "id"=>2,
          "source_language_code"=>"en",
          "target_language_code"=>"ca",
          "terms" => []
        }
      ],
      response.parsed_body
    )
  end
end