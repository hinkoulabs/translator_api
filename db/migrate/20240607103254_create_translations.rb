class CreateTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :translations do |t|
      t.text :source_text
      t.references :glossary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
