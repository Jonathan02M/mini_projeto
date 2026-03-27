import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';
import 'habit_details_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habito> habitos = [];

  @override
  void initState() {
    super.initState();
    carregarHabitos();
  }

  double get progresso {
    if (habitos.isEmpty) return 0;
    int concluidos = habitos.where((h) => h.concluido).length;
    return concluidos / habitos.length;
  }

  Future<void> salvarHabitos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('habitos', Habito.encode(habitos));
  }

  Future<void> carregarHabitos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('habitos');

    if (data != null) {
      setState(() {
        habitos = Habito.decode(data);
      });
    } else {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        habitos = [
          Habito(titulo: "Beber água", descricao: "2L por dia"),
          Habito(titulo: "Estudar", descricao: "Flutter 1h"),
        ];
      });
    }
  }

  void adicionarHabito(String titulo, String descricao) {
    setState(() {
      habitos.add(Habito(titulo: titulo, descricao: descricao));
    });
    salvarHabitos();
  }

  void deletarHabito(int index) {
    setState(() {
      habitos.removeAt(index);
    });
    salvarHabitos();
  }

  void toggleHabito(int index, bool value) {
    setState(() {
      habitos[index].concluido = value;
      if (value) {
        habitos[index].streak++;
      } else {
        habitos[index].streak = 0;
      }
    });

    salvarHabitos();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value
            ? "Hábito concluído! "
            : "Hábito desmarcado"),
      ),
    );
  }

  void mostrarDialogo() {
    String titulo = '';
    String descricao = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Novo Hábito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Título"),
                onChanged: (value) => titulo = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Descrição"),
                onChanged: (value) => descricao = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Adicionar"),
              onPressed: () {
                if (titulo.isNotEmpty) {
                  adicionarHabito(titulo, descricao);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void abrirDetalhes(Habito habito) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitDetailsScreen(habito: habito),
      ),
    );
  }

  void abrirStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatsScreen(habitos: habitos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Hábitos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: abrirStats,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: mostrarDialogo,
        icon: const Icon(Icons.add),
        label: const Text("Novo hábito"),
      ),
      body: habitos.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80),
                  SizedBox(height: 10),
                  Text("Nenhum hábito ainda"),
                  Text("Clique no + para começar "),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Seu progresso hoje",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: progresso),
                      const SizedBox(height: 5),
                      Text("${(progresso * 100).toInt()}%"),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: habitos.length,
                    itemBuilder: (context, index) {
                      final h = habitos[index];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: h.concluido
                              ? Colors.green.withOpacity(0.2)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            h.titulo,
                            style: TextStyle(
                              decoration: h.concluido
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle:
                              Text("${h.descricao}\n ${h.streak} pontos"),
                          leading: Checkbox(
                            value: h.concluido,
                            onChanged: (v) => toggleHabito(index, v!),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () => deletarHabito(index),
                          ),
                          onTap: () => abrirDetalhes(h),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}