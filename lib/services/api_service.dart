import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/signal.dart';

class ApiService {
  static const _defaultUrl = 'https://your-app.up.railway.app';
  static const _prefKey = 'backend_url';

  static Future<String> get baseUrl async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey) ?? _defaultUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, url.trimRight().replaceAll(RegExp(r'/$'), ''));
  }

  static Future<Map<String, dynamic>> _get(String path) async {
    final url = await baseUrl;
    final res = await http.get(Uri.parse('$url$path')).timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('HTTP ${res.statusCode}');
  }

  static Future<void> _post(String path) async {
    final url = await baseUrl;
    await http.post(Uri.parse('$url$path')).timeout(const Duration(seconds: 10));
  }

  static Future<Map<String, dynamic>> getSignals() async {
    final data = await _get('/api/signals');
    final signals = (data['signals'] as List).map((s) => Signal.fromJson(s)).toList();
    return {'signals': signals, 'lastRun': data['last_run'] ?? 'Never'};
  }

  static Future<List<Position>> getPositions() async {
    final data = await _get('/api/positions');
    return (data['positions'] as List).map((p) => Position.fromJson(p)).toList();
  }

  static Future<Map<String, dynamic>> getStats() async {
    final data = await _get('/api/stats');
    return data['stats'] ?? {};
  }

  static Future<String> getHealth() async {
    final data = await _get('/health');
    return data['engine_status'] ?? 'unknown';
  }

  static Future<void> refresh() async => _post('/api/refresh');
}
