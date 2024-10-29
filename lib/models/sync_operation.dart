import 'dart:convert';

class SyncOperation {
  final String id;
  final String functionName;
  final Map<String, dynamic> params;
  final DateTime timestamp;
  final String status;

  /*
CREATE TABLE sync_queue (
    id TEXT PRIMARY KEY,
    function_name TEXT NOT NULL,   -- Name of function to execute
    params TEXT NOT NULL,          -- JSON encoded parameters
    timestamp TEXT NOT NULL,       -- Operation creation timestamp
    status TEXT NOT NULL DEFAULT 'pending'  -- pending, completed, failed
);
    */

  SyncOperation({
    required this.id,
    required this.functionName,
    required this.params,
    required this.timestamp,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'function_name': functionName,
      'params': jsonEncode(params),
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  static SyncOperation fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'],
      functionName: map['function_name'],
      params: jsonDecode(map['params']),
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
    );
  }
}
