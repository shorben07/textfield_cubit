import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int?> {
  CounterCubit() : super(0);

  void increment() => emit((state ?? 0) + 1);
  void decrement() => emit((state ?? 0) - 1);
  void setValue(int? value) => emit(value);
}
