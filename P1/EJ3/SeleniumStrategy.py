from ScrapeStrategy import ScrapeStrategy
from selenium import webdriver
from selenium.webdriver.common.by import By

class SeleniumStrategy(ScrapeStrategy):
    
    # Se ha usado init para configurar el driver de selenium
    def __init__(self):
        options = webdriver.ChromeOptions()
        options.add_argument("--headless")
        self.driver = webdriver.Chrome(options=options)
    
    # Separamos responsabilidades
    def obtener_valores(self):
        # Con el metodo find_elements se obtienen todos los elementos que coincidan con el criterio de busqueda
        # Usamos strip para eliminar los espacios en blanco 
        quotes = []
        for quote_div in self.driver.find_elements(By.CLASS_NAME, "quote"):
            quote = {
                "text": quote_div.find_element(By.XPATH, './/span[@class="text"]').text.strip(),
                "author": quote_div.find_element(By.XPATH, './/small[@class="author"]').text.strip(),
                "tags": [tag.text for tag in quote_div.find_elements(By.XPATH, './/a[@class="tag"]')]
            }
            quotes.append(quote)
        return quotes
        
   
    def scrape(self, url):
        self.driver.get(url)
        
        quotes = []
        for page in range(1, 6):
            self.driver.get(f"{url}/page/{page}") # se obtiene la pagina
            quotes.extend(self.obtener_valores())
        self.driver.quit() # se libera el driver
        return quotes


