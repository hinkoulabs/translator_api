class TermsController < ApplicationController
  before_action :find_glossary

  def create
    @term = @glossary.terms.new(term_params)
    if @term.save
      render :create, status: :created
    else
      build_validation_error(@term)
      render 'shared/error', status: :unprocessable_entity
    end
  end

  private

  def find_glossary
    @glossary = Glossary.find(params[:glossary_id])
  end

  def term_params
    params.require(:source_term)
    params.require(:target_term)
    params.permit(:source_term, :target_term)
  end
end