import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerbase/features/google_drive/data/datasource/google_drive_remote_datasource.dart';
import 'package:flutter_boilerbase/features/google_drive/data/repository/google_drive_repository_impl.dart';
import 'package:flutter_boilerbase/features/google_drive/domain/entities/drive_file.dart';
import 'package:flutter_boilerbase/features/google_drive/domain/repository/google_drive_repository.dart';

final googleDriveDataSourceProvider = Provider<GoogleDriveRemoteDataSource>((ref) {
  return GoogleDriveRemoteDataSource();
});

final googleDriveRepositoryProvider = Provider<GoogleDriveRepository>((ref) {
  final dataSource = ref.watch(googleDriveDataSourceProvider);
  return GoogleDriveRepositoryImpl(dataSource);
});

final driveFilesProvider = FutureProvider.autoDispose<List<DriveFile>>((ref) async {
  final repository = ref.watch(googleDriveRepositoryProvider);
  return repository.listDocuments();
});

final uploadProgressProvider = StateProvider.autoDispose<double?>((ref) => null);

final downloadProgressProvider = StateNotifierProvider.autoDispose<DownloadProgressNotifier, Map<String, double>>((ref) {
  return DownloadProgressNotifier();
});

class DownloadProgressNotifier extends StateNotifier<Map<String, double>> {
  DownloadProgressNotifier() : super({});

  void updateProgress(String id, double progress) {
    state = {...state, id: progress};
  }

  void clearProgress(String id) {
    final newState = Map<String, double>.from(state);
    newState.remove(id);
    state = newState;
  }
}
