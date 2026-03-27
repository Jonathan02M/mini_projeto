import 'package:flutter/material.dart';
import '../models/habito.dart';

class StatsScreen extends StatelessWidget {
  final List<Habito> habitos;

  const StatsScreen({super.key, required this.habitos});

  int get totalPontos =>
      habitos.fold(0, (total, h) => total + h.streak);

  int get concluidos =>
      habitos.where((h) => h.concluido).length;

  double get progresso =>
      habitos.isEmpty ? 0 : concluidos / habitos.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 60, bottom: 30, left: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Seu progresso",
                    style: TextStyle(color: Colors.white70)),
                Text("$totalPontos ",
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: progresso),
                Text("${(progresso * 100).toInt()}%"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, i) {
                final h = habitos[i];
                return ListTile(
                  title: Text(h.titulo),
                  subtitle: Text(" ${h.streak} pontos"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}