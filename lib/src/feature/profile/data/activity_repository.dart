import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class ActivityRepository {
  Future<List<ActivityEntry>> list({required bool admin});
}

final class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<List<ActivityEntry>> list({required bool admin}) =>
      _api.listActivity(admin: admin);
}
