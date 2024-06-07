require 'csv'

class LanguageCodeService
  def self.codes
    @codes ||= load_codes
  end

  def self.load_codes
    csv_path = Rails.root.join('config', 'language-codes.csv')
    codes = []

    CSV.foreach(csv_path, headers: true) do |row|
      codes << row['code']
    end

    codes
  end
end