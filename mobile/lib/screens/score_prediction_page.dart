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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isUpdating ? Icons.edit : Icons.sports_soccer,
                          color: colorScheme.onPrimaryContainer,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isUpdating ? 'Update Prediction' : 'Make Prediction',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Team 1 Card
                  _buildTeamCard(
                    context,
                    teamName: widget.team1Name,
                    teamFlag: widget.team1Flag,
                    scoreController: _team1ScoreController,
                    isTeam1: true,
                  ),

                  // VS Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  colorScheme.outline.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'VS',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.outline.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Team 2 Card
                  _buildTeamCard(
                    context,
                    teamName: widget.team2Name,
                    teamFlag: widget.team2Flag,
                    scoreController: _team2ScoreController,
                    isTeam1: false,
                  ),

                  const SizedBox(height: 24),

                  // Diamonds Bet Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.tertiary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.diamond,
                              color: colorScheme.tertiary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Place Your Bet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _diamondsController,
                          decoration: InputDecoration(
                            labelText: 'Number of Diamonds',
                            prefixIcon: Icon(
                              Icons.diamond_outlined,
                              color: colorScheme.tertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: colorScheme.surface,
                            helperText: 'Minimum 1 diamond required',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final diamonds = int.tryParse(value);
                            if (diamonds == null || diamonds < 1) {
                              return 'Must be at least 1';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submit,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(_isUpdating ? Icons.check : Icons.send),
                          label: Text(
                            _isUpdating ? 'Update Prediction' : 'Submit',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context, {
    required String teamName,
    String? teamFlag,
    required TextEditingController scoreController,
    required bool isTeam1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Team Flag/Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: teamFlag != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      teamFlag,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.flag,
                          size: 40,
                          color: colorScheme.primary,
                        );
                      },
                    ),
                  )
                : Icon(Icons.flag, size: 40, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),

          // Team Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTeam1 ? 'Home' : 'Away',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teamName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Score Input
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: scoreController,
              decoration: InputDecoration(
                labelText: 'Score',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Req';
                }
                final score = int.tryParse(value);
                if (score == null || score < 0) {
                  return 'Invalid';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
