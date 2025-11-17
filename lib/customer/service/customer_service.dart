import '../data/customer_dao.dart';
import '../data/customer_database.dart';
import '../data/customer_model.dart';
import '../preference/customer_prefs.dart';

class CustomerService {

  late CustomerDao _dao;

  CustomerService._();

  static Future<CustomerService> create() async {
    final service = CustomerService._();

    // Open DB + get DAO
    final db = await $FloorCustomerDatabase
        .databaseBuilder("customer.db")
        .build();
    service._dao = db.customerDao;

    return service;
  }

  bool validateFields(Customer customer) {
    return customer.firstName.isNotEmpty &&
        customer.lastName.isNotEmpty &&
        customer.address.isNotEmpty &&
        customer.birthdate.isNotEmpty &&
        customer.licenseNo.isNotEmpty;
  }

  Future<void> saveCustomer(Customer customer) async {
    await _dao.insertCustomer(customer);

    await CustomerPrefs.saveLastCustomer({
      "firstName": customer.firstName,
      "lastName": customer.lastName,
      "address": customer.address,
      "birthdate": customer.birthdate,
      "licenseNo": customer.licenseNo,
    });
  }

  Future<int> updateCustomer(Customer customer) async {
    return await _dao.updateCustomer(customer);
  }

  Future<void> deleteCustomer(Customer customer) async {
    await _dao.deleteCustomer(customer);
  }

  Future<List<Customer>> getCustomers() {
    return _dao.getAllCustomers();
  }

  Future<Customer?> loadLastCustomer() async {
    Map<String, String>? saved = await CustomerPrefs.loadLastCustomer();
    if (saved == null) return null;
      return  Customer(
        firstName: saved['firstName'] ?? "",
        lastName: saved['lastName'] ?? "",
        address: saved['address'] ?? "",
        birthdate: saved['birthdate'] ?? "",
        licenseNo: saved['licenseNo'] ?? "",
      );
  }

}