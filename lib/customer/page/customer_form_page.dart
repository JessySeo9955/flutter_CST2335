import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/customer_model.dart';
import '../widget/customer_form_panel.dart';

class CustomerFormPage extends StatelessWidget  {
  final Customer? customer;
  final VoidCallback onSave;

  const CustomerFormPage({
    Key? key,
    this.customer,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer == null ? "Add Customer" : "Edit Customer"),

      ),
      body: CustomerFormPanel(
        customer: customer,
        onSubmit: () async {
          onSave();
          Navigator.pop(context); // PHONE MODE ONLY
        },
      ),
    );
  }
}
