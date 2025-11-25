import 'package:flutter/material.dart';
import '../data/car_model.dart';
import '../service/car_service.dart';
import '../preference/car_prefs.dart';
import '../widget/car_form_panel.dart';
import '../../AppLocalizations.dart';

/// Page for adding, editing, and deleting a car.
class CarFormPage extends StatefulWidget {
  final CarService carService;
  final Car? car;

  const CarFormPage({
    super.key,
    required this.carService,
    this.car,
  });

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _yearController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _priceController;
  late final TextEditingController _kilometersController;

  bool get _isNewCar => widget.car == null;

  @override
  void initState() {
    super.initState();

    _yearController =
        TextEditingController(text: widget.car?.year.toString() ?? '');
    _makeController =
        TextEditingController(text: widget.car?.make ?? '');
    _modelController =
        TextEditingController(text: widget.car?.model ?? '');
    _priceController =
        TextEditingController(text: widget.car?.price.toString() ?? '');
    _kilometersController =
        TextEditingController(text: widget.car?.kilometers.toString() ?? '');

    if (_isNewCar) {
      _askCopyPrevious();
    }
  }

  Future<void> _askCopyPrevious() async {
    final last = await CarPrefs.loadLastCar();
    if (last == null) return;
    if (!mounted) return;

    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc?.translate('CopyPreviousCar') ?? 'Copy Previous Car'),
        content: Text(
          loc?.translate('CopyPreviousCar') ??
              'Copy the previous car or start blank.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc?.translate('Cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _yearController.text = last['year'] ?? '';
                _makeController.text = last['make'] ?? '';
                _modelController.text = last['model'] ?? '';
                _priceController.text = last['price'] ?? '';
                _kilometersController.text = last['kilometers'] ?? '';
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc?.translate('CopyPreviousCar') ??
                      'Previous car copied.'),
                ),
              );
            },
            child: Text(loc?.translate('CopyPreviousCar') ?? 'Copy Previous Car'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCar() async {
    final loc = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc?.translate('CarPleaseFillAllFields') ??
              'Please fill in all fields'),
        ),
      );
      return;
    }

    final car = Car(
      id: widget.car?.id,
      year: int.parse(_yearController.text),
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      price: double.parse(_priceController.text),
      kilometers: double.parse(_kilometersController.text),
    );

    try {
      if (_isNewCar) {
        await widget.carService.insertCar(car);

        await CarPrefs.saveLastCar(
          year: _yearController.text,
          make: _makeController.text,
          model: _modelController.text,
          price: _priceController.text,
          kilometers: _kilometersController.text,
        );

        Navigator.pop(context, 'added');
      } else {
        await widget.carService.updateCar(car);
        Navigator.pop(context, 'updated');
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(loc?.translate('CarErrorSaving') ?? 'Error saving car'),
        ),
      );
    }
  }

  Future<void> _deleteCar() async {
    if (widget.car == null) return;

    final loc = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc?.translate('DeleteTitleCar') ?? 'Delete Car'),
        content: Text(
          loc?.translate('DeleteConfirmCar') ??
              'Are you sure you want to delete this car?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc?.translate('Cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              loc?.translate('Delete') ?? 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await widget.carService.deleteCar(widget.car!);
      Navigator.pop(context, 'deleted');
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(loc?.translate('CarErrorDeleting') ?? 'Error deleting car'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNewCar
              ? (loc?.translate('NewCar') ?? 'New Car')
              : (loc?.translate('EditCar') ?? 'Edit Car'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CarFormPanel(
          formKey: _formKey,
          yearController: _yearController,
          makeController: _makeController,
          modelController: _modelController,
          priceController: _priceController,
          kilometresController: _kilometersController, // FIXED
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isNewCar)
            FloatingActionButton.extended(
              heroTag: 'delete-car',
              backgroundColor: Colors.red,
              onPressed: _deleteCar,
              icon: const Icon(Icons.delete),
              label: Text(loc?.translate('Delete') ?? 'Delete'),
            ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'save-car',
            onPressed: _saveCar,
            icon: const Icon(Icons.save),
            label: Text(loc?.translate('Saved') ?? 'Save'),
          ),
        ],
      ),
    );
  }
}
