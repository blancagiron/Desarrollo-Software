import yaml
from Context import Context
from BeautifulSoup import BeautifulSoupScrap
from SeleniumStrategy import SeleniumStrategy

def pasar_a_yaml(datos, filename):
    with open(filename, "w") as file:
        yaml.dump(datos, file, default_flow_style=False)
        

def main():
    
    url = "https://quotes.toscrape.com"
   
    # Solicitamos al usuario que elija la estrategia de scraping
    # Se realiza el scraping y se guarda en un archivo yaml
    estrategia = input("Elija la estrategia de scraping (1 para BeautifulSoup, 2 para Selenium): ")
    
    if estrategia == "1":
        context = Context(BeautifulSoupScrap())
        datos = context.scrape(url)
        pasar_a_yaml(datos, "quotesBeautifulSoup.yaml")
    elif estrategia == "2":
        context = Context(SeleniumStrategy())
        datos = context.scrape(url)
        pasar_a_yaml(datos, "quotesSelenium.yaml")
    else:
        print("Estrategia no válida. Por favor, elija 1 o 2.")
    
if __name__ == "__main__":
    main()
    
    
    
