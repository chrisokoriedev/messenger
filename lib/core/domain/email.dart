class Email {
  final String id;
  final String sender;
  final String senderEmail;
  final String subject;
  final String preview;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final bool isTrashed;
  final DateTime? trashedAt;

  const Email({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.subject,
    required this.preview,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.isTrashed = false,
    this.trashedAt,
  });

  Email copyWith({
    String? id,
    String? sender,
    String? senderEmail,
    String? subject,
    String? preview,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    bool? isTrashed,
    DateTime? trashedAt,
  }) {
    return Email(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderEmail: senderEmail ?? this.senderEmail,
      subject: subject ?? this.subject,
      preview: preview ?? this.preview,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isTrashed: isTrashed ?? this.isTrashed,
      trashedAt: trashedAt ?? this.trashedAt,
    );
  }
}
