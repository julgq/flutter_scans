import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    // Para utilizar el stram se usa un StreamBuilder
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          // Validar sí existe data:
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(child: Text('No hay información'));
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
              background: Container(color: Colors.red),
              child: ListTile(
                  leading: Icon(Icons.cloud_queue,
                      color: Theme.of(context).primaryColor),
                  title: Text(scans[i].valor),
                  subtitle: Text('ID: ${scans[i].id}'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    utils.abrirScan(scans[i], context);
                  }),
            ),
          );
        });

    /*return FutureBuilder<List<ScanModel>>(
        future: DBPRovider.db.getTodosScans(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          // Validar sí existe data:
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(child: Text('No hay información'));
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) => DBPRovider.db.deleteScan(scans[i].id),
              background: Container(color: Colors.red),
              child: ListTile(
                  leading: Icon(Icons.cloud_queue,
                      color: Theme.of(context).primaryColor),
                  title: Text(scans[i].valor),
                  subtitle: Text('ID: ${scans[i].id}'),
                  trailing: Icon(Icons.keyboard_arrow_right)),
            ),
          );
        });*/
  }
}
