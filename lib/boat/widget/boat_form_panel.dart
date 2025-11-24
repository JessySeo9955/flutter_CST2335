import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../data/boat_model.dart';
import '../service/boat_service.dart';

// Form panel for boat creation and editing
class BoatFormPanel extends StatefulWidget {
  final Boat? boat;
  final VoidCallback onSubmit;

  const BoatFormPanel({super.key, this.boat, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _BoatFormPanelState();
}

// State for boat form panel
class _BoatFormPanelState extends State<BoatFormPanel> {
  final BoatService _boatService = BoatService();

  late TextEditingController _addressCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _powerCtrl;
  late TextEditingController _lengthCtrl;
  late TextEditingController _yearCtrl;

  bool _isEditMode = false;

  String? _addressErr;
  String? _priceErr;
  String? _powerErr;
  String? _lengthErr;
  String? _yearErr;

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

  @override
  void dispose() {
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _powerCtrl.dispose();
    _lengthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  // Check if field is valid
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

  // Submit form data
  void _submitForm() async {
    final localization = AppLocalizations.of(context)!;

    final fieldsToValidate = {
      'address': _addressCtrl.text,
      'price': _priceCtrl.text,
      'power': _powerCtrl.text,
      'length': _lengthCtrl.text,
      'year': _yearCtrl.text,
    };

    fieldsToValidate.forEach((name, value) => _checkField(name, value));

    final hasErrors = [_addressErr, _priceErr, _powerErr, _lengthErr, _yearErr]
        .any((error) => error != null);

    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.translate("PleaseFillAllFields")!)),
      );
      return;
    }

    final boatData = Boat(
      id: _isEditMode ? widget.boat!.id : null,
      address: _addressCtrl.text,
      price: _priceCtrl.text,
      powerType: _powerCtrl.text,
      boatLength: _lengthCtrl.text,
      yearBuilt: _yearCtrl.text,
    );

    final msg = _isEditMode 
        ? localization.translate("Updated")! 
        : localization.translate("Saved")!;

    _isEditMode 
        ? await _boatService.updateBoat(boatData)
        : await _boatService.saveBoat(boatData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    _closeForm();
  }

  // Close form and notify parent
  void _closeForm() async {
    widget.onSubmit();
  }

  // Copy previous boat data to form
  void _copyPrevious() async {
    final previousBoat = await _boatService.loadLastBoat();
    
    if (previousBoat == null) return;
    
    setState(() {
      _addressCtrl.text = previousBoat.address;
      _priceCtrl.text = previousBoat.price;
      _powerCtrl.text = previousBoat.powerType;
      _lengthCtrl.text = previousBoat.boatLength;
      _yearCtrl.text = previousBoat.yearBuilt;
    });
  }

  // Remove boat after confirmation
  void _removeBoat() {
    final localization = AppLocalizations.of(context)!;

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

  // Build form header with title
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

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

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

