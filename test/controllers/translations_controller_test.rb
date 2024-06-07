require 'test_helper'

class TranslationsControllerTest < ActionDispatch::IntegrationTest
  context 'create' do
    should 'create translation without glossary' do
      assert_no_difference('Glossary.count') do
        assert_difference('Translation.count') do
          post translations_url, params: valid_attributes, as: :json
        end
      end

      assert_response :created

      t = Translation.last

      assert_equal(
        {
          "id"=>t.id,
          "source_text"=>"hello world",
          "highlight_source_text"=>"<HIGHLIGHT>hello</HIGHLIGHT> <HIGHLIGHT>world</HIGHLIGHT>",
          "glossary_id"=>1
        },
        response.parsed_body
      )
    end

    should 'create translation without glossary where new glossary is created' do
      assert_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: valid_attributes.merge(target_language_code: 'fr'), as: :json
      end

      assert_response :created

      g = Glossary.last

      assert_record_attributes(g, source_language_code: 'en', target_language_code: 'fr')

      t = Translation.last

      assert_record_attributes(t, source_text: "hello world")

      assert_equal(
        {
          "id"=>t.id,
          "source_text"=>"hello world",
          "highlight_source_text"=>"hello world",
          "glossary_id"=>g.id
        },
        response.parsed_body
      )
    end

    should 'not create if glosary is missing and :source_language_code and :target_language_code are invalid' do
      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: valid_attributes.merge(source_language_code: 'invalid', target_language_code: 'invalid'), as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"Validation failed: Source language code is not included in the list, Target language code is not included in the list"
        },
        response.parsed_body
      )
    end

    should 'not create if glosary is missing and Translation#save raise an error' do
      Translation.any_instance.stubs(:save!).raises(StandardError, 'can not save translation')
      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: valid_attributes, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"can not save translation"
        },
        response.parsed_body
      )
    end

    should 'create translation with glossary' do
      glossary = glossaries(:en_es)
      assert_difference('Translation.count') do
        post translations_url, params: valid_attributes.merge(glossary_id: glossary.id), as: :json
      end

      assert_response :created

      t = Translation.last

      assert_equal(
        {
          "id"=>t.id,
          "source_text"=>"hello world",
          "highlight_source_text"=>"<HIGHLIGHT>hello</HIGHLIGHT> <HIGHLIGHT>world</HIGHLIGHT>",
          "glossary_id"=>1
        },
        response.parsed_body
      )
    end

    should 'not create if glosary has mismatch on :source_language_code' do
      glossary = glossaries(:en_es)

      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: valid_attributes.merge(glossary_id: glossary.id, source_language_code: 'ca'), as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"Language codes do not match glossary"
        },
        response.parsed_body
      )
    end

    should 'not create if glosary has mismatch on :target_language_code' do
      glossary = glossaries(:en_es)

      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: valid_attributes.merge(glossary_id: glossary.id, target_language_code: 'ca'), as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"Language codes do not match glossary"
        },
        response.parsed_body
      )
    end

    should 'not create translation with missing data' do
      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: source_language_code"
        },
        response.parsed_body
      )
    end

    should 'not create translation with missing :target_language_code' do
      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: { source_language_code: 'en' }, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: target_language_code"
        },
        response.parsed_body
      )
    end

    should 'not create translation with missing :source_text' do
      assert_no_difference(['Glossary.count', 'Translation.count']) do
        post translations_url, params: { source_language_code: 'en', target_language_code: 'es' }, as: :json
      end

      assert_response :unprocessable_entity

      assert_equal(
        {
          "error"=>"param is missing or the value is empty: source_text"
        },
        response.parsed_body
      )
    end
  end

  context 'show' do
    should 'show translation' do
      translation = translations(:one)

      get translation_url(translation), as: :json

      assert_response :success

      assert_equal(
        {
          "id"=>1,
          "source_text"=>"hello world! how are you today, world?",
          "highlight_source_text"=>"<HIGHLIGHT>hello</HIGHLIGHT> <HIGHLIGHT>world</HIGHLIGHT>! how are you today, <HIGHLIGHT>world</HIGHLIGHT>?",
          "glossary_id"=>1
        },
        response.parsed_body
      )
    end
  end

  private

  def valid_attributes
    { source_language_code: 'en', target_language_code: 'es', source_text: 'hello world' }
  end
end