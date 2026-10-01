import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AdminStaffDataSource {
  Future<List<StaffRow>> list();

  Future<StaffRow> create({
    required String login,
    required String name,
    required String password,
    required String role,
    required String storeId,
  });

  Future<StaffRow> patch(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    String? storeId,
  });

  Future<void> delete(String id);
}

final class AdminStaffDataSourceNetwork implements AdminStaffDataSource {
  AdminStaffDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<List<StaffRow>> list() => _api.listStaff();

  @override
  Future<StaffRow> create({
    required String login,
    required String name,
    required String password,
    required String role,
    required String storeId,
  }) => _api.createStaff(
    login: login,
    name: name,
    password: password,
    role: role,
    storeId: storeId,
  );

  @override
  Future<StaffRow> patch(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    String? storeId,
  }) => _api.patchStaff(
    id,
    login: login,
    name: name,
    password: password,
    role: role,
    storeId: storeId,
  );

  @override
  Future<void> delete(String id) => _api.deleteStaff(id);
}
