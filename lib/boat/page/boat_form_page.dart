import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';

import '../data/boat_model.dart';
import '../widget/boat_form_panel.dart';

/// A page that displays a form for creating or editing a `Boat`.
class BoatFormPage extends StatelessWidget {
  /// The boat to edit.
  final Boat? boat;
  /// Callback triggered after the form is successfully saved.
  final VoidCallback onSave;

  /// Creates a page containing a form to add or edit a boat.
  const BoatFormPage({
    super.key,
    this.boat,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          boat == null
              ? t.translate("AddBoat")!
              : t.translate("EditBoat")!,
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: BoatFormPanel(
        boat: boat,
        onSubmit: () async {
          onSave();
          Navigator.pop(context);
        },
      ),
    );
  }
}

