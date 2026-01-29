import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:mobile/providers/api_providers.dart';

class ScorePredictionDialog extends ConsumerStatefulWidget {
  final String team1Name;
  final String team2Name;
  final String? team1Flag;
  final String? team2Flag;
  final int? score1;
  final int? score2;
  final String matchId;

  const ScorePredictionDialog({
    super.key,
    required this.team1Name,
    required this.team2Name,
    this.team1Flag,
    this.team2Flag,
    this.score1,
    this.score2,
    required this.matchId,
  });

  @override
  ConsumerState<ScorePredictionDialog> createState() =>
      _ScorePredictionDialogState();
}

class _ScorePredictionDialogState extends ConsumerState<ScorePredictionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _team1ScoreController = TextEditingController();
  final _team2ScoreController = TextEditingController();
  final _diamondsController = TextEditingController();

  bool _isUpdating = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isUpdating = widget.score1 != null && widget.score2 != null;
    if (_isUpdating) {
      _team1ScoreController.text = widget.score1.toString();
      _team2ScoreController.text = widget.score2.toString();
    }
    _diamondsController.text = '1';
  }

  @override
  void dispose() {
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    _diamondsController.dispose();
    super.dispose();
  }

  Future<String?> _validateDiamondsOnSubmit() async {
    final value = _diamondsController.text;
    if (value.isEmpty) {
      return 'Please enter number of diamonds';
    }
    final diamonds = int.tryParse(value);
    if (diamonds == null || diamonds < 1) {
      return 'Must be at least 1';
    }

    final requestedDiamonds = diamonds;
    final diamondsNeeded = _isUpdating
        ? 0
        : requestedDiamonds; // For updating, skip check for now

    if (diamondsNeeded <= 0) {
      return null; // No validation needed
    }
    print('-------------------------');
    try {
      final dio = ref.read(dioProvider);
      final response = await dio
          .post(
            '/matches/can-predict/${widget.matchId}',
            data: {'numberOfDiamondsBet': diamondsNeeded},
          )
          .timeout(const Duration(seconds: 30));
      print(
        'Can predict response data: ${response.data} (type: ${response.data.runtimeType})',
      );

      // Handle different response types
      bool canPredictBool;
      final data = response.data;
      if (data == true || data == 'true') {
        canPredictBool = true;
      } else if (data == false || data == 'false') {
        canPredictBool = false;
      } else {
        canPredictBool = false; // Default to false if unknown value
      }

      print('Parsed canPredictBool: $canPredictBool');

      if (canPredictBool) {
        return null;
      } else {
        return 'Insufficient diamonds';
      }
    } catch (e) {
      print('Error validating diamonds: $e');
      return 'Error validating diamonds';
    }
  }

  Future<void> _submit() async {
    print('_submit called');
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      _showSnackBar('Please fix the errors in the form');
      return;
    }
    print('Form validation passed');

    final diamondError = await _validateDiamondsOnSubmit();
    if (diamondError != null) {
      print('Diamond validation failed: $diamondError');
      _showSnackBar(diamondError);
      return;
    }
    print('Diamond validation passed');

    setState(() => _isLoading = true);

    try {
      final matchesApi = ref.read(matchesApiProvider);
      final team1Score = int.parse(_team1ScoreController.text);
      final team2Score = int.parse(_team2ScoreController.text);
      final diamonds = int.parse(_diamondsController.text);

      print(
        'Parsed values - team1Score: $team1Score, team2Score: $team2Score, diamonds: $diamonds, matchId: ${widget.matchId}',
      );

      if (_isUpdating) {
        print('Updating prediction...');
        final dio = ref.read(dioProvider);
        await dio
            .patch(
              '/matches/${widget.matchId}/prediction',
              data: {
                'scoreFirst': team1Score,
                'scoreSecond': team2Score,
                'numberOfDiamondsBet': diamonds,
              },
            )
            .timeout(const Duration(seconds: 30));
        _showSnackBar('Prediction updated successfully!');
      } else {
        print('Making new prediction...');
        final dio = ref.read(dioProvider);
        await dio
            .post(
              '/matches/${widget.matchId}/predict',
              data: {
                'scoreFirst': team1Score,
                'scoreSecond': team2Score,
                'numberOfDiamondsBet': diamonds,
              },
            )
            .timeout(const Duration(seconds: 30));
        _showSnackBar('Prediction saved successfully!');
      }

      // Return the prediction data
      final predictionData = {
        'team1Score': team1Score,
        'team2Score': team2Score,
        'matchId': widget.matchId,
        'numberOfDiamonds': diamonds,
        'isUpdating': _isUpdating,
      };

      print('Popping dialog with data: $predictionData');
      if (mounted) {
        Navigator.of(context).pop(predictionData);
      }
    } catch (e) {
      print('Error submitting prediction: $e');
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      print('Finally block executed, resetting loading state');
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isUpdating ? 'Update Prediction' : 'Make Prediction'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Team 1
              Row(
                children: [
                  if (widget.team1Flag != null)
                    Image.network(widget.team1Flag!, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.team1Name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _team1ScoreController,
                      decoration: const InputDecoration(labelText: 'Score'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final score = int.tryParse(value);
                        if (score == null || score < 0) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Team 2
              Row(
                children: [
                  if (widget.team2Flag != null)
                    Image.network(widget.team2Flag!, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.team2Name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _team2ScoreController,
                      decoration: const InputDecoration(labelText: 'Score'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final score = int.tryParse(value);
                        if (score == null || score < 0) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Diamonds
              TextFormField(
                controller: _diamondsController,
                decoration: const InputDecoration(labelText: 'Diamonds to bet'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final diamonds = int.tryParse(value);
                  if (diamonds == null || diamonds < 1) return 'Min 1';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isUpdating ? 'Update' : 'Submit'),
        ),
      ],
    );
  }
}
