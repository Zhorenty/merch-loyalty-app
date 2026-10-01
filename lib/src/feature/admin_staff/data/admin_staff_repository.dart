import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_data_source.dart';

abstract interface class AdminStaffRepository {
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

final class AdminStaffRepositoryImpl implements AdminStaffRepository {
  AdminStaffRepositoryImpl({required AdminStaffDataSource dataSource})
    : _dataSource = dataSource;

  final AdminStaffDataSource _dataSource;

  @override
  Future<List<StaffRow>> list() => _dataSource.list();

  @override
  Future<StaffRow> create({
    required String login,
    required String name,
    required String password,
    required String role,
    required String storeId,
  }) => _dataSource.create(
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
  }) => _dataSource.patch(
    id,
    login: login,
    name: name,
    password: password,
    role: role,
    storeId: storeId,
  );

  @override
  Future<void> delete(String id) => _dataSource.delete(id);
}
