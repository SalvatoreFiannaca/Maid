import 'package:flutter/material.dart';
import 'package:maid/classes/providers/huggingface_selection.dart';
import 'package:maid/classes/providers/large_language_models/llama_cpp_model.dart';
import 'package:maid/ui/desktop/dropdowns/huggingface_model_dropdown.dart';
import 'package:provider/provider.dart';

class HuggingfaceDialog extends StatelessWidget {
  const HuggingfaceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select HuggingFace Model',
        textAlign: TextAlign.center
      ),
      content: const HuggingfaceModelDropdown(),
      actions: [
        buildButton(),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Close"
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Widget buildButton() {
    return Consumer<HuggingfaceSelection>(
      builder: (context, huggingfaceSelection, child) {
        return FutureBuilder(
          future: huggingfaceSelection.alreadyExists, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FilledButton(
                onPressed: () {
                  final future = HuggingfaceSelection.of(context).download();
                  LlamaCppModel.of(context).setModelWithFuture(future);
                  Navigator.of(context).pop();
                },
                child: Text(
                  (snapshot.data as bool) ? "Select" : "Download"
                ),
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}