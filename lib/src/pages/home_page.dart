import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

/*
Generador de QR: https://www.qrcode.es/es/generador-qr-code/
Path Provider para saber rutas dentro del dispositivo: https://pub.dev/packages/path_provider#-readme-tab-
*/
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('QR Scanner'), actions: <Widget>[
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {})
        ]),
        body: _callPage(currentIndex),
        bottomNavigationBar: _crearBottomNavigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: _scanQR,
        ));
  }

  _scanQR() async {
    // https://www.google.com
    // geo:40.70133238380897,-74.1803492589844

    print('Scan QR Plugin');
    String futureString = 'https://www.perfilan.com';

    /*try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }*/

    print('Future String: $futureString');

    if (futureString != null) {
      print('Tenemos información');
      final scan = ScanModel(valor: futureString);
      DBPRovider.db.nuevoSan(scan);
    }
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Direcciones'),
        ),
      ],
    );
  }
}
