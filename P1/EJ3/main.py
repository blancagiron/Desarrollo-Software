import yaml
from Context import Context
from BeautifulSoup import BeautifulSoupScrap
from SeleniumStrategy import SeleniumStrategy

def pasar_a_yaml(datos, filename):
    with open(filename, "w") as file:
        yaml.dump(datos, file, default_flow_style=False)
        

def main():
    
    url = "https://quotes.toscrape.com"
   
    
    # Se realiza el scraping y se guarda en un archivo yaml
    context = Context(BeautifulSoupScrap())
    datosBeautifulSoup = context.scrape(url)
    pasar_a_yaml(datosBeautifulSoup, "quotesBeautifulSoup.yaml")
    
    #cambio de estrategia
    context.set_strategy(SeleniumStrategy())
    datosSelenium = context.scrape(url)
    pasar_a_yaml(datosSelenium, "quotesSelenium.yaml")
    
    
   
    
if __name__ == "__main__":
    main()
    
    
    
