import 'package:flutter/material.dart';

import '../data/customer_model.dart';
import '../service/customer_service.dart';

class CustomerFormPanel extends StatefulWidget {
  final Customer? customer;
  final VoidCallback onSubmit;

  const CustomerFormPanel({Key? key, this.customer, required this.onSubmit})
    : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomerFormPanelState();
  }
}

class _CustomerFormPanelState extends State<CustomerFormPanel> {
  final _service = CustomerService();

  late TextEditingController _firstController;
  late TextEditingController _lastController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _licenseController;

  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _init();

    _editing = widget.customer != null;
    _firstController = TextEditingController(
      text: widget.customer?.firstName ?? "",
    );
    _lastController = TextEditingController(
      text: widget.customer?.lastName ?? "",
    );
    _addressController = TextEditingController(
      text: widget.customer?.address ?? "",
    );
    _dobController = TextEditingController(
      text: widget.customer?.birthdate ?? "",
    );
    _licenseController = TextEditingController(
      text: widget.customer?.licenseNo ?? "",
    );
  }

  Future<void> _init() async {
    setState(() {});
  }

  void _save() async {
    String message = '';
    final customer = Customer(
      id: _editing ? widget.customer!.id : null, // IMPORTANT
      firstName: _firstController.text ?? "",
      lastName: _lastController.text ?? "",
      address: _addressController.text ?? "",
      birthdate: _dobController.text ?? "",
      licenseNo: _licenseController.text ?? "",
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

  void _close() async {
    widget.onSubmit();
  }

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
