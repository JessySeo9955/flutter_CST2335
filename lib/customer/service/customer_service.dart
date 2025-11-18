import '../data/customer_dao.dart';
import '../data/customer_database.dart';
import '../data/customer_model.dart';
import '../preference/customer_prefs.dart';

class CustomerService {

// 1. Private constructor
  CustomerService._internal();

  // 2. Single static instance
  static final CustomerService _instance = CustomerService._internal();

  // 3. Public static accessor
  factory CustomerService() => _instance;

  late CustomerDao _dao;

  Future<void> init() async {
    final db = await $FloorCustomerDatabase
        .databaseBuilder("customer.db")
        .build();

    _dao = db.customerDao;
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