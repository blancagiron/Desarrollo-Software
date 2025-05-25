import 'silla.dart';

abstract class SillaBuilder {
  void crearNuevaSilla();
  void setRespaldo();
  void setPrecio();
  void setAcolchada();
  void setRuedas();
}

class SillaGamingBuilder implements SillaBuilder {
  late Silla _silla;

  @override
  void crearNuevaSilla() {
    _silla = Silla(false, false, false, 0.0);
  }

  @override
  void setRespaldo() {
    _silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    _silla.setPrecio(299.99);
  }

  @override
  void setAcolchada() {
    _silla.setAcolchada(true);
  }

  @override
  void setRuedas() {
    _silla.setRuedas(true);
  }

  Silla getSilla() => _silla;
}

class SillaOficinaBuilder implements SillaBuilder {
  late Silla _silla;

  @override
  void crearNuevaSilla() {
    _silla = Silla(false, false, false, 0.0);
  }

  @override
  void setRespaldo() {
    _silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    _silla.setPrecio(199.99);
  }

  @override
  void setAcolchada() {
    _silla.setAcolchada(false);
  }

  @override
  void setRuedas() {
    _silla.setRuedas(true);
  }

  Silla getSilla() => _silla;
}

class SillaComedorBuilder implements SillaBuilder {
  late Silla _silla;

  @override
  void crearNuevaSilla() {
    _silla = Silla(false, false, false, 0.0);
  }

  @override
  void setRespaldo() {
    _silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    _silla.setPrecio(89.99);
  }

  @override
  void setAcolchada() {
    _silla.setAcolchada(false);
  }

  @override
  void setRuedas() {
    _silla.setRuedas(false);
  }

  Silla getSilla() => _silla;
}

class SillaInfantilBuilder implements SillaBuilder {
  late Silla _silla;

  @override
  void crearNuevaSilla() {
    _silla = Silla(false, false, false, 0.0);
  }

  @override
  void setRespaldo() {
    _silla.setRespaldo(true);
  }

  @override
  void setPrecio() {
    _silla.setPrecio(49.99);
  }

  @override
  void setAcolchada() {
    _silla.setAcolchada(true);
  }

  @override
  void setRuedas() {
    _silla.setRuedas(false);
  }

  Silla getSilla() => _silla;
}