import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_data_store.dart';

final mockDataStoreProvider = ChangeNotifierProvider<MockDataStore>((ref) {
  return MockDataStore();
});
