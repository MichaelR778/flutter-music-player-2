import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewCubit extends Cubit<String> {
  PreviewCubit() : super('');

  // reset
  void reset() => emit('');

  // preview available
  void preview(String imageUrl) => emit(imageUrl);
}
