import 'package:flutter/material.dart';
import 'package:flutter_cst2335/boat/page/boat_form_page.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../service/boat_service.dart';
import '../widget/boat_form_panel.dart';

// Main page displaying boat list
class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  _BoatListPageState createState() => _BoatListPageState();
}

// State for boat list page
class _BoatListPageState extends State<BoatListPage> {
  final BoatService _boatSvc = BoatService();
  List<Boat> _boatList = [];
  bool _tabletMode = false;
  int? _selectedIdx;

  @override
  void initState() {
    super.initState();
    _refreshBoats();
  }

  @override
  Widget build(BuildContext context) {
    _tabletMode = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildAddButton(),
      body: _buildResponsiveLayout(),
    );
  }

  // Build app bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.translate('Boats')!),
      backgroundColor: Colors.blue[700],
      actions: [
        IconButton(
          onPressed: _displayInstructions,
          icon: Icon(Icons.info),
        ),
      ],
    );
  }

  // Build floating action button
  FloatingActionButton _buildAddButton() {
    return FloatingActionButton(
      onPressed: () => _navigateToNewBoatForm(),
      backgroundColor: Colors.blue[700],
      child: Icon(Icons.add),
    );
  }

  // Navigate to new boat form
  void _navigateToNewBoatForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BoatFormPage(
          onSave: () {
            _handlePageSave();
            _displaySnackBar(AppLocalizations.of(context)!.translate("ListUpdated")!);
          },
        ),
      ),
    );
  }

  // Build adaptive layout for different screen sizes
  Widget _buildResponsiveLayout() {
    return _tabletMode ? _buildTabletLayout() : _buildPhoneLayout();
  }

  // Tablet layout with split view
  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(flex: 1, child: _createBoatList()),
        Expanded(
          flex: 2,
          child: _selectedIdx == null
              ? Center(child: Text(AppLocalizations.of(context)!.translate("SelectBoat")!))
              : BoatFormPanel(
            key: ValueKey(_boatList[_selectedIdx!].id),
            boat: _boatList[_selectedIdx!],
            onSubmit: _handleWidgetSave,
          ),
        ),
      ],
    );
  }

  // Phone layout with single view
  Widget _buildPhoneLayout() {
    final showList = _selectedIdx == null && _boatList.isNotEmpty;
    return showList ? _createBoatList() : _createDetailView();
  }

  // Create detail view for phone mode
  Widget _createDetailView() {
    return _selectedIdx == null
        ? Center(child: Text(AppLocalizations.of(context)!.translate("SelectBoat")!))
        : BoatFormPanel(
      key: ValueKey(_boatList[_selectedIdx!].id),
      boat: _boatList[_selectedIdx!],
      onSubmit: _handleWidgetSave,
    );
  }

  // Create scrollable boat list
  Widget _createBoatList() {
    return ListView.builder(
      itemCount: _boatList.length,
      itemBuilder: (context, idx) => _buildBoatCard(_boatList[idx]),
    );
  }

  // Build individual boat card
  Widget _buildBoatCard(Boat boat) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.sailing, color: Colors.blue[700], size: 36),
        title: Text(
          '${boat.yearBuilt} ${boat.powerType} - \$${boat.price}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Length: ${boat.boatLength}'),
              Text(boat.address),
            ],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[700], size: 20),
        onTap: () => _onBoatTap(boat),
      ),
    );
  }

  // Refresh boat list from database
  Future<void> _refreshBoats() async {
    final boats = await _boatSvc.getBoats();
    setState(() => _boatList = boats);
  }

  // Handle save from page navigation
  void _handlePageSave() => _refreshBoats();

  // Handle save from widget
  void _handleWidgetSave() {
    setState(() => _selectedIdx = null);
    _refreshBoats();
  }

  // Display snackbar message
  void _displaySnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Show instructions dialog
  void _displayInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("InstructionsTitleBoat")!),
        content: Text(AppLocalizations.of(context)!.translate("InstructionsContentBoat")!),
      ),
    );
  }

  // Handle boat selection
  void _onBoatTap(Boat selectedBoat) {
    _tabletMode 
        ? _selectBoatInTabletMode(selectedBoat) 
        : _navigateToBoatForm(selectedBoat);
  }

  // Select boat in tablet mode
  void _selectBoatInTabletMode(Boat boat) {
    setState(() => _selectedIdx = _boatList.indexOf(boat));
  }

  // Navigate to boat form in phone mode
  void _navigateToBoatForm(Boat boat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BoatFormPage(
          boat: boat,
          onSave: _handlePageSave,
        ),
      ),
    );
  }
}

