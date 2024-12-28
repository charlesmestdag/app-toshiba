import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/homegraph/v1.dart';

class HomeGraphService {
  static const String serviceAccountKeyPath = 'lib/assets/keys/cle_service_account.json';
  static const List<String> scopes = ['https://www.googleapis.com/auth/homegraph'];

  static Future<AuthClient> getAuthenticatedClient() async {
    final serviceAccountJson = File(serviceAccountKeyPath).readAsStringSync();
    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
    return await clientViaServiceAccount(credentials, scopes);
  }

  static Future<HomeGraphServiceApi> createHomeGraphApi() async {
    final client = await getAuthenticatedClient();
    return HomeGraphServiceApi(client);
  }

  static Future<Map<String, dynamic>> queryDeviceState(String agentUserId, String deviceId) async {
    final homeGraphApi = await createHomeGraphApi();
    final queryRequest = QueryRequest(
      requestId: 'request-${DateTime.now().millisecondsSinceEpoch}',
      agentUserId: agentUserId,
      inputs: [
        QueryRequestInput(
          payload: QueryRequestPayload(
            devices: [AgentDeviceId(id: deviceId)],
          ),
        ),
      ],
    );

    final response = await homeGraphApi.devices.query(queryRequest);
    print('Response: ${response.toJson()}'); // Vérifiez ici
    return response.payload?.devices ?? {};

  }

  static Future<void> syncDevices(String agentUserId) async {
    final homeGraphApi = await createHomeGraphApi();
    final syncRequest = SyncRequest(
      requestId: 'request-${DateTime.now().millisecondsSinceEpoch}',
      agentUserId: agentUserId,
    );

    final response = await homeGraphApi.devices.sync(syncRequest);
    print('Sync Response: ${response.payload?.devices}');
  }

  static Future<void> reportDeviceState(
      String agentUserId, String deviceId, Map<String, dynamic> states) async {
    final homeGraphApi = await createHomeGraphApi();
    final reportRequest = ReportStateAndNotificationRequest(
      requestId: 'request-${DateTime.now().millisecondsSinceEpoch}',
      agentUserId: agentUserId,
      payload: StateAndNotificationPayload(
        devices: ReportStateAndNotificationDevice(
          states: states,
        ),
      ),
    );

    final response = await homeGraphApi.devices.reportStateAndNotification(reportRequest);
    print('Report State Response: ${response.toJson()}');
  }
}
