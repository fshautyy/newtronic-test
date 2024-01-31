import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TabEvent {}

class ChangeTabEvent extends TabEvent {
  final int index;

  ChangeTabEvent(this.index);
}

class TabState {
  final int index;
  TabState(this.index);
}

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabState(0)) {
    on<ChangeTabEvent>((event, emit) async {
      emit(TabState(event.index));
    });
  }
}
