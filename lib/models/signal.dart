class Signal {
  final String symbol;
  final String direction;
  final String ruleType;
  final int nConditions;
  final double entryPrice;
  final double stopPrice;
  final double targetPrice;
  final int quantity;
  final double metaProba;
  final double riskRs;
  final double rewardRs;
  final double rrRatio;
  final String date;
  final List<String> conditionsFired;

  Signal.fromJson(Map<String, dynamic> j)
      : symbol = j['symbol'] ?? '',
        direction = j['direction'] ?? '',
        ruleType = j['rule_type'] ?? '',
        nConditions = j['n_conditions'] ?? 0,
        entryPrice = (j['entry_price'] ?? 0).toDouble(),
        stopPrice = (j['stop_price'] ?? 0).toDouble(),
        targetPrice = (j['target_price'] ?? 0).toDouble(),
        quantity = j['quantity'] ?? 1,
        metaProba = (j['meta_proba'] ?? 0).toDouble(),
        riskRs = (j['risk_rs'] ?? 0).toDouble(),
        rewardRs = (j['reward_rs'] ?? 0).toDouble(),
        rrRatio = (j['rr_ratio'] ?? 0).toDouble(),
        date = j['date'] ?? '',
        conditionsFired = List<String>.from(j['conditions_fired'] ?? []);

  bool get isLong => direction == 'LONG';
}


class Position {
  final String signalId;
  final String symbol;
  final String direction;
  final double entryPrice;
  final double stopPrice;
  final double targetPrice;
  final int quantity;
  final double metaProba;
  final String status;
  final String date;

  Position.fromJson(Map<String, dynamic> j)
      : signalId = j['signal_id'] ?? '',
        symbol = j['symbol'] ?? '',
        direction = j['direction'] ?? '',
        entryPrice = (j['entry_price'] ?? 0).toDouble(),
        stopPrice = (j['stop_price'] ?? 0).toDouble(),
        targetPrice = (j['target_price'] ?? 0).toDouble(),
        quantity = j['quantity'] ?? 1,
        metaProba = (j['meta_proba'] ?? 0).toDouble(),
        status = j['status'] ?? '',
        date = j['date'] ?? '';
}
