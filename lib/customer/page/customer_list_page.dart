import 'package:flutter/material.dart';
import 'package:flutter_cst2335/customer/page/customer_form_page.dart';

import '../data/customer_model.dart';
import '../service/customer_service.dart';
import '../widget/customer_form_panel.dart';

/// Displays a list of customers and allows adding or editing customers.
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  _CustomerListPageState createState() {
    return _CustomerListPageState();
  }
}

/// State class for [CustomerListPage], responsible for loading customers,
/// handling selection, and managing phone/tablet UI modes.
class _CustomerListPageState extends State<CustomerListPage> {
  /// Customer service responsible for database operations.
  final _service = CustomerService();
  /// List of all loaded customers.
  List<Customer> _customers = [];
  /// Indicates if the layout should switch to tablet mode.
  bool _isTablet = false;
  /// Selected customer index when using tablet split-view mode.
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
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
      body: _reactiveLayout(),
    );
  }

  Widget _reactiveLayout() {
    if (_isTablet) {
      return Row(
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
      );
    } else {

      if (_selectedIndex == null && _customers.isNotEmpty) {
        return _buildList();       // show list first
      } else {
        return _buildDetailPanel();    // show details after selection
      }
    }
  }

  Widget _buildDetailPanel() {
    return _selectedIndex == null
        ? Center(child: Text("Select a customer"))
        : CustomerFormPanel(
      key: ValueKey(_customers[_selectedIndex!].id),
      customer: _customers[_selectedIndex!],
      onSubmit: _saveCallbackFromWidget,
    );

  }

  /// Builds the scrollable list of customers.
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

  /// Called when the form page finishes saving a customer (phone mode).
  void _saveCallbackFromPage() {
    _reload();
  }

  /// Called when the customer form panel saves data (tablet mode).
  void _saveCallbackFromWidget() {
    _reload();
    _selectedIndex = null;
  }

  /// Reloads customer data from the service and updates the UI.
  Future<void> _reload() async {
    final data = await _service.getCustomers();  // async DB work

    setState(() {
      _customers = data;  // sync state update
    });
  }

  /// Shows a Snackbar message at the bottom of the screen.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Shows an instruction dialog explaining how to use the page.
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

  /// Handles customer selection based on the device layout.
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
