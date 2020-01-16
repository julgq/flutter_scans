import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

/*
Generador de QR: https://www.qrcode.es/es/generador-qr-code/
Path Provider para saber rutas dentro del dispositivo: https://pub.dev/packages/path_provider#-readme-tab-
*/
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('QR Scanner'), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                print('Borrar Todos');
                scansBloc.borrarScanTODOS();
              })
        ]),
        body: _callPage(currentIndex),
        bottomNavigationBar: _crearBottomNavigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: () => _scanQR(context),
        ));
  }

  _scanQR(BuildContext context) async {
    // https://www.google.com
    // geo:40.70133238380897,-74.1803492589844

    print('Scan QR Plugin');
    String futureString = 'http://www.perfilan.com';

    /*try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }*/

    print('Future String: $futureString');

    if (futureString != null) {
      print('Tenemos información');
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      final scan2 = ScanModel(valor: 'geo:40.70133238380897,-74.1803492589844');
      scansBloc.agregarScan(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(scan, context);
        });
      } else {
        utils.abrirScan(scan, context);
      }
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
