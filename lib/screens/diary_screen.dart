import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/feeding_record.dart';

/// Tela de Diário de Lactação
/// Exibe histórico de todos os registros de alimentação em formato timeline
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  // Índice da bottom navigation
  int _bottomNavIndex = 3; // Diário
  
  // Controlador de busca
  final TextEditingController _searchController = TextEditingController();
  
  // Data selecionada para filtro
  DateTime? _selectedDate;
  
  // Lista de registros (exemplo - em produção viria de banco de dados)
  List<FeedingRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carrega dados de exemplo
  void _loadSampleData() {
    _records = [
      FeedingRecord(
        type: 'breastfeeding',
        side: 'left',
        durationSeconds: 900,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        babyMood: 'happy',
        quality: 4.5,
        symptoms: ['Gases'],
        notes: 'Bebê mamou bem e dormiu logo depois.',
      ),
      FeedingRecord(
        type: 'bottle',
        side: '',
        durationSeconds: 600,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        babyMood: 'happy',
        quality: 4.0,
        symptoms: [],
        notes: 'Aceitou bem a mamadeira.',
      ),
      FeedingRecord(
        type: 'breastfeeding',
        side: 'right',
        durationSeconds: 720,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        babyMood: 'crying',
        quality: 3.0,
        symptoms: ['Cólica', 'Refluxo'],
        notes: 'Ficou um pouco irritado, teve refluxo.',
      ),
      FeedingRecord(
        type: 'formula',
        side: '',
        durationSeconds: 480,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        babyMood: 'sick',
        quality: 2.5,
        symptoms: ['Cólica'],
        notes: 'Não aceitou muito bem a fórmula.',
      ),
      FeedingRecord(
        type: 'breastfeeding',
        side: 'left',
        durationSeconds: 1020,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        babyMood: 'happy',
        quality: 5.0,
        symptoms: [],
        notes: 'Mamou muito bem, ficou satisfeito.',
      ),
    ];
  }

  /// Filtra registros por data
  List<FeedingRecord> _getFilteredRecords() {
    if (_selectedDate == null) {
      return _records;
    }
    
    return _records.where((record) {
      return record.timestamp.year == _selectedDate!.year &&
             record.timestamp.month == _selectedDate!.month &&
             record.timestamp.day == _selectedDate!.day;
    }).toList();
  }

  /// Agrupa registros por data
  Map<String, List<FeedingRecord>> _groupRecordsByDate() {
    final filtered = _getFilteredRecords();
    final Map<String, List<FeedingRecord>> grouped = {};
    
    for (var record in filtered) {
      final dateKey = DateFormat('dd/MM/yyyy').format(record.timestamp);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(record);
    }
    
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedRecords = _groupRecordsByDate();
    
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B36),
      body: SafeArea(
        child: Column(
          children: [
            // Header com título e filtro
            _buildHeader(),
            
            // Lista de registros
            Expanded(
              child: groupedRecords.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: groupedRecords.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final dateKey = groupedRecords.keys.elementAt(index);
                        final records = groupedRecords[dateKey]!;
                        return _buildDateSection(dateKey, records);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          
          // Navegação para outras telas
          if (index == 1) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/analytics');
          } else if (index == 4) {
            Navigator.of(context).pushNamed('/profile');
          } else if (index != 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Navegação para índice $index'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFFFF4081),
              ),
            );
          }
        },
      ),
    );
  }

  /// Constrói o header com título e filtro
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Diário de Lactação',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _selectedDate != null ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: _selectedDate != null ? const Color(0xFFFF4081) : Colors.white70,
                ),
                onPressed: _showDatePicker,
              ),
            ],
          ),
          
          if (_selectedDate != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4081).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: const Color(0xFFFF4081),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: const TextStyle(
                      color: Color(0xFFFF4081),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFFF4081),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Constrói uma seção de data com seus registros
  Widget _buildDateSection(String date, List<FeedingRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho da data
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4081),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFFFF4081),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${records.length} ${records.length == 1 ? 'registro' : 'registros'}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // Cards de registros
        ...records.map((record) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRecordCard(record),
        )),
      ],
    );
  }

  /// Constrói um card de registro
  Widget _buildRecordCard(FeedingRecord record) {
    return GestureDetector(
      onTap: () => _showEditDialog(record),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3D2A47),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: _buildTypeIcon(record.type),
          title: Row(
            children: [
              Text(
                DateFormat('HH:mm').format(record.timestamp),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                record.getFormattedDuration(),
                style: const TextStyle(
                  color: Color(0xFFFF4081),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                record.getTypeName() + (record.side.isNotEmpty ? ' - ${record.side == 'left' ? 'Esquerdo' : 'Direito'}' : ''),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMoodChip(record.babyMood),
                  const SizedBox(width: 8),
                  _buildQualityStars(record.quality),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(record),
          ),
          children: [
            if (record.symptoms.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: record.symptoms.map((symptom) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4081).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF4081).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      symptom,
                      style: const TextStyle(
                        color: Color(0xFFFF4081),
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (record.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1B36),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.note_alt_outlined,
                      color: Color(0xFFFF4081),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        record.notes,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Constrói ícone do tipo de alimentação
  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'breastfeeding':
        icon = Icons.child_care;
        color = const Color(0xFFFF4081);
        break;
      case 'bottle':
        icon = Icons.local_drink;
        color = const Color(0xFF9C27B0);
        break;
      case 'formula':
        icon = Icons.baby_changing_station;
        color = const Color(0xFFBA68C8);
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  /// Constrói chip de humor
  Widget _buildMoodChip(String mood) {
    String label;
    IconData icon;
    
    switch (mood) {
      case 'happy':
        label = 'Feliz';
        icon = Icons.sentiment_very_satisfied;
        break;
      case 'sick':
        label = 'Enjoado';
        icon = Icons.sick;
        break;
      case 'crying':
        label = 'Chorando';
        icon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        label = 'Normal';
        icon = Icons.sentiment_neutral;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B36),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói estrelas de qualidade
  Widget _buildQualityStars(double quality) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < quality.floor()
              ? Icons.star
              : (index < quality ? Icons.star_half : Icons.star_border),
          color: const Color(0xFFFF4081),
          size: 14,
        );
      }),
    );
  }

  /// Constrói estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum registro encontrado',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedDate != null
                ? 'Tente outra data'
                : 'Comece registrando suas mamadas',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra seletor de data
  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF4081),
              surface: Color(0xFF3D2A47),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Mostra diálogo de edição
  void _showEditDialog(FeedingRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _EditRecordScreen(
          record: record,
          onSave: (updatedRecord) {
            setState(() {
              final index = _records.indexOf(record);
              if (index != -1) {
                _records[index] = updatedRecord;
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro atualizado!'),
                backgroundColor: Color(0xFFFF4081),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Confirma exclusão
  void _confirmDelete(FeedingRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Excluir Registro',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja excluir este registro?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _records.remove(record);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registro excluído'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de edição de registro
class _EditRecordScreen extends StatefulWidget {
  final FeedingRecord record;
  final Function(FeedingRecord) onSave;

  const _EditRecordScreen({
    required this.record,
    required this.onSave,
  });

  @override
  State<_EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<_EditRecordScreen> {
  late String _type;
  late String _side;
  late DateTime _timestamp;
  late int _duration;
  late String _mood;
  late double _quality;
  late List<String> _symptoms;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _type = widget.record.type;
    _side = widget.record.side;
    _timestamp = widget.record.timestamp;
    _duration = widget.record.durationSeconds;
    _mood = widget.record.babyMood;
    _quality = widget.record.quality;
    _symptoms = List.from(widget.record.symptoms);
    _notesController = TextEditingController(text: widget.record.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text('Editar Registro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Data e hora
            _buildSection(
              'Data e Hora',
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2A47),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFFFF4081)),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(_timestamp),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tipo de alimentação
            _buildSection(
              'Tipo de Alimentação',
              Wrap(
                spacing: 8,
                children: [
                  _buildTypeChip('Peito', 'breastfeeding'),
                  _buildTypeChip('Mamadeira', 'bottle'),
                  _buildTypeChip('Fórmula', 'formula'),
                ],
              ),
            ),

            if (_type == 'breastfeeding') ...[
              const SizedBox(height: 16),
              _buildSection(
                'Lado',
                Row(
                  children: [
                    Expanded(child: _buildSideChip('Esquerdo', 'left')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSideChip('Direito', 'right')),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Humor
            _buildSection(
              'Humor do Bebê',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodButton('happy', Icons.sentiment_very_satisfied, 'Feliz'),
                  _buildMoodButton('sick', Icons.sick, 'Enjoado'),
                  _buildMoodButton('crying', Icons.sentiment_very_dissatisfied, 'Chorando'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Qualidade
            _buildSection(
              'Qualidade',
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _quality.floor() ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFF4081),
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _quality = (index + 1).toDouble();
                      });
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Sintomas
            _buildSection(
              'Sintomas',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Cólica', 'Refluxo', 'Gases', 'Soluço'].map((symptom) {
                  return FilterChip(
                    label: Text(symptom),
                    selected: _symptoms.contains(symptom),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _symptoms.add(symptom);
                        } else {
                          _symptoms.remove(symptom);
                        }
                      });
                    },
                    backgroundColor: const Color(0xFF3D2A47),
                    selectedColor: const Color(0xFFFF4081).withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: _symptoms.contains(symptom) ? const Color(0xFFFF4081) : Colors.white70,
                    ),
                    checkmarkColor: const Color(0xFFFF4081),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Anotações
            _buildSection(
              'Anotações',
              TextField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Digite suas observações...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF3D2A47),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTypeChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _type == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _type = value;
            if (value != 'breastfeeding') {
              _side = '';
            }
          });
        }
      },
      selectedColor: const Color(0xFFFF4081),
      backgroundColor: const Color(0xFF3D2A47),
      labelStyle: TextStyle(
        color: _type == value ? Colors.white : Colors.white70,
      ),
    );
  }

  Widget _buildSideChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _side == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _side = value;
          });
        }
      },
      selectedColor: const Color(0xFFFF4081),
      backgroundColor: const Color(0xFF3D2A47),
      labelStyle: TextStyle(
        color: _side == value ? Colors.white : Colors.white70,
      ),
    );
  }

  Widget _buildMoodButton(String mood, IconData icon, String label) {
    final isSelected = _mood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          _mood = mood;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF4081).withValues(alpha: 0.3) : const Color(0xFF3D2A47),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF4081) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(icon, size: 28, color: isSelected ? const Color(0xFFFF4081) : Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF4081) : Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF4081),
              surface: Color(0xFF3D2A47),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_timestamp),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF4081),
                surface: Color(0xFF3D2A47),
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _timestamp = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveRecord() {
    final updatedRecord = FeedingRecord(
      type: _type,
      side: _side,
      durationSeconds: _duration,
      timestamp: _timestamp,
      babyMood: _mood,
      quality: _quality,
      symptoms: _symptoms,
      notes: _notesController.text,
    );

    widget.onSave(updatedRecord);
    Navigator.pop(context);
  }
}
