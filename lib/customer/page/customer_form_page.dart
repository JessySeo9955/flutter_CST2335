import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/customer_model.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;
  final VoidCallback? onSave;

  CustomerFormPage({this.customer, this.onSave});

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Form Page'));
  }

}