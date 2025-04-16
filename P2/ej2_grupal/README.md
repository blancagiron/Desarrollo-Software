# Selector de Modelos LLM - Flutter + Hugging Face

Este ejercicio, el 2 de la parte grupal de la práctica 2, implementa una aplicación Flutter que permite seleccionar diferentes modelos de lenguaje alojados en Hugging Face y enviarles preguntas o instrucciones. Se utiliza el patrón de diseño Strategy para cambiar fácilmente entre modelos sin modificar la lógica principal de la aplicación.

## Características

- Interfaz sencilla e intuitiva construida con Flutter.
- Comunicación con la API de inferencia de Hugging Face.
- Permite elegir entre varios modelos de lenguaje:
    - Falcon
    - Facebook BlenderBot
    - FLAN-T5
    - Phi-3 Mini
- Se muestran descripciones y formatos de prompt recomendados para cada modelo.
- Visualización de la respuesta del modelo.

## Patrón Strategy

El cambio de modelo se gestiona mediante el patrón de diseño Strategy. La clase `Contexto` actúa como intermediario entre la interfaz y la lógica de cada modelo. Cada modelo se define como una estrategia independiente que implementa cómo construir el prompt y realizar la petición.

## Ejecución

1. Clonar el repositorio.
2. Tener Flutter correctamente instalado.
3. Añadir el token de Hugging Face (si es necesario) en las estrategias correspondientes.
4. Ejecutar la aplicación con:

```
flutter run
```

## Capturas

Las capturas del funcionamiento de la aplicación se encuentran en la sección "Salida" de la memoria.