class CreateLicitacaos < ActiveRecord::Migration[8.1]
  def change
    create_table :licitacaos do |t|
      t.string :numero
      t.string :orgao
      t.text :objeto
      t.decimal :valor
      t.datetime :data_abertura

      t.timestamps
    end
  end
end
