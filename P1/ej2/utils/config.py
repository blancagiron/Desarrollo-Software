import json

# Función para cargar la configuración desde un archivo JSON
def load_config(config_file):
    try:
        with open(config_file, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error al cargar la configuración: {e}")
        exit(1)