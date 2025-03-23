import requests
from models.llm import LLM
from models.decorators.llm_decorator import LLMDecorator

# Decorador concreto para traducción
class TranslationDecorator(LLMDecorator):
    
    def __init__(self, llm: LLM, translation_model, api_token, api_url):

        super().__init__(llm, api_token, api_url)
        self.translation_model = translation_model
    
    def generate_summary(self, text, input_lang, output_lang, model):
        summary = self.llm.generate_summary(text, input_lang, output_lang, model)

        # Traducir el resumen
        headers = {"Authorization": f"Bearer {self.api_token}"}
        payload = {"inputs": summary}
        
        response = requests.post(
            f"{self.api_url}{self.translation_model}",
            headers=headers,
            json=payload
        )
        
        if response.status_code == 200:
            result = response.json()
            if isinstance(result, list) and len(result) > 0:
                return result[0]["translation_text"]
            return(result)
        else:
            return f"Error al traducir: {response.text}"