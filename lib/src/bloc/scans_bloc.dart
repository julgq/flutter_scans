// Implementar el patron Singlenton.

import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener Scans de la base de datos
    // Cuando se ejecuta por primera vez el constructor
    obtenerScans();
  }

  // Crear StreamController
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  // getter que me regresa el flujo de datos en tiempo real.
  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  // Cerrar StreamController
  dispose() {
    _scansController?.close(); // el signo ? sirve validar
  }

  obtenerScans() async {
    // Pongo el await para esperar a que me regresa la lista.
    _scansController.sink.add(await DBPRovider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async {
    // aquí se agrega un async aiwat para asegurar que primero haga el nuevo scan y despues, actualice.
    await DBPRovider.db.nuevoSan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBPRovider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTODOS() async {
    await DBPRovider.db.deleteAll();
    obtenerScans();
  }
}
