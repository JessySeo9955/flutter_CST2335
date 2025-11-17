import 'package:floor/floor.dart';

import 'customer_model.dart';


@dao
abstract class CustomerDao {

  @Query('Select * From Customer')
  Future<List<Customer>> getAllCustomers();
  
  @insert
  Future<int> insertCustomer(Customer customer);

  @update
  Future<int> updateCustomer(Customer customer);

  @delete
  Future<int> deleteCustomer(Customer customer);
}