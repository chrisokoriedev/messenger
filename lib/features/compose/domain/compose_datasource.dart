import '../../inbox/domain/inbox_datasource.dart';

class ComposeDatasource {
  Future<EmailModel> send({
    required List<String> recipients,
    required String subject,
    required String body,
    required String senderEmail,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return EmailModel(
      id: 'sent_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'Me',
      senderEmail: senderEmail,
      subject: subject,
      preview: body.length > 80 ? '${body.substring(0, 80)}…' : body,
      body: body,
      timestamp: DateTime.now(),
      isRead: true,
    );
  }
}
