import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Notas',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 12, 12, 12),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 221, 171, 8),
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedLabelTextStyle: TextStyle(color: Colors.white),
          unselectedLabelTextStyle: TextStyle(color: Colors.grey),
        ),
        cardTheme: const CardTheme(
          color: Color.fromARGB(31, 124, 120, 120),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Nota> _notas = [];
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  // Datos del perfil (simulados)
  final String _nombreUsuario = "GeraldGG";
  final String _correoUsuario = "geraldmanuel052@gmail.com";

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _guardarNota(Nota nota) {
    setState(() {
      nota.titulo = _tituloController.text;
      nota.contenido = _contenidoController.text;

      _tituloController.clear();
      _contenidoController.clear();
    });
    Navigator.pop(context);
  }

  void _guardarNuevaNota() {
    if (_tituloController.text.isNotEmpty &&
        _contenidoController.text.isNotEmpty) {
      setState(() {
        final nuevaNota = Nota(
          titulo: _tituloController.text,
          contenido: _contenidoController.text,
          fechaCreacion: DateTime.now(),
        );
        _notas.add(nuevaNota);

        // Limpiar los campos de texto después de guardar
        _tituloController.clear();
        _contenidoController.clear();
      });
    }
  }

  void _eliminarNota(int index) {
    setState(() {
      _notas.removeAt(index);
    });
  }

  void _mostrarDetalleNota(Nota nota) {
    _tituloController.text = nota.titulo;
    _contenidoController.text = nota.contenido;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextFormField(
                  controller: _contenidoController,
                  decoration: const InputDecoration(labelText: 'Contenido'),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () => _guardarNota(nota),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas'),
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: screenWidth >= 800,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.notes),
                label: Text('Notas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add),
                label: Text('Nueva Nota'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Perfil'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildPanel(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(int index) {
    switch (index) {
      case 0:
        return _panelNotas();
      case 1:
        return _panelNuevaNota();
      case 2:
        return _panelPerfil();
      default:
        return const Center(child: Text('Selecciona una opción'));
    }
  }

  Widget _panelNotas() {
    return ListView.builder(
      itemCount: _notas.length,
      itemBuilder: (context, index) {
        final nota = _notas[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(nota.titulo),
            subtitle: Text(
              nota.contenido.length > 50
                  ? '${nota.contenido.substring(0, 50)}...'
                  : nota.contenido,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _eliminarNota(index),
            ),
            onTap: () {
              _mostrarDetalleNota(nota);
            },
          ),
        );
      },
    );
  }

  Widget _panelNuevaNota() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _contenidoController,
            decoration: const InputDecoration(
              labelText: 'Contenido',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _guardarNuevaNota(),
            child: const Text('Guardar Nota'),
          ),
        ],
      ),
    );
  }

  Widget _panelPerfil() {
    DateTime? ultimaActividad;

    if (_notas.isNotEmpty) {
      _notas.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      ultimaActividad = _notas.first.fechaCreacion;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Icon(Icons.account_circle, size: 72),
                const SizedBox(height: 8),
                Text(
                  _nombreUsuario,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  _correoUsuario,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total de notas: ${_notas.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Última actividad: ${ultimaActividad != null
                        ? DateFormat('dd/MM/yyyy').format(ultimaActividad)
                        : 'Ninguna'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Nota {
  String titulo;
  String contenido;
  DateTime fechaCreacion;

  Nota({required this.titulo, required this.contenido, required this.fechaCreacion});
}

