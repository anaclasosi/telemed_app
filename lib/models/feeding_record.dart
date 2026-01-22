/// Modelo de dados para registro de alimentação/amamentação
class FeedingRecord {
  final String type; // 'breastfeeding', 'bottle', 'formula'
  final String side; // 'left', 'right', 'both' ou vazio para mamadeira
  final int durationSeconds;
  final DateTime timestamp;
  final String babyMood; // 'happy', 'sick', 'crying'
  final double quality; // 0.0 a 5.0
  final List<String> symptoms;
  final String notes;

  FeedingRecord({
    required this.type,
    required this.side,
    required this.durationSeconds,
    required this.timestamp,
    required this.babyMood,
    required this.quality,
    required this.symptoms,
    required this.notes,
  });

  /// Converte o registro para um Map (útil para salvar em banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'side': side,
      'durationSeconds': durationSeconds,
      'timestamp': timestamp.toIso8601String(),
      'babyMood': babyMood,
      'quality': quality,
      'symptoms': symptoms,
      'notes': notes,
    };
  }

  /// Cria um registro a partir de um Map
  factory FeedingRecord.fromMap(Map<String, dynamic> map) {
    return FeedingRecord(
      type: map['type'],
      side: map['side'],
      durationSeconds: map['durationSeconds'],
      timestamp: DateTime.parse(map['timestamp']),
      babyMood: map['babyMood'],
      quality: map['quality'],
      symptoms: List<String>.from(map['symptoms']),
      notes: map['notes'],
    );
  }

  /// Retorna o tempo formatado em minutos e segundos
  String getFormattedDuration() {
    int minutes = durationSeconds ~/ 60;
    int seconds = durationSeconds % 60;
    return '${minutes}min ${seconds}s';
  }

  /// Retorna o nome amigável do tipo de alimentação
  String getTypeName() {
    switch (type) {
      case 'breastfeeding':
        return 'Peito (Direto)';
      case 'bottle':
        return 'Leite Materno (Mamadeira)';
      case 'formula':
        return 'Fórmula';
      default:
        return 'Desconhecido';
    }
  }
}
