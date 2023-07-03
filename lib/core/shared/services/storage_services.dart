import 'package:employee_data_app/features/employee/entity/employee_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends ChangeNotifier {
  late final Box<EmployeeModel> _employeeBox;
  // ValueNotifier<List<EmployeeModel>> employeeList = ValueNotifier([]);

  Future<List<EmployeeModel>> openEmployeeDB() async {
    _employeeBox = await Hive.openBox<EmployeeModel>('employee_data');
    return _employeeBox.values.toList();
  }

  Future<List<EmployeeModel>> addEmployee(EmployeeModel model) async {
    await _employeeBox.add(model);
    return _employeeBox.values.toList();
  }

  Future<List<EmployeeModel>> updateEmployee(int index, EmployeeModel model) async {
    await _employeeBox.putAt(index, model);
    return _employeeBox.values.toList();
  }

  Future<List<EmployeeModel>> deleteEmployee(int index) async {
    await _employeeBox.deleteAt(index);
    return _employeeBox.values.toList();
  }
}
