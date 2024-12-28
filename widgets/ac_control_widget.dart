import 'package:flutter/material.dart';
import '../services/homegraph_service.dart';

class ACControlWidget extends StatefulWidget {
  final String deviceId;

  ACControlWidget({required this.deviceId});

  @override
  _ACControlWidgetState createState() => _ACControlWidgetState();
}

class _ACControlWidgetState extends State<ACControlWidget> {
  Map<String, dynamic>? deviceState;

  @override
  void initState() {
    super.initState();
    _fetchDeviceState();
  }

  Future<void> _fetchDeviceState() async {
    final state = await HomeGraphService.queryDeviceState('charles.mtdg@gmail.com', widget.deviceId);
    setState(() {
      deviceState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (deviceState != null)
          Text('State: ${deviceState.toString()}'),
        ElevatedButton(
          onPressed: _fetchDeviceState,
          child: Text('Refresh State'),
        ),
      ],
    );
  }
}
