import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:to_do/pages/top_notifier.dart';
import 'package:to_do/pages/top_state.dart';

final topProvider =
    StateNotifierProvider<TopNotifier, TopState>((ref) => TopNotifier());
