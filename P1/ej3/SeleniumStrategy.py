import time
from ScrapeStrategy import ScrapeStrategy
from selenium import webdriver
from selenium.webdriver.common.by import By

class SeleniumStrategy(ScrapeStrategy):
    
    def __init__(self, num_pages=5, headless=True):
        """Inicializa los atributos de la clase con valores de configuración."""
        self.num_pages = num_pages  # Número de páginas a recorrer
        self.headless = headless  # Modo sin interfaz gráfica
        self.next_button_xpath = '//li[@class="next"]/a'  # XPATH del botón "Next"
        self.quote_class = "quote"  # Clase de los elementos de citas
        self.text_xpath = './/span[@class="text"]'  # XPATH del texto de la cita
        self.author_xpath = './/small[@class="author"]'  # XPATH del autor
        self.tags_xpath = './/a[@class="tag"]'  # XPATH de las etiquetas

        # Configuración del driver de Selenium
        options = webdriver.ChromeOptions()
        if self.headless:
            options.add_argument("--headless")  # Ejecutar sin interfaz gráfica
        self.driver = webdriver.Chrome(options=options)
    
    def obtener_valores(self):
        """Extrae citas de la página actual usando atributos de clase."""
        quotes = []
        for quote_div in self.driver.find_elements(By.CLASS_NAME, self.quote_class):
            quote = {
                "text": quote_div.find_element(By.XPATH, self.text_xpath).text.strip(),
                "author": quote_div.find_element(By.XPATH, self.author_xpath).text.strip(),
                "tags": [tag.text for tag in quote_div.find_elements(By.XPATH, self.tags_xpath)]
            }
            quotes.append(quote)
        return quotes
        
    def scrape(self, url):
        self.driver.get(url)
        quotes = []

        for _ in range(self.num_pages):  # Usa el atributo en lugar de hardcodear
            quotes.extend(self.obtener_valores())  
            
            try:
                next_button = self.driver.find_element(By.XPATH, self.next_button_xpath)  
                next_button.click()  
                time.sleep(2)  # Espera a que cargue la nueva página
            except:
                print("No se encontró el botón 'Next'. Saliendo...")
                break  
        
        self.driver.quit()  # Cierra el navegador
        return quotes