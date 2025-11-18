import 'package:flutter/material.dart';

import '../data/customer_model.dart';
import '../service/customer_service.dart';

/// A form panel widget used for creating or editing a `Customer`
class CustomerFormPanel extends StatefulWidget {
  /// The customer being edited.
  final Customer? customer;
  /// Callback executed when the form is submitted successfully.
  final VoidCallback onSubmit;

  /// Creates a form panel for adding or editing a customer.
  const CustomerFormPanel({super.key, this.customer, required this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    return _CustomerFormPanelState();
  }
}

/// State class for [CustomerFormPanel], responsible for handling input
/// controllers, editing mode, validation, saving, deleting, and UI updates.
class _CustomerFormPanelState extends State<CustomerFormPanel> {

  /// Service layer used for database and preference operations.
  final _service = CustomerService();

  /// Controller for the customer's first name field.
  late TextEditingController _firstController;

  /// Controller for the customer's last name field.
  late TextEditingController _lastController;

  /// Controller for the customer's address field.
  late TextEditingController _addressController;

  /// Controller for the customer's date of birth field.
  late TextEditingController _dobController;

  /// Controller for the customer's license number field.
  late TextEditingController _licenseController;

  /// Indicates whether the panel is editing an existing customer.
  bool _editing = false;




  @override
  void initState() {
    super.initState();

    _editing = widget.customer != null;
    _firstController = TextEditingController(text: widget.customer?.firstName);
    _lastController = TextEditingController(text: widget.customer?.lastName);
    _addressController = TextEditingController(text: widget.customer?.address);
    _dobController = TextEditingController(text: widget.customer?.birthdate);
    _licenseController = TextEditingController(text: widget.customer?.licenseNo);
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  /// Validates and saves the customer.
  /// - If editing: updates the existing customer.
  /// - If adding: saves a new customer.
  void _save() async {
    String message = '';
    final customer = Customer(
      id: _editing ? widget.customer!.id : null, // IMPORTANT
      firstName: _firstController.text,
      lastName: _lastController.text,
      address: _addressController.text,
      birthdate: _dobController.text,
      licenseNo: _licenseController.text,
    );

    if (!_service.validateFields(customer)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text('Please fill all fields')));
      return;
    }

    if (_editing) {
      message = 'Updated';
      await _service.updateCustomer(customer);
    } else {
      message = 'Saved';
      await _service.saveCustomer(customer);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    _close();
  }

  /// Loads the last saved customer from preferences and fills the input fields.
  void _loadPreviousCustomer() async {
    Customer? customer = await _service.loadLastCustomer();
    if (customer != null) {
      _firstController.text = customer.firstName;
      _lastController.text = customer.lastName;
      _addressController.text = customer.address;
      _dobController.text = customer.birthdate;
      _licenseController.text = customer.licenseNo;
    }
  }

  /// Executes the `onSubmit` callback to notify parent widgets.
  void _close() async {
    widget.onSubmit();
  }

  /// Shows a confirmation dialog and deletes the customer if confirmed.
  void _delete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete?'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            child: Text('cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              await _service.deleteCustomer(widget.customer!);
              Navigator.pop(dialogContext);
              _close();
            },
          ),
        ],
      ),
    );
  }

  /// Builds the header containing the page title and copy button.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _editing ? "Edit Customer" : "New Customer",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!_editing)
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: "Copy previous customer",
            onPressed: _loadPreviousCustomer,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),

                TextField(
                  controller: _firstController,
                  decoration: InputDecoration(labelText: "First Name"),
                ),
                TextField(
                  controller: _lastController,
                  decoration: InputDecoration(labelText: "Last Name"),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: "Date of Birth"),
                ),
                TextField(
                  controller: _licenseController,
                  decoration: InputDecoration(labelText: "License #"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(_editing ? "Update" : "Submit"),
                ),
                if (_editing)
                  ElevatedButton(
                    onPressed: _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("Delete"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
