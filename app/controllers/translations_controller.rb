class TranslationsController < ApplicationController
  def create
    translation_attrs, glossary_attrs = translation_params
    @translation = Translation.new(translation_attrs)

    if @translation.glossary_id
      glossary = Glossary.find(@translation.glossary_id)

      if glossary.has_mismatch?(glossary_attrs)
        @error = I18n.t('errors.messages.language_codes_do_not_match')
        render 'shared/error', status: :unprocessable_entity
      else
        create_translation
      end
    else
      Translation.transaction do
        glossary = Glossary.find_or_initialize_by(glossary_attrs)
        glossary.save!

        @translation.glossary = glossary
        create_translation
      end
    end
  end

  def show
    @translation = Translation.find(params[:id])
  end

  private

  def create_translation
    @translation.save!
    render :create, status: :created
  end

  def translation_params
    params.require(:source_language_code)
    params.require(:target_language_code)
    params.require(:source_text)
    [
      # translation_attrs
      params.permit(:source_text, :glossary_id),
      # glossary_attrs
      params.permit(:source_language_code, :target_language_code)
    ]
  end
end