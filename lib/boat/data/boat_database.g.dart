// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boat_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $BoatDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $BoatDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $BoatDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<BoatDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorBoatDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BoatDatabaseBuilderContract databaseBuilder(String name) =>
      _$BoatDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BoatDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$BoatDatabaseBuilder(null);
}
/// Builder for the boat database
class _$BoatDatabaseBuilder implements $BoatDatabaseBuilderContract {
  _$BoatDatabaseBuilder(this.name);
  /// Name of the database
  final String? name;
  /// Migrations for the database
  final List<Migration> _migrations = [];
  /// Callback for the database
  Callback? _callback;

  /// Add migrations to the database
  @override
  $BoatDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Add a callback to the database
  @override
  $BoatDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Build the database
  @override
  Future<BoatDatabase> build() async {
    /// Path to the database
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    /// Database object
    final database = _$BoatDatabase();
    /// Open the database
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}
/// Implementation of the boat database
class _$BoatDatabase extends BoatDatabase {
  /// Constructor for the boat database
  _$BoatDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  /// Boat data access object instance
  BoatDao? _boatDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    /// Database options
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        /// Configure the database
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        /// Open the database
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        /// Run migrations
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        /// Callback on upgrade
        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        /// Create the table
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Boat` (`id` INTEGER, `yearBuilt` TEXT NOT NULL, `boatLength` TEXT NOT NULL, `powerType` TEXT NOT NULL, `price` TEXT NOT NULL, `address` TEXT NOT NULL, PRIMARY KEY (`id`))');

        /// Callback on create
        await callback?.onCreate?.call(database, version);
      },
    );
    /// Open the database
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }
/// Get the boat data access object
  @override
  BoatDao get boatDao {
    return _boatDaoInstance ??= _$BoatDao(database, changeListener);
  }
}

/// Implementation of the boat data access object
class _$BoatDao extends BoatDao {
  _$BoatDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _boatInsertionAdapter = InsertionAdapter(
            database,
            'Boat',
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'boatLength': item.boatLength,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                }),
        _boatUpdateAdapter = UpdateAdapter(
            database,
            'Boat',
            ['id'],
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'boatLength': item.boatLength,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                }),
        _boatDeletionAdapter = DeletionAdapter(
            database,
            'Boat',
            ['id'],
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'boatLength': item.boatLength,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                });
  /// Database executor
  final sqflite.DatabaseExecutor database;
  /// Change listener
  final StreamController<String> changeListener;
  /// Query adapter
  final QueryAdapter _queryAdapter;
  /// Insertion adapter
  final InsertionAdapter<Boat> _boatInsertionAdapter;
  /// Update adapter
  final UpdateAdapter<Boat> _boatUpdateAdapter;

  /// Deletion adapter
  final DeletionAdapter<Boat> _boatDeletionAdapter;

  /// Get all boats
  @override
  Future<List<Boat>> getAllBoats() async {
    return _queryAdapter.queryList('Select * From Boat',
        mapper: (Map<String, Object?> row) => Boat(
            id: row['id'] as int?,
            yearBuilt: row['yearBuilt'] as String,
            boatLength: row['boatLength'] as String,
            powerType: row['powerType'] as String,
            price: row['price'] as String,
            address: row['address'] as String));
  }

  /// Insert a boat
  @override
  Future<int> insertBoat(Boat boat) {
    return _boatInsertionAdapter.insertAndReturnId(
        boat, OnConflictStrategy.abort);
  }

  /// Update a boat
  @override
  Future<int> updateBoat(Boat boat) {
    return _boatUpdateAdapter.updateAndReturnChangedRows(
        boat, OnConflictStrategy.abort);
  }

  /// Delete a boat
  @override
  Future<int> deleteBoat(Boat boat) {
    return _boatDeletionAdapter.deleteAndReturnChangedRows(boat);
  }
}
