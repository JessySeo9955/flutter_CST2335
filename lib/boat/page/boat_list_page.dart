import 'package:flutter/material.dart';
import 'package:flutter_cst2335/boat/page/boat_form_page.dart';
import '../../AppLocalizations.dart';

import '../data/boat_model.dart';
import '../service/boat_service.dart';
import '../widget/boat_form_panel.dart';

/// Displays a list of boats and allows adding or editing boats.
class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  _BoatListPageState createState() {
    return _BoatListPageState();
  }
}

/// State class for [BoatListPage], responsible for loading boats,
/// handling selection, and managing phone/tablet UI modes.
class _BoatListPageState extends State<BoatListPage> {
  /// Boat service responsible for database operations.
  final _service = BoatService();
  /// List of all loaded boats.
  List<Boat> _boats = [];
  /// Indicates if the layout should switch to tablet mode.
  bool _isTablet = false;
  /// Selected boat index when using tablet split-view mode.
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
        title: Text(AppLocalizations.of(context)!.translate('Boats')!),
        backgroundColor: Colors.blue[700],
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
            builder: (_) => BoatFormPage(
              onSave: () {
                _saveCallbackFromPage();
                _showSnackBar(AppLocalizations.of(context)!.translate("ListUpdated")!);
              },
            ),
          ),
        ),
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
      ),
      body: _reactiveLayout(),
    );
  }

  /// Displays reactive panels based on screen size.
  Widget _reactiveLayout() {
    if (_isTablet) {
      return Row(
        children: [
          Expanded(flex: 1, child: _buildList()),
          Expanded(
            flex: 2,
            child: _selectedIndex == null
                ? Center(child: Text(AppLocalizations.of(context)!.translate("SelectBoat")!))
                : BoatFormPanel(
              key: ValueKey(_boats[_selectedIndex!].id),
              boat: _boats[_selectedIndex!],
              onSubmit: _saveCallbackFromWidget,
            ),
          ),
        ],
      );
    } else {
      if (_selectedIndex == null && _boats.isNotEmpty) {
        return _buildList();
      } else {
        return _buildDetailPanel();
      }
    }
  }

  /// Displays detail Panel.
  Widget _buildDetailPanel() {
    return _selectedIndex == null
        ? Center(child: Text(AppLocalizations.of(context)!.translate("SelectBoat")!))
        : BoatFormPanel(
      key: ValueKey(_boats[_selectedIndex!].id),
      boat: _boats[_selectedIndex!],
      onSubmit: _saveCallbackFromWidget,
    );
  }

  /// Builds the scrollable list of boats.
  Widget _buildList() {
    return ListView.builder(
      itemCount: _boats.length,
      itemBuilder: (_, i) {
        final boat = _boats[i];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.sailing, color: Colors.blue[700],size: 36),
            title: Text(
              '${boat.yearBuilt} - ${boat.powerType}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(boat.address),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[700],size: 24),
            onTap: () => _selectBoat(boat),
          ),
        );
      },
    );
  }

  /// Called when the form page finishes saving a boat (phone mode).
  void _saveCallbackFromPage() {
    _reload();
  }

  /// Called when the boat form panel saves data (tablet mode).
  void _saveCallbackFromWidget() {
    _reload();
    _selectedIndex = null;
  }

  /// Reloads boat data from the service and updates the UI.
  Future<void> _reload() async {
    final data = await _service.getBoats();

    setState(() {
      _boats = data;
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
        title: Text(AppLocalizations.of(context)!.translate("InstructionsTitleBoat")!),
        content: Text(AppLocalizations.of(context)!.translate("InstructionsContentBoat")!),
      ),
    );
  }

  /// Handles boat selection based on the device layout.
  void _selectBoat(Boat boat) {
    if (_isTablet) {
      setState(() {
        _selectedIndex = _boats.indexOf(boat);
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BoatFormPage(
            boat: boat,
            onSave: () {
              _saveCallbackFromPage();
            },
          ),
        ),
      );
    }
  }
}

