import 'package:flutter/material.dart';
import '../services/homegraph_service.dart';

class DeviceControlScreen extends StatelessWidget {
  final String deviceId;
  final String deviceName;

  DeviceControlScreen({required this.deviceId, required this.deviceName});

  Future<void> toggleDeviceState(bool isOn) async {
    final String agentUserId = 'charles.mtdg@gmail.com'; // Adresse e-mail pour HomeGraph
    final newState = {'on': !isOn};
    await HomeGraphService.reportDeviceState(agentUserId, deviceId, newState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(deviceName)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => toggleDeviceState(false), // Remplacez par l'état actuel
          child: Text('Toggle State'),
        ),
      ),
    );
  }
}
