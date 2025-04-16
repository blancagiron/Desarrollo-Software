import 'base.dart';

class FilterChain {
  List<Filter> filters = [];
  dynamic target;

  FilterChain addFilter(Filter filterObj) {
    filters.add(filterObj);
    return this;
  }

  void setTarget(dynamic target) {
    this.target = target;
  }

  List<String> execute(Map<String, String> request) {
    List<String> errors = [];
    for (var filterObj in filters) {
      String? error = filterObj.execute(request);
      if (error != null) {
        errors.add(error);
      }
    }
    return errors;
  }
}