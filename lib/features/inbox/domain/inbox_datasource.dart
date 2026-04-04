import '../../../core/domain/email.dart';

// ── EmailModel ────────────────────────────────────────────────────────────────

class EmailModel extends Email {
  const EmailModel({
    required super.id,
    required super.sender,
    required super.senderEmail,
    required super.subject,
    required super.preview,
    required super.body,
    required super.timestamp,
    super.isRead,
  });

  EmailModel copyWithRead({required bool isRead}) => EmailModel(
        id: id,
        sender: sender,
        senderEmail: senderEmail,
        subject: subject,
        preview: preview,
        body: body,
        timestamp: timestamp,
        isRead: isRead,
      );
}

// ── Mock data ─────────────────────────────────────────────────────────────────

final kMockInboxEmails = <EmailModel>[
  EmailModel(
    id: 'e1',
    sender: 'GitHub',
    senderEmail: 'noreply@github.com',
    subject: 'Your pull request was merged',
    preview: 'PR #42 "Add authentication flow" has been merged into main.',
    body: 'Your pull request #42 "Add authentication flow" has been merged into main.\n\nView the changes on GitHub to see what was included.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  EmailModel(
    id: 'e2',
    sender: 'Figma',
    senderEmail: 'notifications@figma.com',
    subject: 'New comment on your design',
    preview: 'Alex left a comment: "Love the new nav bar treatment!"',
    body: 'Alex left a comment on your file "Messenger App":\n\n"Love the new nav bar treatment!"\n\nOpen Figma to reply.',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  EmailModel(
    id: 'e3',
    sender: 'Notion',
    senderEmail: 'no-reply@mail.notion.so',
    subject: 'Weekly digest: 5 updates in shared pages',
    preview: 'Your team made 5 updates to shared pages this week.',
    body: 'Activity summary:\n\n• Product Roadmap — 3 edits\n• API Docs — 1 edit\n• Design Tokens — 1 edit',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: true,
  ),
  EmailModel(
    id: 'e4',
    sender: 'Stripe',
    senderEmail: 'receipts@stripe.com',
    subject: 'Your invoice from Stripe',
    preview: 'Invoice #INV-0047 for \$29.00 is now available.',
    body: 'Thank you for your payment.\n\nInvoice #INV-0047\nAmount: \$29.00\nDate: April 1, 2026',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
  EmailModel(
    id: 'e5',
    sender: 'Sarah Kim',
    senderEmail: 'sarah.kim@example.com',
    subject: 'Re: Project kickoff',
    preview: "Monday at 10am works great. I'll send a calendar invite shortly.",
    body: "Hi Chris,\n\nMonday at 10am works great. I'll send a calendar invite shortly.\n\nSarah",
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

final kMockSentEmails = <EmailModel>[
  EmailModel(
    id: 's1',
    sender: 'Me',
    senderEmail: 'chris@example.com',
    subject: 'Re: Project kickoff',
    preview: 'Hey Sarah, does Monday at 10am work for you?',
    body: 'Hey Sarah,\n\nDoes Monday at 10am work for you for the project kickoff?\n\nChris',
    timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
    isRead: true,
  ),
  EmailModel(
    id: 's2',
    sender: 'Me',
    senderEmail: 'chris@example.com',
    subject: 'Design feedback — updated mockups',
    preview: 'Updated the mockups based on your notes. Link inside.',
    body: 'Thanks for the review!\n\nUpdated the mockups based on your notes.\n\nhttps://figma.com/file/...',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
  ),
];

final kMockDraftEmails = <EmailModel>[
  EmailModel(
    id: 'd1',
    sender: 'Me',
    senderEmail: 'chris@example.com',
    subject: 'Q2 roadmap thoughts',
    preview: "Here are some ideas I've been thinking about for Q2...",
    body: "Here are some ideas I've been thinking about for Q2:\n\n1. ",
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    isRead: true,
  ),
];

// ── InboxDatasource ───────────────────────────────────────────────────────────

class InboxDatasource {
  final List<EmailModel> _emails = List.of(kMockInboxEmails);

  Future<List<EmailModel>> getInbox() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_emails);
  }

  Future<List<EmailModel>> getSent() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(kMockSentEmails);
  }

  Future<List<EmailModel>> getDrafts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(kMockDraftEmails);
  }

  Future<EmailModel> markRead({required String id, required bool isRead}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _emails.indexWhere((e) => e.id == id);
    if (index == -1) throw Exception('Email not found: $id');
    final updated = _emails[index].copyWithRead(isRead: isRead);
    _emails[index] = updated;
    return updated;
  }

  Future<void> deleteEmail(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _emails.removeWhere((e) => e.id == id);
  }
}
