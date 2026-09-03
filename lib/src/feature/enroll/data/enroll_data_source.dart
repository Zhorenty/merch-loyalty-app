import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class EnrollDataSource {
  Future<EnrollResult> enroll({String? name, String? phone});
}

final class EnrollDataSourceNetwork implements EnrollDataSource {
  EnrollDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<EnrollResult> enroll({String? name, String? phone}) =>
      _api.enroll(name: name, phone: phone);
}
