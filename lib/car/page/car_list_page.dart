import 'package:flutter/material.dart';
import '../data/car_database.dart';
import '../data/car_model.dart';
import '../service/car_service.dart';
import 'car_form_page.dart';
import '../../AppLocalizations.dart';

/// Main page listing all cars for sale.
class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late Future<CarService> _serviceFuture;
  List<Car> _cars = [];

  @override
  void initState() {
    super.initState();
    print('🚗 CarListPage initState called!');
    _serviceFuture = _initializeService();
  }

  Future<CarService> _initializeService() async {
    print('🚗 Starting database initialization...');
    final db = await $FloorCarDatabase
        .databaseBuilder('cars_database.db')
        .build();
    print('🚗 Database created!');
    final service = CarService(db);

    _cars = await service.getAllCars();
    return service;
  }

  Future<void> _refreshCars(CarService service) async {
    _cars = await service.getAllCars();
    if (mounted) setState(() {});
  }

  Future<void> _openCarForm(CarService service, {Car? car}) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => CarFormPage(
          carService: service,
          car: car,
        ),
      ),
    );

    if (result != null) {
      await _refreshCars(service);

      final loc = AppLocalizations.of(context);

      String message = switch (result) {
        'added' => loc?.translate('CarAdded') ?? 'Car added.',
        'updated' => loc?.translate('CarUpdated') ?? 'Car updated.',
        'deleted' => loc?.translate('CarDeleted') ?? 'Car deleted.',
        _ => '',
      };

      if (message.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  void _showHelpDialog() {
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc?.translate('InstructionsTitleCar') ?? 'Instructions'),
        content: Text(
          loc?.translate('InstructionsContentCar') ??
              'Tap + to add cars.\nTap a car to view details.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc?.translate('Ok') ?? 'OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildCarTile(Car car, CarService service) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(car.year.toString().substring(2)),
        ),
        title: Text('${car.year} ${car.make} ${car.model}'),
        subtitle: Text(
          '\$${car.price.toStringAsFixed(2)} • '
              '${car.kilometers.toStringAsFixed(0)} km',  // FIXED
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openCarForm(service, car: car),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return FutureBuilder<CarService>(
      future: _serviceFuture,
      builder: (context, snapshot) {
        final service = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(loc?.translate('Cars') ?? 'Cars for Sale'),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: _showHelpDialog,
              ),
            ],
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : _cars.isEmpty
              ? Center(
            child: Text(
              loc?.translate('NoCars') ?? 'No cars found',
              style: const TextStyle(fontSize: 18),
            ),
          )
              : ListView.builder(
            itemCount: _cars.length,
            itemBuilder: (_, i) =>
                _buildCarTile(_cars[i], service!),
          ),
          floatingActionButton:
          snapshot.connectionState == ConnectionState.done
              ? FloatingActionButton.extended(
            onPressed: () => _openCarForm(service!),
            icon: const Icon(Icons.add),
            label: Text(loc?.translate('AddCar') ?? 'Add Car'),
          )
              : null,
        );
      },
    );
  }
}
