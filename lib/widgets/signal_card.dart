import 'package:flutter/material.dart';
import '../models/signal.dart';

class SignalCard extends StatelessWidget {
  final Signal signal;
  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final isLong = signal.isLong;
    final color = isLong ? const Color(0xFF00C853) : const Color(0xFFFF1744);
    final arrow = isLong ? '▲' : '▼';
    final label = isLong ? 'LONG' : 'SHORT';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('$arrow $label',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(signal.symbol,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('P(win)', style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                    Text('${(signal.metaProba * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          // Price grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _priceCell('Entry', signal.entryPrice, Colors.white),
                    _priceCell('Stop', signal.stopPrice, const Color(0xFFFF1744)),
                    _priceCell('Target', signal.targetPrice, const Color(0xFF00C853)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _infoCell('Quantity', '${signal.quantity} shares'),
                    _infoCell('Risk', '₹${_fmt(signal.riskRs)}'),
                    _infoCell('R:R', '1:${signal.rrRatio.toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D1A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    signal.ruleType.replaceAll('_', ' ') +
                        ' · ${signal.nConditions}/5 conditions',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceCell(String label, double price, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          const SizedBox(height: 2),
          Text('₹${_fmt(price)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _infoCell(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return v.toStringAsFixed(2);
  }
}
