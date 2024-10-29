import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewState {
  final String imageUrl;
  PreviewState({required this.imageUrl});
}

class PreviewCubit extends Cubit<PreviewState> {
  PreviewCubit() : super(PreviewState(imageUrl: ''));

  // reset
  void reset() => emit(PreviewState(imageUrl: ''));

  // preview available
  void preview(String imageUrl) => emit(PreviewState(imageUrl: imageUrl));
}
