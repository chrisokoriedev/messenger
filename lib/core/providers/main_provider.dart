import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/auth_datasource.dart';
import '../../features/inbox/inbox_datasource.dart';

final authDatasourceProvider = Provider<AuthDatasource>(
  (ref) => AuthDatasource(),
);

final inboxDatasourceProvider = Provider<InboxDatasource>(
  (ref) => InboxDatasource(),
);
