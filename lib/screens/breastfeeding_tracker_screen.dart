import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/side_button.dart';
import '../widgets/custom_bottom_nav.dart';

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

  /// Reseta o cronômetro
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _totalSeconds = 0;
      _activeSide = '';
    });
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
          
          // Aqui você pode navegar para outras telas conforme o índice
          if (index != 1) {
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
          // Ícone de fechar
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Confirmação antes de fechar se o timer estiver ativo
              if (_activeSide.isNotEmpty) {
                _showExitConfirmation();
              } else {
                Navigator.of(context).pop();
              }
            },
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

  /// Mostra diálogo de entrada manual
  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Entrada Manual',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Funcionalidade de entrada manual será implementada aqui.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fechar',
              style: TextStyle(color: Color(0xFFFF4081)),
            ),
          ),
        ],
      ),
    );
  }
}
