import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cst2335/customer/page/customer_form_page.dart';

import '../data/customer_dao.dart';
import '../data/customer_database.dart';
import '../data/customer_model.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() {
    return _CustomerListPageState();
  }
}

class _CustomerListPageState extends State<CustomerListPage> {
  late CustomerDao _dao;
  List<Customer> _customers = [];
  bool _isTablet = false;
  int? _selectedIndex; // tablet use

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    final db = await $FloorCustomerDatabase
        .databaseBuilder('customer.db')
        .build();
    _dao = db.customerDao;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    _isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [IconButton(onPressed: () => _showInstructions(), icon: Icon(Icons.info))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CustomerFormPage(onSave: () {
                  _reload();
                  _showSnackBar('List updated');
                })
            )
        ),
        child: Icon(Icons.add),
      ),
      body: _isTablet
          ? Row(
              children: [
                Expanded(flex: 1, child: _buildList()),
                Expanded(
                  flex: 2,
                  child: Center(child: Text('Select a Customer')),
                ),
              ],
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _customers.length,
      itemBuilder: (_, i) {
        final customer = _customers[i];
        return ListTile(
          title: Text('${customer.firstName} ${customer.lastName}'),
          subtitle: Text(customer.address),
          onTap: () => _selectCustomer(customer)
        );
      },
    );
  }

  void _reload() async {
    _customers = await _dao.getAllCustomers();
    setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showInstructions() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Instructions'),
          content: Text('Tap + to add customers. \nTap a customer to view details.'),
        )
    );
  }

  void _selectCustomer(Customer customer) {
    if (_isTablet) {
      setState(() {
        _selectedIndex = _customers.indexOf(customer);
      });
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CustomerFormPage(customer: customer, onSave: _reload)));
    }
  }
}
