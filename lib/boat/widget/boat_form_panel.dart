import 'package:flutter/material.dart';

import '../../AppLocalizations.dart';

import '../data/boat_model.dart';
import '../service/boat_service.dart';

/// A form panel widget used for creating or editing a `Boat`
class BoatFormPanel extends StatefulWidget {
  /// The boat being edited.
  final Boat? boat;
  /// Callback executed when the form is submitted successfully.
  final VoidCallback onSubmit;

  /// Creates a form panel for adding or editing a boat.
  const BoatFormPanel({super.key, this.boat, required this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    return _BoatFormPanelState();
  }
}

/// State class for [BoatFormPanel], responsible for handling input
/// controllers, editing mode, validation, saving, deleting, and UI updates.
class _BoatFormPanelState extends State<BoatFormPanel> {

  /// Service layer used for database and preference operations.
  final _service = BoatService();

  /// Controller for the year built field.
  late TextEditingController _yearController;

  /// Controller for the boat length field.
  late TextEditingController _lengthController;

  /// Controller for the power type field.
  late TextEditingController _powerController;

  /// Controller for the price field.
  late TextEditingController _priceController;

  /// Controller for the address field.
  late TextEditingController _addressController;

  /// Indicates whether the panel is editing an existing boat.
  bool _editing = false;

  @override
  void initState() {
    super.initState();

    _editing = widget.boat != null;
    _yearController = TextEditingController(text: widget.boat?.yearBuilt);
    _lengthController = TextEditingController(text: widget.boat?.boatLength);
    _powerController = TextEditingController(text: widget.boat?.powerType);
    _priceController = TextEditingController(text: widget.boat?.price);
    _addressController = TextEditingController(text: widget.boat?.address);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _lengthController.dispose();
    _powerController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Validates and saves the boat.
  /// - If editing: updates the existing boat.
  /// - If adding: saves a new boat.
  void _save() async {
    final t = AppLocalizations.of(context)!;

    String message = '';
    final boat = Boat(
      id: _editing ? widget.boat!.id : null,
      yearBuilt: _yearController.text,
      boatLength: _lengthController.text,
      powerType: _powerController.text,
      price: _priceController.text,
      address: _addressController.text,
    );

    if (!_service.validateFields(boat)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate("PleaseFillAllFields")!),));
      return;
    }

    if (_editing) {
      message = t.translate("Updated")!;
      await _service.updateBoat(boat);
    } else {
      message = t.translate("Saved")!;
      await _service.saveBoat(boat);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    _close();
  }

  /// Loads the last saved boat from preferences and fills the input fields.
  void _loadPreviousBoat() async {
    Boat? boat = await _service.loadLastBoat();
    if (boat != null) {
      _yearController.text = boat.yearBuilt;
      _lengthController.text = boat.boatLength;
      _powerController.text = boat.powerType;
      _priceController.text = boat.price;
      _addressController.text = boat.address;
    }
  }

  /// Executes the `onSubmit` callback to notify parent widgets.
  void _close() async {
    widget.onSubmit();
  }

  /// Shows a confirmation dialog and deletes the boat if confirmed.
  void _delete() {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.translate("DeleteTitleBoat")!),
        content: Text(t.translate("DeleteConfirmBoat")!),
        actions: [
          TextButton(
            child: Text(t.translate("Cancel")!),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(t.translate("Delete")!),
            onPressed: () async {
              await _service.deleteBoat(widget.boat!);
              Navigator.pop(dialogContext);
              _close();
            },
          ),
        ],
      ),
    );
  }

  /// Builds the header containing the page title and copy button.
  Widget _buildHeader() {
    final t = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _editing
              ? t.translate("EditBoatForm")!
              : t.translate("NewBoat")!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!_editing)
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: t.translate("CopyPreviousBoat")!,
            onPressed: _loadPreviousBoat,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                TextField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: t.translate("YearBuilt")!,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lengthController,
                  decoration: InputDecoration(
                    labelText: t.translate("BoatLength")!,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _powerController,
                  decoration: InputDecoration(
                    labelText: t.translate("PowerType")!,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: t.translate("Price")!,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: t.translate("Address")!,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _editing
                        ? t.translate("Update")!
                        : t.translate("Submit")!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                if (_editing) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _delete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            t.translate("Delete")!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

