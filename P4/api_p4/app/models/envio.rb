class Envio < ApplicationRecord
  enum estado: { pendiente: 0, en_transito: 1, entregado: 2 }
  enum tipo: { normal: 0, express: 1 }

  validates :direccion, presence: true
  validates :sillas, presence: true
  validates :tipo, presence: true

  # Establecer estado por defecto si no se proporciona
  before_validation :set_default, on: :create

  private

  def set_default
    self.estado ||= :pendiente
    self.tipo ||= :normal
  end
end
