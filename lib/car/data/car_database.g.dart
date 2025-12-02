// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $CarDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $CarDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $CarDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<CarDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorCarDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CarDatabaseBuilderContract databaseBuilder(String name) =>
      _$CarDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CarDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$CarDatabaseBuilder(null);
}

class _$CarDatabaseBuilder implements $CarDatabaseBuilderContract {
  _$CarDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $CarDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $CarDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<CarDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CarDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CarDatabase extends CarDatabase {
  _$CarDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CarDao? _carDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Car` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `year` INTEGER NOT NULL, `make` TEXT NOT NULL, `model` TEXT NOT NULL, `price` REAL NOT NULL, `kilometers` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CarDao get carDao {
    return _carDaoInstance ??= _$CarDao(database, changeListener);
  }
}

class _$CarDao extends CarDao {
  _$CarDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _carInsertionAdapter = InsertionAdapter(
            database,
            'Car',
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'year': item.year,
                  'make': item.make,
                  'model': item.model,
                  'price': item.price,
                  'kilometers': item.kilometers
                }),
        _carUpdateAdapter = UpdateAdapter(
            database,
            'Car',
            ['id'],
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'year': item.year,
                  'make': item.make,
                  'model': item.model,
                  'price': item.price,
                  'kilometers': item.kilometers
                }),
        _carDeletionAdapter = DeletionAdapter(
            database,
            'Car',
            ['id'],
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'year': item.year,
                  'make': item.make,
                  'model': item.model,
                  'price': item.price,
                  'kilometers': item.kilometers
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Car> _carInsertionAdapter;

  final UpdateAdapter<Car> _carUpdateAdapter;

  final DeletionAdapter<Car> _carDeletionAdapter;

  @override
  Future<List<Car>> getAllCars() async {
    return _queryAdapter.queryList('SELECT * FROM Car',
        mapper: (Map<String, Object?> row) => Car(
            id: row['id'] as int?,
            year: row['year'] as int,
            make: row['make'] as String,
            model: row['model'] as String,
            price: row['price'] as double,
            kilometers: row['kilometers'] as double));
  }

  @override
  Future<int> insertCar(Car car) {
    return _carInsertionAdapter.insertAndReturnId(
        car, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCar(Car car) {
    return _carUpdateAdapter.updateAndReturnChangedRows(
        car, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCar(Car car) {
    return _carDeletionAdapter.deleteAndReturnChangedRows(car);
  }
}
