import 'package:flutter/material.dart';
import '../../models/match_models.dart';

/// Prediction widget showing voting stats and predict button
class PredictionWidget extends StatelessWidget {
  final PredictionData prediction;
  final VoidCallback? onPredict;
  final Function(VoteOption)? onVote;

  const PredictionWidget({
    super.key,
    required this.prediction,
    this.onPredict,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1).withOpacity(0.2),
            const Color(0xFF8B5CF6).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Match Prediction',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_formatVotes(prediction.totalVotes)} votes',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Voting bars
          Row(
            children: [
              Expanded(child: _buildVoteOption('Home', prediction.homePercentage, Colors.blue, VoteOption.home)),
              const SizedBox(width: 8),
              Expanded(child: _buildVoteOption('Draw', prediction.drawPercentage, Colors.grey, VoteOption.draw)),
              const SizedBox(width: 8),
              Expanded(child: _buildVoteOption('Away', prediction.awayPercentage, Colors.red, VoteOption.away)),
            ],
          ),
          const SizedBox(height: 16),
          // User vote display or predict button based on voteEnabled
          if (prediction.userVote != null)
            _buildUserVoteDisplay()
          else if (prediction.voteEnabled)
            _buildPredictButton()
          else
            _buildDisabledMessage(),
        ],
      ),
    );
  }

  Widget _buildVoteOption(String label, double percentage, Color color, VoteOption option) {
    final isSelected = prediction.userVote?.option == option;

    return GestureDetector(
      onTap: () => onVote?.call(option),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.grey.shade800.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: isSelected ? color : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserVoteDisplay() {
    final vote = prediction.userVote!;
    String voteLabel;
    Color color;

    switch (vote.option) {
      case VoteOption.home:
        voteLabel = 'Home Win';
        color = Colors.blue;
        break;
      case VoteOption.draw:
        voteLabel = 'Draw';
        color = Colors.grey;
        break;
      case VoteOption.away:
        voteLabel = 'Away Win';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your prediction',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '$voteLabel ${vote.homeScore}-${vote.awayScore}',
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '💎',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vote.diamonds}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (prediction.voteEnabled) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onPredict,
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPredict,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sports_soccer, size: 20),
            SizedBox(width: 8),
            Text(
              'Predict & Bet 💎',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, color: Colors.grey.shade500, size: 16),
          const SizedBox(width: 8),
          Text(
            'Predictions closed',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatVotes(int votes) {
    if (votes >= 1000) {
      return '${(votes / 1000).toStringAsFixed(1)}k';
    }
    return votes.toString();
  }
}

