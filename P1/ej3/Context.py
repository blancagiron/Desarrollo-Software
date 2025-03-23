class Context:
    # En el diagrama URL , la relación entre Context y ScrapeStrategy es de agregación ,
    def __init__(self, strategy):
        self._strategy = strategy
    
    def set_strategy(self, strategy):
        self._strategy = strategy
    
    def scrape(self, url):
        return self._strategy.scrape(url)
    