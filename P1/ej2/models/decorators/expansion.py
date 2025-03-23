import requests
from models.llm import LLM
from models.decorators.llm_decorator import LLMDecorator

# Decorador concreto para expansión
class ExpansionDecorator(LLMDecorator):
    
    def __init__(self, llm: LLM, expansion_model, api_token, api_url):

        super().__init__(llm, api_token, api_url)
        self.expansion_model = expansion_model

    def generate_summary(self, text, input_lang, output_lang, model) :

        summary = self.llm.generate_summary(text, input_lang, output_lang, model)
        
        prompt = f"Expande: {summary[:100]}"  # Limitar el texto para evitar exceder límites
        
        # Expandir el resumen con truncación
        headers = {"Authorization": f"Bearer {self.api_token}"}
        payload = {
            "inputs": prompt,
            "parameters": {
                "truncation": "longest_first",
                "max_length": 128  # Asegurar que no excedemos el límite del modelo
            }
        }

        response = requests.post(
            f"{self.api_url}{self.expansion_model}",
            headers=headers,
            json=payload
        )
        
        if response.status_code == 200:
            result = response.json()
            if isinstance(result, list) and len(result) > 0:
                if "generated_text" in result[0]:
                    expanded_text = result[0]["generated_text"]
                else:
                    expanded_text (result[0])
            else:
                expanded_text (result)
            
            return f"Resumen original: {summary}\n\nExpansión: {expanded_text}"
        else:
            return f"Error al expandir: {response.text}"