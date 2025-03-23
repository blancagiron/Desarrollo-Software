import requests
from .llm import LLM

# Implementación concreta del LLM básico
class BasicLLM(LLM):
    def __init__(self, api_token, api_url):
        super().__init__(api_token, api_url)
    
    def generate_summary(self, text, input_lang, output_lang, model):
        headers = {"Authorization": f"Bearer {self.api_token}"}
        payload = {"inputs": text, "parameters": {"max_length": 150, "min_length": 50}}
        
        response = requests.post(
            f"{self.api_url}{model}",
            headers=headers,
            json=payload
        )
        
        if response.status_code == 200:
            result = response.json()
            # La respuesta puede variar según el modelo, pero generalmente es una lista con un elemento
            if isinstance(result, list) and len(result) > 0:
                if isinstance(result[0], dict) and "summary_text" in result[0]:
                    return result[0]["summary_text"]
                elif isinstance(result[0], dict) and "generated_text" in result[0]:
                    return result[0]["generated_text"]
            return(result)
        else:
            return f"Error al generar resumen: {response.text}"