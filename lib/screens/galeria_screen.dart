import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../db/database_helper.dart';
import '../models/galeria_item.dart';

class GaleriaScreen extends StatefulWidget {
  const GaleriaScreen({super.key});

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
  late Future<List<GaleriaItem>> _itemsFuture;
  final String autor = 'RA-7'; // Cambia según tu INICIALES-D

  @override
  void initState() {
    super.initState();
    _itemsFuture = DatabaseHelper.instance.getItemsByAutor(autor);
  }

  void _cargarDatos() async {
    await DatabaseHelper.instance.insertSampleData();
    setState(() {
      _itemsFuture = DatabaseHelper.instance.getItemsByAutor(autor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galería desde SQLite')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Autor: $autor', style: const TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: _cargarDatos,
            child: const Text('Cargar datos de ejemplo'),
          ),
          Expanded(
            child: FutureBuilder<List<GaleriaItem>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay registros para este autor'));
                } else {
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.titulo),
                          subtitle: Text(item.autor),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
