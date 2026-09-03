import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/enroll/data/enroll_data_source.dart';

abstract interface class EnrollRepository {
  Future<EnrollResult> enroll({String? name, String? phone});
}

final class EnrollRepositoryImpl implements EnrollRepository {
  EnrollRepositoryImpl({required EnrollDataSource dataSource})
    : _dataSource = dataSource;

  final EnrollDataSource _dataSource;

  @override
  Future<EnrollResult> enroll({String? name, String? phone}) =>
      _dataSource.enroll(name: name, phone: phone);
}
