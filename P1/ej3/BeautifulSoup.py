from ScrapeStrategy import ScrapeStrategy
from bs4 import BeautifulSoup
import requests

class BeautifulSoupScrap(ScrapeStrategy):
    # Separamos responsabilidades
    def obtener_html(self, url, page): 
        response = requests.get(f"{url}/page/{page}")
        return response.text
    
    def obtener_datos(self, html):
        soup = BeautifulSoup(html, "html.parser")
        return [
            {
                "text": quote.find("span", class_="text").get_text(strip=True),
                "author": quote.find("small", class_="author").get_text(strip=True),
                "tags": [tag.get_text(strip=True) for tag in quote.find_all("a", class_="tag")]
            }
            for quote in soup.find_all("div", class_="quote")
        ]
    
    def scrape(self, url):
        quotes = []
        for page in range(1,6):
            html = self.obtener_html(url, page)
            quotes.extend(self.obtener_datos(html))
        return quotes
    

