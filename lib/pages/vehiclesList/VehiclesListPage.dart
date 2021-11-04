import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/refresh_button.dart';
import 'package:taxi_segurito_app/components/inputs/search_field.dart';
import 'package:taxi_segurito_app/models/vehicle.dart';

import 'VehicleListItem.dart';

class VehiclesListPage extends StatefulWidget {
  VehiclesListPage({Key? key}) : super(key: key);

  @override
  _VehiclesListPageState createState() => _VehiclesListPageState();
}

class _VehiclesListPageState extends State<VehiclesListPage> {
  List<Vehicle> vehicles = [];

  _VehiclesListPageState() {
    _loadVehicles();
  }

  void _loadVehicles() {}

  void _refreshVehicles() {
    this.setState(() {
      vehicles = [];
    });
  }

  void _searchVehicle(String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Vehículos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SearchField(
                      onSearch: _searchVehicle,
                      hint: "Buscar por placa, modelo...",
                    ),
                  ),
                ),
                RefreshButton(_refreshVehicles),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1 / 1.25,
                ),
                itemCount: vehicles.length,
                itemBuilder: (_, int index) {
                  return VehicleListItem(vehicles[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
