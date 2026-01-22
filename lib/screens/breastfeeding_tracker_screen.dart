import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/side_button.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/feeding_record.dart';

/// Tela principal de rastreamento de amamentação
/// Permite alternar entre amamentação, mamadeira e sólidos
/// Rastreia tempo separadamente para cada lado (esquerdo/direito)
class BreastfeedingTrackerScreen extends StatefulWidget {
  const BreastfeedingTrackerScreen({super.key});

  @override
  State<BreastfeedingTrackerScreen> createState() => _BreastfeedingTrackerScreenState();
}

class _BreastfeedingTrackerScreenState extends State<BreastfeedingTrackerScreen> {
  // Controle de abas
  int _selectedTab = 0; // 0: Amamentação, 1: Mamadeira, 2: Sólidos
  final List<String> _tabs = ['Amamentação', 'Mamadeira', 'Sólidos'];
  
  // Controle do cronômetro
  Timer? _timer;
  int _totalSeconds = 0;
  String _activeSide = ''; // 'left', 'right' ou vazio
  String _lastSide = 'left'; // Último lado usado
  
  // Índice da bottom navigation
  int _bottomNavIndex = 1; // Começar no rastreamento

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Inicia o cronômetro para um lado específico
  void _startTimer(String side) {
    // Se já está ativo no mesmo lado, pausa
    if (_activeSide == side) {
      _stopTimer();
      return;
    }
    
    // Se está ativo em outro lado, para o anterior
    if (_activeSide.isNotEmpty && _activeSide != side) {
      _stopTimer();
    }
    
    // Inicia o novo cronômetro
    setState(() {
      _activeSide = side;
      _lastSide = side;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalSeconds++;
      });
    });
  }

  /// Para o cronômetro
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _activeSide = '';
    });
  }

  /// Formata o tempo em MM : SS
  String _formatTime() {
    int minutes = _totalSeconds ~/ 60;
    int seconds = _totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  /// Reseta o cronômetro e mostra modal de resumo
  void _resetTimer() {
    // Se há tempo registrado, mostra o modal de resumo
    if (_totalSeconds > 0) {
      _showFeedingSummaryModal();
    } else {
      _timer?.cancel();
      setState(() {
        _totalSeconds = 0;
        _activeSide = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B36),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom - 80,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header com abas
                  _buildHeader(),
                  
                  const SizedBox(height: 40),
                  
                  // Cronômetro central
                  _buildTimer(),
                  
                  const SizedBox(height: 60),
                  
                  // Botões de ação (Esquerdo/Direito)
                  _buildSideButtons(),
                  
                  const SizedBox(height: 30),
                  
                  // Botão Concluir (aparece quando há tempo registrado)
                  if (_totalSeconds > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _resetTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4081),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Concluir e Salvar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Botão de entrada manual
                  _buildManualEntryButton(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          
          // Navegação para outras telas conforme o índice
          if (index == 4) {
            // Navegar para a tela de perfil
            Navigator.of(context).pushNamed('/profile');
          } else if (index == 3) {
            // Navegar para a tela de diário
            Navigator.of(context).pushNamed('/diary');
          } else if (index == 2) {
            // Navegar para a tela de gráficos
            Navigator.of(context).pushNamed('/analytics');
          } else if (index != 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Navegação para índice $index'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }

  /// Constrói o header com ícone de fechar, abas e ícone de ajuda
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Logo
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/logo_circularsf.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.child_care,
                  color: Color(0xFFFF4081),
                  size: 30,
                );
              },
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Abas centralizadas
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF3D2A47),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTab == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFFF4081) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _tabs[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Ícone de ajuda
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
    );
  }

  /// Constrói o cronômetro central
  Widget _buildTimer() {
    return Column(
      children: [
        Text(
          _formatTime(),
          style: const TextStyle(
            color: Color(0xFFFF4081),
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 40),
            Text(
              'MIN',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 60),
            Text(
              'SEC',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói os botões laterais (Esquerdo/Direito)
  Widget _buildSideButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botão Esquerdo
        SideButton(
          side: 'Esquerdo',
          isActive: _activeSide == 'left',
          showLastSideBadge: _lastSide == 'left' && _activeSide.isEmpty,
          onPressed: () => _startTimer('left'),
        ),
        
        // Botão Direito
        SideButton(
          side: 'Direito',
          isActive: _activeSide == 'right',
          showLastSideBadge: _lastSide == 'right' && _activeSide.isEmpty,
          onPressed: () => _startTimer('right'),
        ),
      ],
    );
  }

  /// Constrói o botão de entrada manual
  Widget _buildManualEntryButton() {
    return TextButton(
      onPressed: () {
        _showManualEntryDialog();
      },
      child: const Text(
        'Entrada Manual',
        style: TextStyle(
          color: Color(0xFFFF4081),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Constrói a logo
  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/logo_circularsf.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback caso a imagem não seja encontrada
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4081),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4081).withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.child_care,
              size: 30,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  /// Mostra diálogo de confirmação ao sair
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Sair sem salvar?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'O cronômetro está ativo. Deseja sair sem salvar o registro?',
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
              _resetTimer();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Color(0xFFFF4081)),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo de ajuda
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Como usar',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '1. Toque no botão do lado (Esquerdo/Direito) para iniciar o cronômetro.\n\n'
          '2. Toque novamente para pausar.\n\n'
          '3. Toque no outro lado para alternar automaticamente.\n\n'
          '4. Use "Entrada Manual" para registrar manualmente.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendi',
              style: TextStyle(color: Color(0xFFFF4081)),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra modal de resumo da mamada
  void _showFeedingSummaryModal() {
    // Parar o cronômetro se estiver ativo
    _timer?.cancel();
    
    // Estado inicial do modal
    String selectedMood = 'happy';
    double selectedQuality = 3.0;
    List<String> selectedSymptoms = [];
    String selectedType = _selectedTab == 0 ? 'breastfeeding' : (_selectedTab == 1 ? 'bottle' : 'formula');
    TextEditingController notesController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D1B36),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título
                      const Text(
                        'Resumo da Mamada',
                        style: TextStyle(
                          color: Color(0xFFFF4081),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Tempo registrado
                      Text(
                        'Duração: ${_formatTime()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Humor do Bebê
                      const Text(
                        'Como o bebê está?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMoodIcon(
                            icon: Icons.sentiment_very_satisfied,
                            label: 'Feliz',
                            value: 'happy',
                            isSelected: selectedMood == 'happy',
                            onTap: () {
                              setModalState(() {
                                selectedMood = 'happy';
                              });
                            },
                          ),
                          _buildMoodIcon(
                            icon: Icons.sick,
                            label: 'Enjoado',
                            value: 'sick',
                            isSelected: selectedMood == 'sick',
                            onTap: () {
                              setModalState(() {
                                selectedMood = 'sick';
                              });
                            },
                          ),
                          _buildMoodIcon(
                            icon: Icons.sentiment_very_dissatisfied,
                            label: 'Chorando',
                            value: 'crying',
                            isSelected: selectedMood == 'crying',
                            onTap: () {
                              setModalState(() {
                                selectedMood = 'crying';
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Qualidade (Estrelas)
                      const Text(
                        'Qualidade da mamada',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedQuality.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFFF4081),
                              size: 36,
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedQuality = (index + 1).toDouble();
                              });
                            },
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sintomas
                      const Text(
                        'Sintomas observados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSymptomChip(
                            'Cólica',
                            selectedSymptoms.contains('Cólica'),
                            () {
                              setModalState(() {
                                if (selectedSymptoms.contains('Cólica')) {
                                  selectedSymptoms.remove('Cólica');
                                } else {
                                  selectedSymptoms.add('Cólica');
                                }
                              });
                            },
                          ),
                          _buildSymptomChip(
                            'Refluxo',
                            selectedSymptoms.contains('Refluxo'),
                            () {
                              setModalState(() {
                                if (selectedSymptoms.contains('Refluxo')) {
                                  selectedSymptoms.remove('Refluxo');
                                } else {
                                  selectedSymptoms.add('Refluxo');
                                }
                              });
                            },
                          ),
                          _buildSymptomChip(
                            'Gases',
                            selectedSymptoms.contains('Gases'),
                            () {
                              setModalState(() {
                                if (selectedSymptoms.contains('Gases')) {
                                  selectedSymptoms.remove('Gases');
                                } else {
                                  selectedSymptoms.add('Gases');
                                }
                              });
                            },
                          ),
                          _buildSymptomChip(
                            'Soluço',
                            selectedSymptoms.contains('Soluço'),
                            () {
                              setModalState(() {
                                if (selectedSymptoms.contains('Soluço')) {
                                  selectedSymptoms.remove('Soluço');
                                } else {
                                  selectedSymptoms.add('Soluço');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Tipo de alimentação
                      const Text(
                        'Tipo de alimentação',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D2A47),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                label: 'Peito',
                                icon: Icons.child_care,
                                isSelected: selectedType == 'breastfeeding',
                                onTap: () {
                                  setModalState(() {
                                    selectedType = 'breastfeeding';
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                label: 'Mamadeira',
                                icon: Icons.baby_changing_station,
                                isSelected: selectedType == 'bottle',
                                onTap: () {
                                  setModalState(() {
                                    selectedType = 'bottle';
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: _buildTypeButton(
                                label: 'Fórmula',
                                icon: Icons.science,
                                isSelected: selectedType == 'formula',
                                onTap: () {
                                  setModalState(() {
                                    selectedType = 'formula';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Anotações
                      const Text(
                        'Anotações extras',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      TextField(
                        controller: notesController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Digite suas observações...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF3D2A47),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFFF4081)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFFFF4081).withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF4081),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão Salvar
                      ElevatedButton(
                        onPressed: () {
                          // Criar o registro
                          final record = FeedingRecord(
                            type: selectedType,
                            side: _lastSide,
                            durationSeconds: _totalSeconds,
                            timestamp: DateTime.now(),
                            babyMood: selectedMood,
                            quality: selectedQuality,
                            symptoms: selectedSymptoms,
                            notes: notesController.text,
                          );
                          
                          // Aqui você salvaria o registro em um banco de dados
                          // Por enquanto, apenas mostra uma mensagem
                          Navigator.pop(context);
                          
                          // Limpar o cronômetro
                          setState(() {
                            _totalSeconds = 0;
                            _activeSide = '';
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registro salvo com sucesso!'),
                              backgroundColor: Color(0xFFFF4081),
                            ),
                          );
                          
                          notesController.dispose();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4081),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Salvar Registro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Botão Descartar
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          notesController.dispose();
                          
                          // Limpar o cronômetro
                          setState(() {
                            _totalSeconds = 0;
                            _activeSide = '';
                          });
                        },
                        child: const Text(
                          'Descartar',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Constrói um ícone de humor
  Widget _buildMoodIcon({
    required IconData icon,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF4081).withValues(alpha: 0.3)
                  : const Color(0xFF3D2A47),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF4081)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFFFF4081) : Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF4081) : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um chip de sintoma
  Widget _buildSymptomChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: const Color(0xFF3D2A47),
      selectedColor: const Color(0xFFFF4081).withValues(alpha: 0.3),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFFF4081) : Colors.white70,
      ),
      checkmarkColor: const Color(0xFFFF4081),
      side: BorderSide(
        color: isSelected ? const Color(0xFFFF4081) : Colors.transparent,
      ),
    );
  }



  /// Mostra diálogo de entrada manual
  void _showManualEntryDialog() {
    // Estado local do modal
    DateTime selectedDate = DateTime.now();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String selectedSide = 'left'; // 'left', 'right', 'both'
    String selectedType = 'breast'; // 'breast', 'formula', 'bottle'
    String selectedMood = 'happy';
    int selectedQuality = 3;
    List<String> selectedSymptoms = [];
    String notes = '';
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Calcula duração automaticamente
            String calculateDuration() {
              if (startTime == null || endTime == null) return '--';
              
              final start = Duration(hours: startTime!.hour, minutes: startTime!.minute);
              final end = Duration(hours: endTime!.hour, minutes: endTime!.minute);
              
              int durationMinutes = end.inMinutes - start.inMinutes;
              if (durationMinutes < 0) durationMinutes += 24 * 60; // Adiciona 24h se passar da meia-noite
              
              return '$durationMinutes min';
            }

            // Verifica se pode salvar
            bool canSave() {
              if (startTime == null || endTime == null) return false;
              
              final start = Duration(hours: startTime!.hour, minutes: startTime!.minute);
              final end = Duration(hours: endTime!.hour, minutes: endTime!.minute);
              
              return end.inMinutes > start.inMinutes || 
                     (end.inMinutes < start.inMinutes); // Permite passar da meia-noite
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Color(0xFF2D1B36),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // Barra de arrasto
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Cabeçalho
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Adicionar Registo Manual',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(color: Colors.white24, height: 1),
                  
                  // Conteúdo rolável
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === SEÇÃO: TEMPO ===
                          const Text(
                            'Data e Hora',
                            style: TextStyle(
                              color: Color(0xFFFF4081),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Data
                          _buildManualFieldCard(
                            icon: Icons.calendar_today,
                            label: 'Data',
                            value: DateFormat('dd/MM/yyyy').format(selectedDate),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
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
                              if (date != null) {
                                setModalState(() {
                                  selectedDate = date;
                                });
                              }
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Hora de Início e Fim
                          Row(
                            children: [
                              Expanded(
                                child: _buildManualFieldCard(
                                  icon: Icons.access_time,
                                  label: 'Início',
                                  value: startTime != null 
                                      ? startTime!.format(context) 
                                      : '--:--',
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: startTime ?? TimeOfDay.now(),
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
                                      setModalState(() {
                                        startTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildManualFieldCard(
                                  icon: Icons.access_time,
                                  label: 'Fim',
                                  value: endTime != null 
                                      ? endTime!.format(context) 
                                      : '--:--',
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: endTime ?? TimeOfDay.now(),
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
                                      setModalState(() {
                                        endTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Duração calculada
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D2A47),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF4081).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  color: Color(0xFFFF4081),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Duração:',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  calculateDuration(),
                                  style: const TextStyle(
                                    color: Color(0xFFFF4081),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // === SEÇÃO: DETALHES DA LACTAÇÃO ===
                          const Text(
                            'Detalhes da Lactação',
                            style: TextStyle(
                              color: Color(0xFFFF4081),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Tipo de Alimento
                          const Text(
                            'Tipo de Alimento',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTypeButton(
                                  label: 'Peito',
                                  icon: Icons.child_care,
                                  isSelected: selectedType == 'breast',
                                  onTap: () {
                                    setModalState(() {
                                      selectedType = 'breast';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTypeButton(
                                  label: 'Fórmula',
                                  icon: Icons.science,
                                  isSelected: selectedType == 'formula',
                                  onTap: () {
                                    setModalState(() {
                                      selectedType = 'formula';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTypeButton(
                                  label: 'Biberão',
                                  icon: Icons.baby_changing_station,
                                  isSelected: selectedType == 'bottle',
                                  onTap: () {
                                    setModalState(() {
                                      selectedType = 'bottle';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Lado (apenas se for peito)
                          if (selectedType == 'breast') ...[
                            const Text(
                              'Lado',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSideButton(
                                    label: 'Esquerdo',
                                    isSelected: selectedSide == 'left',
                                    onTap: () {
                                      setModalState(() {
                                        selectedSide = 'left';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSideButton(
                                    label: 'Direito',
                                    isSelected: selectedSide == 'right',
                                    onTap: () {
                                      setModalState(() {
                                        selectedSide = 'right';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSideButton(
                                    label: 'Ambos',
                                    isSelected: selectedSide == 'both',
                                    onTap: () {
                                      setModalState(() {
                                        selectedSide = 'both';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          const SizedBox(height: 24),
                          
                          // === SEÇÃO: DADOS COMPLEMENTARES ===
                          const Text(
                            'Dados Complementares',
                            style: TextStyle(
                              color: Color(0xFFFF4081),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Humor do Bebê
                          const Text(
                            'Como está o bebê?',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMoodButton(
                                emoji: '😊',
                                label: 'Feliz',
                                value: 'happy',
                                isSelected: selectedMood == 'happy',
                                onTap: () {
                                  setModalState(() {
                                    selectedMood = 'happy';
                                  });
                                },
                              ),
                              _buildMoodButton(
                                emoji: '😐',
                                label: 'Normal',
                                value: 'neutral',
                                isSelected: selectedMood == 'neutral',
                                onTap: () {
                                  setModalState(() {
                                    selectedMood = 'neutral';
                                  });
                                },
                              ),
                              _buildMoodButton(
                                emoji: '🤢',
                                label: 'Enjoado',
                                value: 'sick',
                                isSelected: selectedMood == 'sick',
                                onTap: () {
                                  setModalState(() {
                                    selectedMood = 'sick';
                                  });
                                },
                              ),
                              _buildMoodButton(
                                emoji: '😢',
                                label: 'Chorando',
                                value: 'crying',
                                isSelected: selectedMood == 'crying',
                                onTap: () {
                                  setModalState(() {
                                    selectedMood = 'crying';
                                  });
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Qualidade
                          const Text(
                            'Qualidade da Alimentação',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starValue = index + 1;
                              return IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedQuality = starValue;
                                  });
                                },
                                icon: Icon(
                                  starValue <= selectedQuality
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFF4081),
                                  size: 32,
                                ),
                              );
                            }),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Sintomas
                          const Text(
                            'Sintomas (opcional)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'Gases',
                              'Cólica',
                              'Regurgitação',
                              'Sono',
                              'Agitação'
                            ].map((symptom) {
                              final isSelected = selectedSymptoms.contains(symptom);
                              return FilterChip(
                                label: Text(symptom),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    if (selected) {
                                      selectedSymptoms.add(symptom);
                                    } else {
                                      selectedSymptoms.remove(symptom);
                                    }
                                  });
                                },
                                backgroundColor: const Color(0xFF3D2A47),
                                selectedColor: const Color(0xFFFF4081),
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                ),
                              );
                            }).toList(),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Notas
                          const Text(
                            'Observações',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: notesController,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Adicione observações...',
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: const Color(0xFF3D2A47),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              notes = value;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botão Guardar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D1B36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: canSave() ? () {
                            // Calcula duração em segundos
                            final start = Duration(
                              hours: startTime!.hour, 
                              minutes: startTime!.minute
                            );
                            final end = Duration(
                              hours: endTime!.hour, 
                              minutes: endTime!.minute
                            );
                            int durationSeconds = end.inSeconds - start.inSeconds;
                            if (durationSeconds < 0) durationSeconds += 24 * 60 * 60;
                            
                            // Cria o timestamp combinando data e hora de início
                            final timestamp = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              startTime!.hour,
                              startTime!.minute,
                            );
                            
                            // Cria o registro
                            final record = FeedingRecord(
                              type: selectedType,
                              side: selectedType == 'breast' ? selectedSide : '',
                              durationSeconds: durationSeconds,
                              timestamp: timestamp,
                              babyMood: selectedMood,
                              quality: selectedQuality.toDouble(),
                              symptoms: selectedSymptoms.isNotEmpty ? selectedSymptoms : [],
                              notes: notes.isNotEmpty ? notes : '',
                            );
                            
                            // Aqui você pode adicionar o registro ao banco de dados ou lista
                            print('Registro manual criado: ${record.toMap()}');
                            
                            // Mostra mensagem de sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registo adicionado com sucesso!'),
                                backgroundColor: Color(0xFFFF4081),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            
                            Navigator.pop(context);
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4081),
                            disabledBackgroundColor: Colors.white24,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Guardar Registo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Constrói um campo de seleção manual
  Widget _buildManualFieldCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2A47),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF4081), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  /// Constrói botão de tipo de alimento
  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4081) : const Color(0xFF3D2A47),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFF4081) 
                : Colors.white24,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói botão de lado
  Widget _buildSideButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4081) : const Color(0xFF3D2A47),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFF4081) 
                : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Constrói botão de humor
  Widget _buildMoodButton({
    required String emoji,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4081) : const Color(0xFF3D2A47),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFF4081) 
                : Colors.white24,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
