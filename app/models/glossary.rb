class Glossary < ApplicationRecord
  has_many :terms, dependent: :destroy

  validates :source_language_code, presence: true, inclusion: { in: LanguageCodeService.codes }
  validates :target_language_code, presence: true, inclusion: { in: LanguageCodeService.codes }
  validates :source_language_code, uniqueness: { scope: :target_language_code }

  def has_mismatch?(attrs)
    self.source_language_code != attrs[:source_language_code] || self.target_language_code != attrs[:target_language_code]
  end
end