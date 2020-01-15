import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class DireccionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanModel>>(
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
        });
  }
}