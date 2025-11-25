import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';

/// A reusable form panel widget for entering or editing Car information.
/// This matches the same architecture your teammates used for boats.
class CarFormPanel extends StatelessWidget {
  final TextEditingController yearController;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController priceController;
  final TextEditingController kilometresController;

  final GlobalKey<FormState> formKey;

  const CarFormPanel({
    super.key,
    required this.yearController,
    required this.makeController,
    required this.modelController,
    required this.priceController,
    required this.kilometresController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            context: context,
            controller: yearController,
            label: loc?.translate('CarYear') ?? 'Year of Manufacture',
            hint: '2020',
            icon: Icons.calendar_month,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc?.translate('CarPleaseFillAllFields') ??
                    'Please fill in all fields';
              }
              final year = int.tryParse(value);
              final now = DateTime.now().year;
              if (year == null || year < 1900 || year > now + 1) {
                return 'Enter a valid year (1900–${now + 1})';
              }
              return null;
            },
          ),
          _buildTextField(
            context: context,
            controller: makeController,
            label: loc?.translate('CarMake') ?? 'Make',
            hint: 'Toyota, Tesla, Honda…',
            icon: Icons.directions_car,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc?.translate('CarPleaseFillAllFields') ??
                    'Please fill in all fields';
              }
              return null;
            },
          ),
          _buildTextField(
            context: context,
            controller: modelController,
            label: loc?.translate('CarModel') ?? 'Model',
            hint: 'Corolla, Model 3…',
            icon: Icons.directions_car_filled,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc?.translate('CarPleaseFillAllFields') ??
                    'Please fill in all fields';
              }
              return null;
            },
          ),
          _buildTextField(
            context: context,
            controller: priceController,
            label: loc?.translate('CarPrice') ?? 'Price',
            hint: '25000.00',
            icon: Icons.attach_money,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc?.translate('CarPleaseFillAllFields') ??
                    'Please fill in all fields';
              }
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'Enter a valid price';
              }
              return null;
            },
          ),
          _buildTextField(
            context: context,
            controller: kilometresController,
            label: loc?.translate('CarKilometres') ?? 'Kilometres Driven',
            hint: '50000',
            icon: Icons.speed,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc?.translate('CarPleaseFillAllFields') ??
                    'Please fill in all fields';
              }
              final km = double.tryParse(value);
              if (km == null || km < 0) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
