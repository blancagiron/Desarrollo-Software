import 'silla.dart';

abstract class SillaBuilder {
  void crearNuevaSilla();
  void setRespaldo();
  void setPrecio();
  void setAcolchada();
  void setRuedas();
  Silla getSilla();
}

class SillaGamingBuilder implements SillaBuilder {
  late Silla silla;

  @override
  void crearNuevaSilla() {
    silla = Silla(false, false, false, 0.0);
    silla.setToString("gaming");
  }

  @override
  void setRespaldo() {
    silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    silla.setPrecio(299.99);
  }

  @override
  void setAcolchada() {
    silla.setAcolchada(true);
  }

  @override
  void setRuedas() {
    silla.setRuedas(true);
  }

  @override
  Silla getSilla() {
    return silla;
  }
}

class SillaOficinaBuilder implements SillaBuilder {
  late Silla silla;

  @override
  void crearNuevaSilla() {
    silla = Silla(false, false, false, 0.0);
    silla.setToString("oficina");
  }

  @override
  void setRespaldo() {
    silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    silla.setPrecio(199.99);
  }

  @override
  void setAcolchada() {
    silla.setAcolchada(false);
  }

  @override
  void setRuedas() {
    silla.setRuedas(true);
  }

  @override
  Silla getSilla(){
    return silla;
  }
}

class SillaComedorBuilder implements SillaBuilder {
  late Silla silla;

  @override
  void crearNuevaSilla() {
    silla = Silla(false, false, false, 0.0);
    silla.setToString("comedor");
  }

  @override
  void setRespaldo() {
    silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    silla.setPrecio(89.99);
  }

  @override
  void setAcolchada() {
    silla.setAcolchada(false);
  }

  @override
  void setRuedas() {
    silla.setRuedas(false);
  }

  @override
  Silla getSilla(){
    return silla;
  }
}

class SillaInfantilBuilder implements SillaBuilder {
  late Silla silla;

  @override
  void crearNuevaSilla() {
    silla = Silla(false, false, false, 0.0);
    silla.setToString("infantil");
  }

  @override
  void setRespaldo() {
    silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    silla.setPrecio(49.99);
  }

  @override
  void setAcolchada() {
    silla.setAcolchada(true);
  }

  @override
  void setRuedas() {
    silla.setRuedas(false);
  }

  @override
  Silla getSilla() {
    return silla;
  }
}