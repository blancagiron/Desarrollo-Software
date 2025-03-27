from models.basic_llm import BasicLLM
from models.decorators.translation import TranslationDecorator
from models.decorators.expansion import ExpansionDecorator
from utils.config import load_config

def main():
    # Leer la configuración desde un archivo JSON
    config = load_config("config.json")
    
    # Obtener parámetros de configuración
    text = config["texto"]
    input_lang = config["input_lang"]
    output_lang = config["output_lang"]
    model_llm = config["model_llm"]
    model_translation = config["model_translation"]
    model_expansion = config["model_expansion"]
    
    # Token de API de Hugging Face (en un entorno real debería estar en una variable de entorno)
    api_token = ""
    API_URL = "https://api-inference.huggingface.co/models/"
    
    # Crear el LLM básico
    basicllm = BasicLLM(api_token, API_URL)
    print("## Resumen básico:")
    basic_summary = basicllm.generate_summary(text, input_lang, output_lang, model_llm)
    print(basic_summary)
    print("\n" + "-"*50 + "\n")
    
    # Crear LLM con decorador de traducción
    translatedllm = TranslationDecorator(basicllm, model_translation, api_token, API_URL)
    print("## Resumen traducido:")
    translated_summary = translatedllm.generate_summary(text, input_lang, output_lang, model_llm)
    print(translated_summary)
    print("\n" + "-"*50 + "\n")
    
    # Crear LLM con decorador de expansión
    expandedllm = ExpansionDecorator(basicllm, model_expansion, api_token, API_URL)
    print("## Resumen expandido:")
    expanded_summary = expandedllm.generate_summary(text, input_lang, output_lang, model_llm)
    print(expanded_summary)
    print("\n" + "-"*50 + "\n")
    
    # Crear LLM con ambos decoradores (primero traducir, luego expandir)
    combinedllm = ExpansionDecorator(translatedllm, model_expansion, api_token, API_URL)
    print("## Resumen traducido y expandido:")
    combined_summary = combinedllm.generate_summary(text, input_lang, output_lang, model_llm)
    print(combined_summary)

if __name__ == "__main__":
    main()
