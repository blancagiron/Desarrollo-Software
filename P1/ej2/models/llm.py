from abc import ABC, abstractmethod

# Clase base abstracta LLM
class LLM(ABC):
    def __init__(self, api_token, api_url: str):
        self.api_token = api_token
        self.api_url = api_url

    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang, model):
        pass