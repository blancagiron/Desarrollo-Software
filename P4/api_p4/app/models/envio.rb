class Envio < ApplicationRecord
  enum estado: { pendiente: 0, en_transito: 1, entregado: 2 }
  
  validates :direccion, presence: true
  validates :sillas, presence: true
  
  # Establecer estado por defecto si no se proporciona
  before_validation :set_default_estado, on: :create
  
  private
  
  def set_default_estado
    self.estado ||= :pendiente
  end
end
