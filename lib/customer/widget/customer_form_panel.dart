import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    final t = AppLocalizations.of(context)!;

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
      ).showSnackBar(SnackBar(content: Text(t.translate("PleaseFillAllFields")!),));
      return;
    }

    if (_editing) {
      message = t.translate("Updated")!;
      await _service.updateCustomer(customer);
    } else {
      message = t.translate("Saved")!;
      await _service.saveCustomer(customer);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

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
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.translate("DeleteTitle")!),
        content: Text(t.translate("DeleteConfirm")!),
        actions: [
          TextButton(
            child: Text(t.translate("Cancel")!),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(t.translate("Delete")!),
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
    final t = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _editing
              ? t.translate("EditCustomerForm")!
              : t.translate("NewCustomer")!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!_editing)
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: t.translate("CopyPreviousCustomer")!,
            onPressed: _loadPreviousCustomer,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
                  decoration: InputDecoration(
                    labelText: t.translate("FirstName")!,
                  ),
                ),
                TextField(
                  controller: _lastController,
                  decoration: InputDecoration(
                    labelText: t.translate("LastName")!,
                  ),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: t.translate("Address")!,
                  ),
                ),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: t.translate("DateOfBirth")!,
                  ),
                ),
                TextField(
                  controller: _licenseController,
                  decoration: InputDecoration(
                    labelText: t.translate("LicenceNumber")!, // UK spelling: licence
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(
                    _editing
                        ? t.translate("Update")!
                        : t.translate("Submit")!,
                  ),
                ),
                if (_editing)
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(t.translate("Delete")!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
