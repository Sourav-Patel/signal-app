import 'package:flutter/material.dart';
import '../models/signal.dart';
import '../services/api_service.dart';

class PositionsScreen extends StatefulWidget {
  const PositionsScreen({super.key});

  @override
  State<PositionsScreen> createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  List<Position> _positions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final p = await ApiService.getPositions();
      setState(() => _positions = p);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('Open Positions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4FC3F7)))
          : _positions.isEmpty
              ? Center(child: Text('No open positions', style: TextStyle(color: Colors.grey[400], fontSize: 16)))
              : RefreshIndicator(
                  onRefresh: _load,
                  color: const Color(0xFF4FC3F7),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _positions.length,
                    itemBuilder: (_, i) => _PositionTile(position: _positions[i]),
                  ),
                ),
    );
  }
}

class _PositionTile extends StatelessWidget {
  final Position position;
  const _PositionTile({required this.position});

  @override
  Widget build(BuildContext context) {
    final isLong = position.direction == 'LONG';
    final color = isLong ? const Color(0xFF00C853) : const Color(0xFFFF1744);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(position.symbol,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                child: Text(position.direction,
                    style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Text('#${position.signalId}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _item('Entry', '₹${position.entryPrice.toStringAsFixed(1)}', Colors.white),
              _item('Stop', '₹${position.stopPrice.toStringAsFixed(1)}', const Color(0xFFFF1744)),
              _item('Target', '₹${position.targetPrice.toStringAsFixed(1)}', const Color(0xFF00C853)),
              _item('Qty', '${position.quantity}', Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
