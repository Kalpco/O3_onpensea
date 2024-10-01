import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchemeExplanationWidget extends StatelessWidget {
  const SchemeExplanationWidget(
      {super.key, required this.examples, required this.instructions});

  final List<String> examples;
  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How does the scheme work?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          StepMapWidget(instructions: instructions),
          const SizedBox(height: 8),
          ExampleMapWidget(
            examples: examples,
          )
        ],
      ),
    );
  }
}

class ExampleMapWidget extends StatelessWidget {
  const ExampleMapWidget({super.key, required this.examples});

  final List<String> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: examples.asMap().entries.map((example) {
        int index = example.key;
        return Text(
          example.value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: (index == 0) ? FontWeight.w700 : FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        );
      }).toList(),
    );
  }
}

class StepMapWidget extends StatelessWidget {
  const StepMapWidget({super.key, required this.instructions});

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.asMap().entries.map((instruction) {
        int index = instruction.key;
        return StepWidget(
          step: (index + 1).toString(),
          description: instruction.value,
        );
      }).toList(),
    );
  }
}

class StepWidget extends StatelessWidget {
  final String step;
  final String description;

  const StepWidget({super.key, required this.step, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
