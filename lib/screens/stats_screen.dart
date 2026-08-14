import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, dynamic> _stats = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final s = await ApiService.getStats();
      setState(() => _stats = s);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('Journal Stats', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4FC3F7)))
          : _stats.isEmpty
              ? Center(child: Text('No trades yet', style: TextStyle(color: Colors.grey[400], fontSize: 16)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _statCard('Open Positions', '${_stats['n_open'] ?? 0}', const Color(0xFF4FC3F7)),
                      _statCard('Closed Trades', '${_stats['n_closed'] ?? 0}', Colors.white),
                      if (_stats['win_rate'] != null)
                        _statCard('Win Rate',
                            '${((_stats['win_rate'] as num) * 100).toStringAsFixed(1)}%',
                            (_stats['win_rate'] as num) >= 0.35
                                ? const Color(0xFF00C853)
                                : const Color(0xFFFF1744)),
                      if (_stats['total_pnl'] != null)
                        _statCard('Total P&L',
                            '₹${(_stats['total_pnl'] as num).toStringAsFixed(0)}',
                            (_stats['total_pnl'] as num) >= 0
                                ? const Color(0xFF00C853)
                                : const Color(0xFFFF1744)),
                      if (_stats['avg_r'] != null)
                        _statCard('Avg R-Multiple',
                            '${(_stats['avg_r'] as num).toStringAsFixed(2)}R', Colors.white70),
                      if (_stats['n_target_hit'] != null)
                        _statCard('Target Hits', '${_stats['n_target_hit']}', const Color(0xFF00C853)),
                      if (_stats['n_stop_hit'] != null)
                        _statCard('Stop Hits', '${_stats['n_stop_hit']}', const Color(0xFFFF1744)),
                    ],
                  ),
                ),
    );
  }

  Widget _statCard(String label, String value, Color valueColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 15)),
          Text(value,
              style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
