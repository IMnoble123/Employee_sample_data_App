import 'dart:developer';

import 'package:employee_data_app/features/employee/entity/employee_data.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EmployeeStorageService {
  late final Box<EmployeeModel> _employeeBox;
  Rx<List<EmployeeModel>> employeeList = Rx([]);

  Future<void> openEmployeeDB() async {
    _employeeBox = await Hive.openBox<EmployeeModel>('employee_data');
    employeeList.value = _employeeBox.values.toList();
    _employeeBox.listenable().addListener(() {
      employeeList.value = _employeeBox.values.toList();
      log(employeeList.value.toString());
    });
  }

  Future<void> addEmployee(EmployeeModel model) async {
    await _employeeBox.add(model);
  }

  Future<void> updateEmployee(int index, EmployeeModel model) async {
    await _employeeBox.putAt(index, model);
  }

  Future<void> deleteEmployee(int index) async {
    await _employeeBox.deleteAt(index);
  }
}

// Rx<RxList<EmployeeModel>> employeeList = RxList<EmployeeModel>([]).obs;

