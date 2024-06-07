class Translation < ApplicationRecord
  belongs_to :glossary

  validates :source_text, presence: true, length: { maximum: 5000 }

  def highlight_source_text(tag: "HIGHLIGHT")
    @highlight_source_text ||= begin
                                 terms = self.glossary.terms

                                 highlighted_text = self.source_text.dup

                                 # replace terms
                                 terms.each do |term|
                                   highlighted_text.gsub!(term.source_term, "<#{tag}>#{term.source_term}</#{tag}>")
                                 end

                                 highlighted_text
                               end
  end
end