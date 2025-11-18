import '../data/customer_dao.dart';
import '../data/customer_database.dart';
import '../data/customer_model.dart';
import '../preference/customer_prefs.dart';

/// This service abstracts away the DAO and shared preferences logic,
/// providing a clean API for the UI layer.
class CustomerService {

  // 1. Private constructor
  /// Internal private constructor used to implement the singleton pattern.
  CustomerService._internal();

  // 2. Single static instance
  /// The single shared instance of [CustomerService].
  static final CustomerService _instance = CustomerService._internal();

  // 3. Public static accessor
  /// Provides global access to the singleton service instance.
  factory CustomerService() => _instance;

  /// Data access object used for database operations on `Customer` entities.
  late CustomerDao _dao;

  /// Initializes the Floor database and prepares the DAO for use.
  Future<void> init() async {
    final db = await $FloorCustomerDatabase
        .databaseBuilder("customer.db")
        .build();

    _dao = db.customerDao;
  }

  /// Validates that all required fields in a `Customer` object are non-empty.
  bool validateFields(Customer customer) {
    return customer.firstName.isNotEmpty &&
        customer.lastName.isNotEmpty &&
        customer.address.isNotEmpty &&
        customer.birthdate.isNotEmpty &&
        customer.licenseNo.isNotEmpty;
  }

  /// Saves a new `Customer` to the database and stores the same data in
  /// encrypted shared preferences as the "last used customer".
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

  /// Updates an existing `Customer` in the database.
  Future<int> updateCustomer(Customer customer) async {
    return await _dao.updateCustomer(customer);
  }

  /// Deletes a specific `Customer` from the database.
  Future<void> deleteCustomer(Customer customer) async {
    await _dao.deleteCustomer(customer);
  }

  /// Retrieves all saved customers from the database.
  Future<List<Customer>> getCustomers() {
    return _dao.getAllCustomers();
  }

  /// Loads the most recently saved customer from encrypted preferences.
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