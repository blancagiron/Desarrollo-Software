class Silla {
  bool respaldo;
  bool ruedas;
  bool acolchada;
  double precio;

  Silla(this.respaldo, this.ruedas, this.acolchada, this.precio);

  double getPrecio() => precio;

  void setPrecio(double nuevoPrecio) {
    precio = nuevoPrecio;
  }

  String toString() {
    return "Silla(respaldo: $respaldo, ruedas: $ruedas, acolchada: $acolchada, precio: \$${precio.toStringAsFixed(2)})";
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
}