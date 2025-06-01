class Silla {
  bool respaldo;
  bool ruedas;
  bool acolchada;
  double precio;
  String tipo = "";

  Silla(this.respaldo, this.ruedas, this.acolchada, this.precio);

  double getPrecio() => precio;

  void setPrecio(double nuevoPrecio) {
    precio = nuevoPrecio;
  }

  void setToString(String silla){
    tipo = silla;
  }

  String toString() {
    return tipo;
  }

  void setRespaldo(bool tieneRespaldo) {
    respaldo = tieneRespaldo;
  }

  void setAcolchada(bool esAcolchada) {
    acolchada = esAcolchada;
  }

  void setRuedas(bool tieneRuedas) {
    ruedas = tieneRuedas;
  }

  Map<String, dynamic> toJson() {
    return {
      'respaldo': respaldo,
      'ruedas': ruedas,
      'acolchada': acolchada,
      'precio': precio,
      'tipo': tipo,
    };
  }
}
