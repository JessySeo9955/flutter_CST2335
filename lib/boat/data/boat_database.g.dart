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

class _$BoatDatabaseBuilder implements $BoatDatabaseBuilderContract {
  _$BoatDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $BoatDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $BoatDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<BoatDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BoatDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BoatDatabase extends BoatDatabase {
  _$BoatDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BoatDao? _boatDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Boat` (`id` INTEGER, `yearBuilt` TEXT NOT NULL, `boatLength` TEXT NOT NULL, `powerType` TEXT NOT NULL, `price` TEXT NOT NULL, `address` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BoatDao get boatDao {
    return _boatDaoInstance ??= _$BoatDao(database, changeListener);
  }
}

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

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Boat> _boatInsertionAdapter;

  final UpdateAdapter<Boat> _boatUpdateAdapter;

  final DeletionAdapter<Boat> _boatDeletionAdapter;

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

  @override
  Future<int> insertBoat(Boat boat) {
    return _boatInsertionAdapter.insertAndReturnId(
        boat, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateBoat(Boat boat) {
    return _boatUpdateAdapter.updateAndReturnChangedRows(
        boat, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteBoat(Boat boat) {
    return _boatDeletionAdapter.deleteAndReturnChangedRows(boat);
  }
}
