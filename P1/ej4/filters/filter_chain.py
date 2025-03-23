class FilterChain:
    def __init__(self):
        self.filters = []
        self.target = None
    
    def add_filter(self, filter_obj):
        self.filters.append(filter_obj)
        return self
    
    def set_target(self, target):
        self.target = target

    def execute(self, request):
        errors = []
        for filter_obj in self.filters:
            error = filter_obj.execute(request)
            if error:
                errors.append(error)
        return errors