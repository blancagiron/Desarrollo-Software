import 'package:flutter/material.dart';
import '../contexto.dart';
import '../estrategias/falcon_strategy.dart';
import '../estrategias/facebook_blenderbot.dart';
import '../estrategias/flant5_strategy.dart';
import '../estrategias/phi3mini_strategy.dart';

class LLMSelectorScreen extends StatefulWidget {
  const LLMSelectorScreen({super.key});

  @override
  _LLMSelectorScreenState createState() => _LLMSelectorScreenState();
}

class _LLMSelectorScreenState extends State<LLMSelectorScreen> {
  final TextEditingController _controller = TextEditingController();


  late Contexto _contexto; // Se crea una instancia de Contexto con estrategia predeterminada
  String _modeloSeleccionado = 'Falcon'; // Estrategia inicialmente seleccionada
  String _respuesta = '';
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _mostrarFormato = true;

  // Pequeñas descripciones de los modelos
  final Map<String, String> _modelDescriptions = {
    'Falcon': 'Un modelo de 7B parámetros capaz de generar respuestas de propósito general. Las respuestas que da pueden estar desactualizadas',
    'FBB': 'Chatbot de dominio abierto desarrollado por Facebook AI.',
    'FLAN': 'Modelo FLAN-T5 especializado en seguir instrucciones y responder preguntas.',
    'PHI3': 'Modelo pequeño de 3.8B parámetros con buena relación tamaño/rendimiento para tareas sencillas.'
  };

  // Formatos de prompt para cada modelo
  final Map<String, String> _promptFormats = {
    'Falcon': '• En inglés\n• Formula el prompt como si fuese una pregunta, del tipo "who", "where", "what", "which"\n• Finaliza con "?"',
    'FBB': '• En inglés\n• Usa prompts cortos\n• Usa preguntas',
    'FLAN': '• Estructura las preguntas en formato de instrucción clara, mejor en inglés\n• Question: bla bla bla ? | Instruction: bla bla bla',
    'PHI3': '<|system|>\nYou are a helpful assistant.\n<|end|>\n<|user|>\n[Tu pregunta aquí]\n<|end|>\n<|assistant|>'
  };

  @override
  void initState() {
    super.initState();
    _contexto = Contexto(Falcon7bStrategy());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _cambiarEstrategia(String modelo) { // Cuando un usuario en la UI selecciona una estrategia distinta se utiliza el método setStrategy() de Contexto para cambiar la estragia
    setState(() {
      _modeloSeleccionado = modelo;
      switch (modelo) {
        case 'Falcon':
          _contexto.setStrategy(Falcon7bStrategy());
          break;
        case 'PHI3':
          _contexto.setStrategy(Phi3miniStrategy());
          break;
        case 'FLAN':
          _contexto.setStrategy(Flant5Strategy());
          break;
        case 'FBB':
          _contexto.setStrategy(FacebookBlenderbotStrategy());
          break;
      }
      // Si se cambia de estrategia se muestra el modelo para esa estrategia:
      _mostrarFormato = true;
    });
  }

  void _toggleMostrarFormato() {
    setState(() {
      _mostrarFormato = !_mostrarFormato;
    });
  }

  void _usarFormato() {
    // Para PHI3, usar el formato completo
    if (_modeloSeleccionado == 'PHI3') {
      _controller.text = '<|system|>\nYou are a helpful assistant.\n<|end|>\n<|user|>\n[Tu pregunta aquí]\n<|end|>\n<|assistant|>';
    } else {
      // Para los demás, no aplicar formato, solo dar un ejemplo
      _controller.text = '';
    }

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    // Ocultar el panel de formato después de usarlo
    setState(() {
      _mostrarFormato = false;
    });
  }

  void _enviarMensaje() async { // Cuando se envía un mensaje -> Contexto delega la tarea a la estrategia activa:
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _respuesta = 'Cargando respuesta...';
    });

    try {
      final respuesta = await _contexto.delegarTrabajo(_controller.text);
      setState(() {
        _respuesta = respuesta;
      });

      // UI se actualice
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

    } catch (e) {
      setState(() {
        _respuesta = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _limpiarRespuesta() {
    setState(() {
      _respuesta = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de LLM - Hugging Face'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Usar ListView en lugar de Column para evitar overflows
          child: ListView(
            children: [
              // Modelo selector card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona un modelo:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _modeloSeleccionado,
                        isExpanded: true,
                        onChanged: (value) => _cambiarEstrategia(value!),
                        items: const [
                          DropdownMenuItem(
                            value: 'Falcon',
                            child: Text('Falcon'),
                          ),
                          DropdownMenuItem(
                            value: 'FBB',
                            child: Text('Facebook Blender Bot'),
                          ),
                          DropdownMenuItem(
                            value: 'FLAN',
                            child: Text('FLAN-T5'),
                          ),
                          DropdownMenuItem(
                            value: 'PHI3',
                            child: Text('PHI3'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _modelDescriptions[_modeloSeleccionado] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _mostrarFormato ? Icons.format_quote : Icons.format_quote_outlined,
                              color: _mostrarFormato ? Colors.blue : Colors.grey,
                            ),
                            onPressed: _toggleMostrarFormato,
                            tooltip: 'Formato de prompt',
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Widget de formato de prompt
              if (_mostrarFormato)
                Card(
                  elevation: 2,
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.format_quote, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Formato para $_modeloSeleccionado',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            if (_modeloSeleccionado == 'PHI3')
                              TextButton(
                                onPressed: _usarFormato,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Usar'),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: _toggleMostrarFormato,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: SelectableText(
                            _promptFormats[_modeloSeleccionado] ?? '',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Input message card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mensaje:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Escribe tu mensaje aquí',
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _enviarMensaje,
                              child: _isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Text('Enviar'),
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                });
                              },
                              tooltip: 'Limpiar mensaje',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Response card
              if (_respuesta.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with controls
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Respuesta de ${_contexto.estrategia.nombreModelo()}:',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Controls for response
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: _limpiarRespuesta,
                              tooltip: 'Limpiar respuesta',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      const Divider(height: 1, thickness: 1),

                      // Response area
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: SelectableText(
                            _respuesta,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}