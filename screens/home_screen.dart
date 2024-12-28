import 'package:flutter/material.dart';
import '../services/homegraph_service.dart';
import 'device_control_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String agentUserId = 'charles.mtdg@gmail.com'; // Adresse e-mail pour HomeGraph
  List<Map<String, dynamic>> devices = [];

  Future<void> fetchDevices() async {
    try {
      await HomeGraphService.syncDevices(agentUserId);
      final deviceStates = await HomeGraphService.queryDeviceState(agentUserId, '');
      setState(() {
        devices = deviceStates.entries
            .map((entry) => {'id': entry.key.toString(), ...entry.value as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching devices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomeGraph Devices')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: fetchDevices,
            child: Text('Fetch Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device['name'] ?? 'Unknown Device'),
                  subtitle: Text('ID: ${device['id']}'),
                  trailing: Text(device['on'] == true ? 'ON' : 'OFF'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceControlScreen(
                          deviceId: device['id'],
                          deviceName: device['name'] ?? 'Unknown Device',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
