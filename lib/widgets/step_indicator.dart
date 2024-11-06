import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> titles;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [];

    for (int i = 1; i <= totalSteps; i++) {
      steps.add(_buildStepCircle(i, titles[i - 1], currentStep >= i));
      if (i < totalSteps) {
        steps.add(_buildStepLine(context));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: steps,
    );
  }

  Widget _buildStepCircle(int stepNumber, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isActive ? Colors.green : Colors.grey,
            child: Text(
              '$stepNumber',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center, // Center the text below CircleAvatar
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(BuildContext context) {
    return Flexible(
      child: Container(
        height: 2,
        color: Colors.grey,
      ),
    );
  }
}
