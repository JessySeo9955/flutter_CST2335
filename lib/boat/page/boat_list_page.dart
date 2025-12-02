import 'package:flutter/material.dart';
import 'package:flutter_cst2335/boat/page/boat_form_page.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../service/boat_service.dart';
import '../widget/boat_form_panel.dart';

/// This page shows a list of all boats
class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  _BoatListPageState createState() => _BoatListPageState();
}

/// The state that controls what the boat list page shows
class _BoatListPageState extends State<BoatListPage> {
  /// This helps us save and get boats from the database
  final BoatService _boatSvc = BoatService();
  /// This holds all the boats we want to show
  List<Boat> _boatList = [];
  /// This tells us if we are on a tablet or phone
  bool _tabletMode = false;
  /// This remembers which boat is selected
  int? _selectedIdx;

  /// This runs when the page first starts
  @override
  void initState() {
    super.initState();
    _refreshBoats();
  }

  /// This builds what you see on the screen
  @override
  Widget build(BuildContext context) {
    _tabletMode = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildAddButton(),
      body: _buildResponsiveLayout(),
    );
  }

  /// This builds the top bar with the title and info button
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

  /// Builds the button to add a new boat
  FloatingActionButton _buildAddButton() {
    return FloatingActionButton(
      onPressed: () => _navigateToNewBoatForm(),
      backgroundColor: Colors.blue[700],
      child: Icon(Icons.add),
    );
  }

  /// This opens the form to add a new boat
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

  /// This decides if we show tablet or phone layout
  Widget _buildResponsiveLayout() {
    return _tabletMode ? _buildTabletLayout() : _buildPhoneLayout();
  }

  /// This builds the tablet layout with list on left and form on right
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

  /// This builds the phone layout with one screen at a time
  Widget _buildPhoneLayout() {
    final showList = _selectedIdx == null && _boatList.isNotEmpty;
    return showList ? _createBoatList() : _createDetailView();
  }

  /// This shows the boat details on phone
  Widget _createDetailView() {
    return _selectedIdx == null
        ? Center(child: Text(AppLocalizations.of(context)!.translate("SelectBoat")!))
        : BoatFormPanel(
      key: ValueKey(_boatList[_selectedIdx!].id),
      boat: _boatList[_selectedIdx!],
      onSubmit: _handleWidgetSave,
    );
  }

  /// This creates a scrolling list of all boats
  Widget _createBoatList() {
    return ListView.builder(
      itemCount: _boatList.length,
      itemBuilder: (context, idx) => _buildBoatCard(_boatList[idx]),
    );
  }

  /// This builds one boat card to show in the list
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

  /// This gets all boats from the database and updates the screen
  Future<void> _refreshBoats() async {
    final boats = await _boatSvc.getBoats();
    setState(() => _boatList = boats);
  }

  /// This refreshes the list when you save from a new page
  void _handlePageSave() => _refreshBoats();

  /// This refreshes the list when you save from the widget
  void _handleWidgetSave() {
    setState(() => _selectedIdx = null);
    _refreshBoats();
  }

  /// This shows a message at the bottom of the screen
  void _displaySnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// This shows the help instructions popup
  void _displayInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate("InstructionsTitleBoat")!),
        content: Text(AppLocalizations.of(context)!.translate("InstructionsContentBoat")!),
      ),
    );
  }

  /// This handles what happens when you click a boat
  void _onBoatTap(Boat selectedBoat) {
    _tabletMode 
        ? _selectBoatInTabletMode(selectedBoat) 
        : _navigateToBoatForm(selectedBoat);
  }

  /// This selects a boat on tablet to show on the right side
  void _selectBoatInTabletMode(Boat boat) {
    setState(() => _selectedIdx = _boatList.indexOf(boat));
  }

  /// This opens the boat form on phone in a new screen
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

