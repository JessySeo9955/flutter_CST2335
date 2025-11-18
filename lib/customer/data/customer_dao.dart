import 'package:floor/floor.dart';

import 'customer_model.dart';

/// Data access object (DAO) for performing CRUD operations on `Customer`
/// entities stored in the local database.
@dao
abstract class CustomerDao {

  /// Inserts a new `Customer` into the database.
  @Query('Select * From Customer')
  Future<List<Customer>> getAllCustomers();

  /// Returns a `Future` containing the ID of the newly inserted row.
  @insert
  Future<int> insertCustomer(Customer customer);

  /// Deletes a specific `Customer` from the database.
  @update
  Future<int> updateCustomer(Customer customer);

  @delete
  Future<int> deleteCustomer(Customer customer);
}