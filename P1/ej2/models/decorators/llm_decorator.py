from abc import abstractmethod
from models.llm import LLM

# Decorador base
class LLMDecorator(LLM):
    
    def __init__(self, llm: LLM, api_token, api_url):
        super().__init__(api_token, api_url)
        self.llm = llm
    
    @abstractmethod
    def generate_summary(self, text, input_lang, output_lang, model) :
        pass