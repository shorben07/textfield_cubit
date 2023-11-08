import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textfield_cubit/counter/counter.dart';
import 'package:textfield_cubit/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatefulWidget {
  const CounterText({super.key});

  @override
  State<CounterText> createState() => _CounterTextState();
}

class _CounterTextState extends State<CounterText> {
  final _textController = TextEditingController();

  @override
  void initState() {
    final cubit = context.read<CounterCubit>();
    _textController
      ..text = cubit.state.toString()
      ..addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final cubit = context.read<CounterCubit>();
    final currentText = _textController.text;
    final newValue = int.tryParse(currentText);
    final currentValue = cubit.state;
    if (currentValue != newValue) {
      cubit.setValue(newValue);
    }
  }

  void _onStateChanged(int? value) {
    final newText = value != null ? value.toString() : '';
    final currentText = _textController.text;
    if (newText != currentText) {
      _textController.text = newText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<CounterCubit, int?>(
      listener: (context, state) {
        _onStateChanged(state);
      },
      child: TextField(
        controller: _textController,
        style: theme.textTheme.displayLarge,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>
        [FilteringTextInputFormatter.digitsOnly,],
      ),
    );
  }
}
