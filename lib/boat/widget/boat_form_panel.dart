import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../service/boat_service.dart';

/// This is the form where you add or edit boat information
class BoatFormPanel extends StatefulWidget {
  /// The boat we are editing, or null if adding a new boat
  final Boat? boat;
  /// The function to call when we finish saving
  final VoidCallback onSubmit;

  const BoatFormPanel({super.key, this.boat, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _BoatFormPanelState();
}

/// The state that controls the boat form
class _BoatFormPanelState extends State<BoatFormPanel> {
  /// This helps us save and load boats
  final BoatService _boatService = BoatService();

  /// This controls what you type in the address box
  late TextEditingController _addressCtrl;
  /// This controls what you type in the price box
  late TextEditingController _priceCtrl;
  /// This controls what you type in the power type box
  late TextEditingController _powerCtrl;
  /// This controls what you type in the length box
  late TextEditingController _lengthCtrl;
  /// This controls what you type in the year box
  late TextEditingController _yearCtrl;

  /// This tells us if we are editing or adding a new boat
  bool _isEditMode = false;

  /// This holds the error message for address
  String? _addressErr;
  /// This holds the error message for price
  String? _priceErr;
  /// This holds the error message for power type
  String? _powerErr;
  /// This holds the error message for length
  String? _lengthErr;
  /// This holds the error message for year
  String? _yearErr;

  /// This runs when the form first starts
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.boat != null;
    _addressCtrl = TextEditingController(text: widget.boat?.address);
    _priceCtrl = TextEditingController(text: widget.boat?.price);
    _powerCtrl = TextEditingController(text: widget.boat?.powerType);
    _lengthCtrl = TextEditingController(text: widget.boat?.boatLength);
    _yearCtrl = TextEditingController(text: widget.boat?.yearBuilt);
  }

  /// This cleans up when the form is closed
  @override
  void dispose() {
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _powerCtrl.dispose();
    _lengthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  /// This checks if a field is empty and shows an error if it is
  void _checkField(String fieldName, String fieldValue) {
    setState(() {
      final errorMsg = fieldValue.isEmpty ? '${fieldName.toUpperCase()} is required' : null;
      
      switch (fieldName) {
        case 'address':
          _addressErr = errorMsg;
          break;
        case 'price':
          _priceErr = errorMsg;
          break;
        case 'power':
          _powerErr = errorMsg;
          break;
        case 'length':
          _lengthErr = errorMsg;
          break;
        case 'year':
          _yearErr = errorMsg;
          break;
      }
    });
  }

  /// This saves the boat when you click submit
  void _submitForm() async {
    /// Get the translation helper
    final localization = AppLocalizations.of(context)!;

    /// Make a list of all fields to check
    final fieldsToValidate = {
      'address': _addressCtrl.text,
      'price': _priceCtrl.text,
      'power': _powerCtrl.text,
      'length': _lengthCtrl.text,
      'year': _yearCtrl.text,
    };

    /// Check each field for errors
    fieldsToValidate.forEach((name, value) => _checkField(name, value));

    /// See if any field has an error
    final hasErrors = [_addressErr, _priceErr, _powerErr, _lengthErr, _yearErr]
        .any((error) => error != null);

    /// If there are errors, show a message and don't save
    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate("PleaseFillAllFields")!)),
      );
      return;
    }

    /// Create a boat object with all the information
    final boatData = Boat(
      id: _isEditMode ? widget.boat!.id : null,
      address: _addressCtrl.text,
      price: _priceCtrl.text,
      powerType: _powerCtrl.text,
      boatLength: _lengthCtrl.text,
      yearBuilt: _yearCtrl.text,
    );

    /// Get the right success message
    final msg = _isEditMode 
        ? localization.translate("Updated")! 
        : localization.translate("Saved")!;

    /// Save or update the boat in the database
    _isEditMode 
        ? await _boatService.updateBoat(boatData)
        : await _boatService.saveBoat(boatData);

    /// Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    _closeForm();
  }

  /// This closes the form and tells the parent we are done
  void _closeForm() async {
    widget.onSubmit();
  }

  /// This copies information from the last boat you saved
  void _copyPrevious() async {
    /// Load the last boat from storage
    final previousBoat = await _boatService.loadLastBoat();
    
    /// If there is no previous boat, do nothing
    if (previousBoat == null) return;
    
    /// Fill in all the fields with the previous boat information
    setState(() {
      _addressCtrl.text = previousBoat.address;
      _priceCtrl.text = previousBoat.price;
      _powerCtrl.text = previousBoat.powerType;
      _lengthCtrl.text = previousBoat.boatLength;
      _yearCtrl.text = previousBoat.yearBuilt;
    });
  }

  /// This deletes the boat after asking if you are sure
  void _removeBoat() {
    final localization = AppLocalizations.of(context)!;

    /// Show a popup to ask if you really want to delete
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(localization.translate("DeleteTitleBoat")!),
          content: Text(localization.translate("DeleteConfirmBoat")!),
          actions: [
            TextButton(
              child: Text(localization.translate("Cancel")!),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(localization.translate("Delete")!),
              onPressed: () async {
                await _boatService.deleteBoat(widget.boat!);
                Navigator.pop(dialogCtx);
                _closeForm();
              },
            ),
          ],
        );
      },
    );
  }

  /// This builds the header with the title and copy button
  Widget _createHeader() {
    final localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isEditMode
              ? localization.translate("EditBoatForm")!
              : localization.translate("NewBoat")!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (!_isEditMode)
          IconButton(
            icon: Icon(Icons.copy),
            tooltip: localization.translate("CopyPreviousBoat")!,
            onPressed: _copyPrevious,
          ),
      ],
    );
  }

  /// This builds what you see on the screen
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    /// This builds the form with all the fields and buttons
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                TextField(
                  controller: _addressCtrl,
                  decoration: InputDecoration(
                    labelText: localization.translate("Address")!,
                    border: OutlineInputBorder(),
                    errorText: _addressErr,
                  ),
                  onChanged: (val) => _checkField('address', val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceCtrl,
                  decoration: InputDecoration(
                    labelText: localization.translate("Price")!,
                    border: OutlineInputBorder(),
                    errorText: _priceErr,
                  ),
                  onChanged: (val) => _checkField('price', val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _powerCtrl,
                  decoration: InputDecoration(
                    labelText: localization.translate("PowerType")!,
                    border: OutlineInputBorder(),
                    errorText: _powerErr,
                  ),
                  onChanged: (val) => _checkField('power', val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lengthCtrl,
                  decoration: InputDecoration(
                    labelText: localization.translate("BoatLength")!,
                    border: OutlineInputBorder(),
                    errorText: _lengthErr,
                  ),
                  onChanged: (val) => _checkField('length', val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _yearCtrl,
                  decoration: InputDecoration(
                    labelText: localization.translate("YearBuilt")!,
                    border: OutlineInputBorder(),
                    errorText: _yearErr,
                  ),
                  onChanged: (val) => _checkField('year', val),
                ),
                const SizedBox(height: 24),
                if (_isEditMode)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            localization.translate("Update")!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _removeBoat,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            localization.translate("Delete")!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      localization.translate("Submit")!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

