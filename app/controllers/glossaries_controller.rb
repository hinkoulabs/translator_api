class GlossariesController < ApplicationController
  def index
    @glossaries = Glossary.all
  end

  def create
    @glossary = Glossary.new(glossary_params)
    if @glossary.save
      render :create, status: :created
    else
      build_validation_error(@glossary)
      render "shared/error", status: :unprocessable_entity
    end
  end

  def show
    @glossary = Glossary.find(params[:id])
  end

  private

  def glossary_params
    params.require(:source_language_code)
    params.require(:target_language_code)
    params.permit(:source_language_code, :target_language_code)
  end
end