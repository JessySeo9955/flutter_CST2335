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
  bool _isTablet = false;
  int? _selectedIndex;

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
    _selectedIndex = null; // reset selection on data refresh for tablet mode
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

  Widget _buildCarTile(Car car, CarService service, int index) {
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
        onTap: () => _onCarTap(service, car, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    _isTablet = MediaQuery.of(context).size.width > 600;

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
                  : _reactiveLayout(service!),
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

  Widget _reactiveLayout(CarService service) {
    if (_isTablet) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildList(service),
          ),
          Expanded(
            flex: 2,
            child: _buildDetailPanel(),
          ),
        ],
      );
    }

    return _buildList(service);
  }

  Widget _buildList(CarService service) {
    return ListView.builder(
      itemCount: _cars.length,
      itemBuilder: (_, i) => _buildCarTile(_cars[i], service, i),
    );
  }

  Widget _buildDetailPanel() {
    final loc = AppLocalizations.of(context);

    if (_selectedIndex == null) {
      return Center(
        child: Text(
          loc?.translate('SelectCar') ?? 'Select a car',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    final car = _cars[_selectedIndex!];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(
                '${car.year} ${car.make} ${car.model}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _detailRow(
                label: loc?.translate('CarYear') ?? 'Year',
                value: car.year.toString(),
                icon: Icons.calendar_today,
              ),
              _detailRow(
                label: loc?.translate('CarMake') ?? 'Make',
                value: car.make,
                icon: Icons.factory,
              ),
              _detailRow(
                label: loc?.translate('CarModel') ?? 'Model',
                value: car.model,
                icon: Icons.directions_car,
              ),
              _detailRow(
                label: loc?.translate('CarPrice') ?? 'Price',
                value: '\$${car.price.toStringAsFixed(2)}',
                icon: Icons.attach_money,
              ),
              _detailRow(
                label: loc?.translate('CarKilometres') ?? 'Kilometres Driven',
                value: '${car.kilometers.toStringAsFixed(0)} km',
                icon: Icons.speed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCarTap(CarService service, Car car, int index) {
    if (_isTablet) {
      setState(() => _selectedIndex = index);
    } else {
      _openCarForm(service, car: car);
    }
  }
}
