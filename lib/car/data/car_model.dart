import 'package:floor/floor.dart';

/// Entity model representing a Car
@Entity(tableName: 'Car')
class Car {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int year;
  final String make;
  final String model;
  final double price;
  final double kilometers;

  Car({
    this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.price,
    required this.kilometers,
  });
}
