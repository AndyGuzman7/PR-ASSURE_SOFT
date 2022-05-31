import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/map/markers_map.dart';
import 'package:taxi_segurito_app/models/owner.dart';
import 'package:taxi_segurito_app/strategis/location_service.dart';

class ViewMap extends StatefulWidget {
  LatLng? latLngOrigin;
  LatLng? latLngDestine;
  ViewMap({Key? key}) : super(key: key);
  _ViewMapState _taxiRequestMapv2State = new _ViewMapState();
  @override
  State<ViewMap> createState() {
    return _taxiRequestMapv2State;
  }

  getLocationOrigen() {
    return _taxiRequestMapv2State.getLocationOrigen();
  }

  getLocationDestino() {
    return _taxiRequestMapv2State.getLocationDestino();
  }
}

class _ViewMapState extends State<ViewMap> {
  LocationService locationService = new LocationService();
  MarkersMap markersMap = new MarkersMap();
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);

  getLocationOrigen() {
    return widget.latLngOrigin;
  }

  getLocationDestino() {
    return widget.latLngDestine;
  }

  late BitmapDescriptor pinLocationIconUser, pinLocationIconCar;
  @override
  void initState() {
    super.initState();
    locationService.getPermisson();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Container(
      height: height,
      width: width,
      child: FutureBuilder(
        future: locationService.getUbication(),
        builder: (_, AsyncSnapshot<LocationData> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;

            if (widget.latLngOrigin == null)
              widget.latLngOrigin =
                  LatLng(data?.latitude ?? 0.0, data?.longitude ?? 0.0);

            if (widget.latLngDestine == null) {
              widget.latLngDestine =
                  LatLng(-0.000327615289788, -0.00522494279294);

              widget.latLngDestine = LatLng(
                (widget.latLngOrigin!.latitude +
                    widget.latLngDestine!.latitude),
                (widget.latLngOrigin!.longitude +
                    widget.latLngDestine!.longitude),
              );
            }

            return Expanded(
                child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: widget.latLngOrigin!, zoom: 15),
              onMapCreated: (GoogleMapController controller) {},
              mapToolbarEnabled: false,
              compassEnabled: false,
              myLocationEnabled: true,
              markers: markersMap.createMarkersMap(
                  widget.latLngOrigin!, widget.latLngDestine!),
              mapType: MapType.normal,
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
