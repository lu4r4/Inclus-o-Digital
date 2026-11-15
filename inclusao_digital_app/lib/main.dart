import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/tutorial_model.dart';
import 'services/tutorial_service.dart';
import 'widgets/tutorial_card_widget.dart';

void main() {
  runApp(const InclusaoDigitalApp());
}

class InclusaoDigitalApp extends StatelessWidget {
  const InclusaoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inclusão Digital - Apoio à Comunidade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LocaisPage(),
    const TutorialsHomePage(),
    const CadastroIdosoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 16,
        unselectedFontSize: 14,
        iconSize: 32,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Tutoriais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Cadastro',
          ),
        ],
      ),
    );
  }
}


class LocaisPage extends StatefulWidget {
  const LocaisPage({super.key});

  @override
  State<LocaisPage> createState() => _LocaisPageState();
}

class _LocaisPageState extends State<LocaisPage> {
  final String apiUrl = 'https://legendary-space-eureka-pxxpgvq7jwv26wq6-8080.app.github.dev/api/places';
  List<dynamic> locais = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarLocais();
  }

  Future<void> buscarLocais() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          locais = jsonDecode(response.body);
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        locais = [
          {
            "name": "Centro de Inclusão Digital - Matriz",
            "address": "Rua XV de Novembro, 1200 - Centro"
          },
          {
            "name": "Farol do Saber e Inovação Comunitário",
            "address": "Rua Mateus Leme, 4500 - Santo Antônio"
          },
          {
            "name": "Biblioteca Pública de Bairro - Polo Norte",
            "address": "Rua da Cidadania Boa Vista, 250 - Boa Vista"
          }
        ];
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locais para Estudos Presenciais'),
        centerTitle: true,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : locais.isEmpty
              ? const Center(child: Text('Nenhum local encontrado.'))
              : ListView.builder(
                  itemCount: locais.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final local = locais[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school, color: Colors.blueAccent, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    local['name'] ?? 'Local de Estudo',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.place, color: Colors.redAccent, size: 22),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Endereço: ${local['address'] ?? 'Não informado'}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aulas presenciais e apoio digital gratuito para idosos.',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


class TutorialsHomePage extends StatefulWidget {
  const TutorialsHomePage({super.key});

  @override
  State<TutorialsHomePage> createState() => _TutorialsHomePageState();
}

class _TutorialsHomePageState extends State<TutorialsHomePage> {
  late Future<List<Tutorial>> futureTutorials;

  @override
  void initState() {
    super.initState();
    futureTutorials = fetchCustomTutorials();
  }

  Future<List<Tutorial>> fetchCustomTutorials() async {
    try {
      final serviceTutorials = await TutorialService().fetchTutorials();
      final List<Tutorial> extras = [
        Tutorial(
          id: 101,
          title: 'Como Chamar uma Ambulância (SAMU 192)',
          description: 'Passo a passo de emergência: Como discar o 192, informar o endereço correto da rua e pedir socorro médico rápido.',
        ),
        Tutorial(
          id: 102,
          title: 'Como Utilizar o Aplicativo Gov.br',
          description: 'Aprenda a criar a sua conta unificada do governo, recuperar senha e aceder a documentos digitais com segurança.',
        ),
        Tutorial(
          id: 103,
          title: 'Como Utilizar o Aplicativo Saúde Já',
          description: 'Guia simples para marcar consultas nos postos de saúde, ver carteira de vacinação e acompanhar exames pelo telemóvel.',
        ),
      ];
      return [...serviceTutorials, ...extras];
    } catch (e) {
      return [
        Tutorial(
          id: 1,
          title: 'Como Chamar uma Ambulância (SAMU 192)',
          description: 'Passo a passo de emergência: Como discar o 192 e informar o endereço exato.',
        ),
        Tutorial(
          id: 2,
          title: 'Como Utilizar o Aplicativo Gov.br',
          description: 'Aceda a serviços do governo e documentos de forma simples e segura.',
        ),
        Tutorial(
          id: 3,
          title: 'Como Utilizar o Aplicativo Saúde Já',
          description: 'Marque consultas e verifique o seu histórico de saúde no posto.',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutoriais - Passo a Passo'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Tutorial>>(
        future: futureTutorials,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar tutoriais:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum tutorial encontrado.'));
          }

          final tutorials = snapshot.data!;
          return ListView.builder(
            itemCount: tutorials.length,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemBuilder: (context, index) {
              final tutorial = tutorials[index];
              return TutorialCardWidget(
                tutorial: tutorial,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(tutorial.title),
                      content: Text(
                        tutorial.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CadastroIdosoPage extends StatefulWidget {
  const CadastroIdosoPage({super.key});

  @override
  State<CadastroIdosoPage> createState() => _CadastroIdosoPageState();
}

class _CadastroIdosoPageState extends State<CadastroIdosoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  String _cursoSelecionado = 'Inclusão Digital Básica e WhatsApp';

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inscrição Realizada com Sucesso!'),
          content: Text(
            'Parabéns, ${_nomeController.text}!\nO seu cadastro para as aulas presenciais foi registado.\nEm breve entraremos em contato.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nomeController.clear();
                _telefoneController.clear();
                _enderecoController.clear();
              },
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro para Aulas Presenciais'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencha os seus dados para garantir a sua vaga nas aulas presenciais de informática e cidadania digital:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomeController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, size: 28),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Telefone / WhatsApp',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, size: 28),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o seu telefone.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _enderecoController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Endereço / Rua e Bairro',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home, size: 28),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o seu endereço.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _cursoSelecionado,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Escolha a Aula / Curso',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book, size: 28),
                ),
                items: <String>[
                  'Inclusão Digital Básica e WhatsApp',
                  'Como Usar o Aplicativo Gov.br',
                  'Como Usar o Aplicativo Saúde Já',
                  'Segurança na Internet para Idosos'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cursoSelecionado = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[800],
                ),
                child: const Text(
                  'Confirmar Inscrição',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}