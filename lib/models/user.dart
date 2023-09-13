// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:admin_ecommerce_app/extensions/string_extension.dart';

class UserModel {
  final String id;
  final String email;
  final UserType type;

  UserModel({
    required this.id,
    required this.email,
    required this.type,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    switch (map['type'].toString().toUserType()) {
      case UserType.admin:
        return Admin.fromMap(map);
      case UserType.employee:
        return Employee.fromMap(map);
      default:
        return UserModel(
          id: map['id'] as String,
          email: map['email'] as String,
          type: UserType.employee,
        );
    }
  }
}

class Employee extends UserModel {
  final String name;
  final DateTime dateOfBirth;
  final double salary;
  final WorkingStatus workingStatus;
  Employee({
    required super.id,
    required super.email,
    required super.type,
    required this.name,
    required this.dateOfBirth,
    required this.salary,
    required this.workingStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'type': type.name,
      'name': name,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'salary': salary,
      'workingStatus': workingStatus.name,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as String,
      email: map['email'] as String,
      type: (map['type'] as String).toUserType() ?? UserType.employee,
      name: map['name'] as String,
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      salary: map['salary'] as double,
      workingStatus: (map['workingStatus'] as String).toWorkingStatus(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Admin extends UserModel {
  Admin({
    required super.id,
    required super.email,
    required super.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'type': type.name,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'] as String,
      email: map['email'] as String,
      type: (map['type'] as String).toUserType() ?? UserType.admin,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum WorkingStatus {
  working,
  resigned,
  retired,
}

enum UserType {
  admin,
  employee,
}
