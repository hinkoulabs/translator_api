class CreateGlossaries < ActiveRecord::Migration[7.1]
  def change
    create_table :glossaries do |t|
      t.string :source_language_code
      t.string :target_language_code

      t.timestamps
    end

    add_index :glossaries, [:source_language_code, :target_language_code], unique: true
  end
end
