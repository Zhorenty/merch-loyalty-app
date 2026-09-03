import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class ScanDataSource {
  Future<LookupCustomer> lookup(String barcode);
}

final class ScanDataSourceNetwork implements ScanDataSource {
  ScanDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<LookupCustomer> lookup(String barcode) => _api.lookup(barcode);
}
