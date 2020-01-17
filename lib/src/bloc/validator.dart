import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';

class Validators {
  // StreamTransformer<List<ScanModel>, List<ScanModel>>, recibe un List ScanModel y Regresa un List<ScanModel> al flujo
  // scans es lo que entra y sink es lo que sale en handleData(scans,sink)

  // validador de geo
  final validarGeo =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final geoScans = scans.where((s) => s.tipo == 'geo').toList();

    sink.add(geoScans);
  });

  // validador de http:
  final validarHttp =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final httpScans = scans.where((s) => s.tipo == 'http').toList();
    sink.add(httpScans);
  });
}
