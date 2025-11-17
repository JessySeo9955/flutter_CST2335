import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/customer_model.dart';
import '../service/customer_service.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;
  final VoidCallback? onSave;

  CustomerFormPage({this.customer, this.onSave});

  @override
  _CustomerFormPageState createState() {
    return _CustomerFormPageState();
  }
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  late CustomerService _service;

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
    _service = await CustomerService.create();
    setState(() {});
  }

  void _save() async {
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
      await _service.updateCustomer(customer);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Customer updated")));
    } else {
      await _service.saveCustomer(customer);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Customer added")));
    }

    widget.onSave?.call();
    Navigator.pop(context);
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
              widget.onSave?.call();

              Navigator.pop(dialogContext);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Edit Customer' : 'Add Customer'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              Customer? customer = await _service.loadLastCustomer();
              if (customer != null) {
                _firstController.text = customer.firstName;
                _lastController.text = customer.lastName;
                _addressController.text = customer.address;
                _dobController.text = customer.birthdate;
                _licenseController.text = customer.licenseNo;
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Delete"),
              ),
          ],
        ),
      ),
    );
  }
}
