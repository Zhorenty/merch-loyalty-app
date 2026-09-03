import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AdminStaffDataSource {
  Future<List<StaffRow>> list();

  Future<StaffRow> create({
    required String login,
    required String name,
    required String password,
    required String role,
  });

  Future<StaffRow> patch(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    bool? active,
  });
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
  }) => _api.createStaff(
    login: login,
    name: name,
    password: password,
    role: role,
  );

  @override
  Future<StaffRow> patch(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    bool? active,
  }) => _api.patchStaff(
    id,
    login: login,
    name: name,
    password: password,
    role: role,
    active: active,
  );
}
