import 'dart:async';
import 'package:flutter/material.dart';
import '../models/signal.dart';
import '../services/api_service.dart';
import '../widgets/signal_card.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  List<Signal> _signals = [];
  String _lastRun = '';
  bool _loading = false;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(minutes: 2), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await ApiService.getSignals();
      setState(() {
        _signals = result.signals;
        _lastRun = result.lastRun;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    await ApiService.refresh();
    await Future.delayed(const Duration(seconds: 3));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('Signals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loading ? null : _refresh,
            tooltip: 'Refresh signals',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_lastRun.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFF1A1A1A),
              child: Text('Last run: $_lastRun',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _signals.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4FC3F7)));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.grey, size: 48),
            const SizedBox(height: 12),
            Text('Cannot reach server', style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_signals.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: Colors.grey, size: 48),
            const SizedBox(height: 12),
            Text('No signals today', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
            const SizedBox(height: 4),
            Text('Signals generate at 15:35 IST', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: const Color(0xFF4FC3F7),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _signals.length,
        itemBuilder: (_, i) => SignalCard(signal: _signals[i]),
      ),
    );
  }
}
