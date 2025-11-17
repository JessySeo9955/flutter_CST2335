import 'package:floor/floor.dart';

@entity
class Customer {

  @primaryKey
  final int? id;

  final String firstName;
  final String lastName;
  final String address;
  final String birthdate;
  final String licenseNo;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthdate,
    required this.licenseNo
  });
}