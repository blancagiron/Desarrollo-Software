class CreateEnvios < ActiveRecord::Migration[7.0]
  def change
    create_table :envios do |t|
      t.json :sillas
      t.integer :estado, default: 0
      t.string :direccion

      t.timestamps
    end
  end
end
