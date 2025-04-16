import 'base.dart';
import 'filter_chain.dart';

class FilterManager {
  FilterChain filterChain;
  List<String> emails_used = [];

  FilterManager(dynamic target) : filterChain = FilterChain() {
    filterChain.setTarget(target);
  }

  void addFilter(Filter filterObj) {
    filterChain.addFilter(filterObj);
  }

  Map<String, dynamic> processRequest(Map<String, String> request) {
    List<String> errors = filterChain.execute(request);
    if (errors.isNotEmpty) {
      return {'success': false, 'errors': errors};
    }
    if (emails_used.contains(request['email'])) {
      return {'success': false, 'errors': ['Este correo ya está en uso']};
    } else {
      emails_used.add(request['email'] as String);
      return filterChain.target.process(request);
    }
  }
}
