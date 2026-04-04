extension DateTimeFormatX on DateTime {
  /// Returns a compact relative label: 2m · 4h · 3d · DD/MM
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '$day/$month';
  }
}
