import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../widget/boat_form_panel.dart';

// Page for displaying boat form
class BoatFormPage extends StatelessWidget {
  /// The boat we want to edit (null if adding new boat)
  final Boat? boat;
  
  /// Function to call when we save the boat
  final VoidCallback onSave;

  /// Creates the boat form page
  const BoatFormPage({super.key, this.boat, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BoatFormPanel(
        boat: boat,
        onSubmit: () => _handleSubmit(context),
      ),
    );
  }

  /// Creates the top bar of the screen
  /// Shows "Add Boat" if new, "Edit Boat" if editing
  AppBar _buildAppBar(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final title = boat == null 
        ? localization.translate("AddBoat")! 
        : localization.translate("EditBoat")!;
    
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue[700],
    );
  }

  /// What happens when you save the form
  /// It saves the boat and goes back to the previous screen
  void _handleSubmit(BuildContext context) {
    onSave();
    Navigator.pop(context);
  }
}

