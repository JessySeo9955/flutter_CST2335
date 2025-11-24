import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../widget/boat_form_panel.dart';

// Page for displaying boat form
class BoatFormPage extends StatelessWidget {
  final Boat? boat;
  final VoidCallback onSave;

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

  // Build app bar with dynamic title
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

  // Handle form submission
  void _handleSubmit(BuildContext context) {
    onSave();
    Navigator.pop(context);
  }
}

