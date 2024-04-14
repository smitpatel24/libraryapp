import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:battery_plus/battery_plus.dart'; // Correct import
import 'package:connectivity_plus/connectivity_plus.dart'; // Correct import

class SystemStatusHeader extends StatefulWidget {
  @override
  _SystemStatusHeaderState createState() => _SystemStatusHeaderState();
}

class _SystemStatusHeaderState extends State<SystemStatusHeader> {
  String _timeString = ''; // Initialized with empty string
  Timer? _timer; // Made nullable
  Battery _battery = Battery(); // Correct for battery_plus
  Connectivity _connectivity = Connectivity(); // Correct for connectivity_plus

  // Initialize with default values
  BatteryState _batteryState = BatteryState.full;
  ConnectivityResult _connectivityStatus = ConnectivityResult.wifi;

  @override
  void initState() {
    super.initState();
    _timeString = _getCurrentTimeInPST();
    // Update time every minute
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getTime());

    // Listen for battery state changes
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      var result = results.first;
      setState(() {
        _connectivityStatus = result;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    final String formattedDateTime = _getCurrentTimeInPST();
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _getCurrentTimeInPST() {
    final nowUtc = DateTime.now().toUtc();
    final nowPst = nowUtc.subtract(Duration(hours: 7));
    return DateFormat('h:mm a').format(nowPst);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _timeString,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            // Network status icon
            Icon(
              _getNetworkIcon(_connectivityStatus),
              color: Colors.white,
            ),
            // Battery status icon
            Icon(
              _getBatteryIcon(_batteryState),
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  IconData _getBatteryIcon(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return Icons.battery_charging_full;
      case BatteryState.full:
        return Icons.battery_full;
      case BatteryState.discharging:
      // Remove the unknown case if it's not a valid value in the enum
      default:
        return Icons.battery_alert; // Used for any state not explicitly listed
    }
  }

  IconData _getNetworkIcon(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.none:
      default:
        return Icons.signal_cellular_off;
    }
  }
}
