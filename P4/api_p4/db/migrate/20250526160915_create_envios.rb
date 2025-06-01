class CreateEnvios < ActiveRecord::Migration[7.0]
  def change
    create_table :envios, id: false do |t| # ⬅️ Disable autoincrement ID
      t.primary_key :id, :integer # ⬅️ ID personalizado, tipo entero
      t.json :sillas
      t.integer :estado, default: 0
      t.string :direccion
      t.integer :tipo, default: 0

      t.timestamps
    end
  end
end
