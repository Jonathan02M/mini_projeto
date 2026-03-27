import 'package:flutter/material.dart';
import '../models/habito.dart';

class HabitDetailsScreen extends StatelessWidget {
  final Habito habito;

  const HabitDetailsScreen({super.key, required this.habito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(habito.titulo,
                style: const TextStyle(fontSize: 24)),
            Text(habito.descricao),
            Text(" ${habito.streak} pontos"),
          ],
        ),
      ),
    );
  }
}