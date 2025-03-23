from ScrapeStrategy import ScrapeStrategy
from bs4 import BeautifulSoup
import requests

class BeautifulSoupScrap(ScrapeStrategy):
    
    def __init__(self, num_pages=5):
        """Inicializa los atributos de la clase con los valores de configuración."""
        self.num_pages = num_pages  # Número de páginas a recorrer
        self.quote_class = "quote"  # Clase de los elementos de citas
        self.text_tag = "span"  # Etiqueta del texto de la cita
        self.text_class = "text"  # Clase del texto de la cita
        self.author_tag = "small"  # Etiqueta del autor
        self.author_class = "author"  # Clase del autor
        self.tags_tag = "a"  # Etiqueta de las etiquetas de la cita
        self.tags_class = "tag"  # Clase de las etiquetas

    def obtener_html(self, url, page): 
        """Obtiene el HTML de la página."""
        response = requests.get(f"{url}/page/{page}")
        return response.text
    
    def obtener_datos(self, html):
        """Extrae citas de la página actual usando atributos de clase."""
        soup = BeautifulSoup(html, "html.parser")
        return [
            {
                "text": quote.find(self.text_tag, class_=self.text_class).get_text(strip=True),
                "author": quote.find(self.author_tag, class_=self.author_class).get_text(strip=True),
                "tags": [tag.get_text(strip=True) for tag in quote.find_all(self.tags_tag, class_=self.tags_class)]
            }
            for quote in soup.find_all("div", class_=self.quote_class)
        ]
    
    def scrape(self, url):
        quotes = []

        for page in range(1, self.num_pages + 1):  # Usa el atributo en lugar de hardcodear
            html = self.obtener_html(url, page)
            quotes.extend(self.obtener_datos(html))
        
        return quotes
