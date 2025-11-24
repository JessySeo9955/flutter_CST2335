import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../data/customer_model.dart';
import '../widget/customer_form_panel.dart';

/// A page that displays a form for creating or editing a `Customer`.
class CustomerFormPage extends StatelessWidget  {
  /// The customer to edit.
  final Customer? customer;
  /// Callback triggered after the form is successfully saved.
  final VoidCallback onSave;

  /// Creates a page containing a form to add or edit a customer.
  const CustomerFormPage({
    super.key,
    this.customer,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {

    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          customer == null
              ? t.translate("AddCustomer")!
              : t.translate("EditCustomer")!,
        ),
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
