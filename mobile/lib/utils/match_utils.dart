class MatchUtils {
  static const String statusLive = 'LIVE';
  static const String statusHT = 'HT';
  static const String statusFT = 'FT';
  static const String statusScheduled = 'SCHEDULED';

  static StatusParseResult parseStatus(String eventStatus, String eventLive) {
    String status = statusScheduled;
    int minute = 0;
    bool isLive = false;

    if (eventLive == '1') {
      isLive = true;
      if (eventStatus == 'Half Time') {
        status = statusHT;
      } else {
        status = statusLive;
        minute = _parseMinuteString(eventStatus);
      }
    } else if (eventStatus == 'Finished') {
      status = statusFT;
    } else if (eventLive == '0' && (eventStatus == 'FT' || eventStatus == 'After ET' || eventStatus == 'AET')) {
       status = statusFT;
    } else {
      // If status has minutes but live is 0? usually finished or not started (but usually empty if not started)
      // Safest is scheduled unless stated otherwise
      // Or maybe check if it looks like a time
    }

    // Fallback for direct minute strings in status (just in case API varies)
    if (status == statusLive && minute == 0) {
       minute = _parseMinuteString(eventStatus);
    }

    return StatusParseResult(status: status, minute: minute, isLive: isLive);
  }

  static int _parseMinuteString(String timeStr) {
    if (timeStr.isEmpty) return 0;
    // Remove ' char
    String clean = timeStr.replaceAll("'", '').trim();
    if (clean.contains('+')) {
      final parts = clean.split('+');
      final base = int.tryParse(parts[0].trim()) ?? 0;
      final added = int.tryParse(parts[1].trim()) ?? 0;
      return base + added;
    }
    return int.tryParse(clean) ?? 0;
  }
}

class StatusParseResult {
  final String status;
  final int minute;
  final bool isLive;

  StatusParseResult({
    required this.status,
    required this.minute,
    required this.isLive,
  });
}

