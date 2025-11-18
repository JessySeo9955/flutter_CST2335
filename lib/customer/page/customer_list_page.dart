import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cst2335/customer/page/customer_form_page.dart';

import '../data/customer_model.dart';
import '../service/customer_service.dart';
import '../widget/customer_form_panel.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() {
    return _CustomerListPageState();
  }
}

class _CustomerListPageState extends State<CustomerListPage> {
  final _service = CustomerService();
  List<Customer> _customers = [];
  bool _isTablet = false;
  int? _selectedIndex; // tablet use

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  Future<void> _initDB() async {
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    _isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            onPressed: () => _showInstructions(),
            icon: Icon(Icons.info),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerFormPage(
              onSave: () {
                _saveCallbackFromPage();
                _showSnackBar('List updated');
              },
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: _isTablet
          ? Row(
              children: [
                Expanded(flex: 1, child: _buildList()),
                Expanded(
                  flex: 2,
                  child: _selectedIndex == null
                      ? Center(child: Text("Select a customer"))
                      : CustomerFormPanel(
                          key: ValueKey(_customers[_selectedIndex!].id),
                          customer: _customers[_selectedIndex!],
                          onSubmit: _saveCallbackFromWidget,
                        ),
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
          onTap: () => _selectCustomer(customer),
        );
      },
    );
  }

  void _saveCallbackFromPage() {
    _reload();
  }

  void _saveCallbackFromWidget() {
    _reload();
    _selectedIndex = null;
  }

  void _reload() async {
    _customers = await _service.getCustomers();
    if (mounted) setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Instructions'),
        content: Text(
          'Tap + to add customers. \nTap a customer to view details.',
        ),
      ),
    );
  }

  void _selectCustomer(Customer customer) {
    if (_isTablet) {
      setState(() {
        _selectedIndex = _customers.indexOf(customer);
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerFormPage(
            customer: customer,
            onSave: () {
              _saveCallbackFromPage();
            },
          ),
        ),
      );
    }
  }
}
