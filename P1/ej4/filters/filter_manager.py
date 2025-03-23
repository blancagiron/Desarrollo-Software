from .filter_chain import FilterChain

class FilterManager:
    def __init__(self, target):
        self.filter_chain = FilterChain()
        self.filter_chain.set_target(target)
    
    def add_filter(self, filter_obj):
        self.filter_chain.add_filter(filter_obj)
    
    def process_request(self, request):
        errors = self.filter_chain.execute(request)
        if errors:
            return {'success': False, 'errors': errors}
        return self.filter_chain.target.process(request)