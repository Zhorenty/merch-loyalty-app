import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/scan/data/scan_data_source.dart';

abstract interface class ScanRepository {
  Future<LookupCustomer> lookup(String barcode);
}

final class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl({required ScanDataSource dataSource})
    : _dataSource = dataSource;

  final ScanDataSource _dataSource;

  @override
  Future<LookupCustomer> lookup(String barcode) => _dataSource.lookup(barcode);
}
