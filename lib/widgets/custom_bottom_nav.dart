import 'package:flutter/material.dart';

/// Bottom Navigation Bar customizada com 5 ícones
/// Primeiro ícone (botão de adição) tem destaque visual diferenciado
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botão 0 - Adicionar (com destaque)
              _buildNavItem(
                icon: Icons.add_circle,
                index: 0,
                isHighlighted: true,
              ),
              
              // Botão 1 - Rastreamento
              _buildNavItem(
                icon: Icons.timer,
                index: 1,
              ),
              
              // Botão 2 - Estatísticas
              _buildNavItem(
                icon: Icons.bar_chart,
                index: 2,
              ),
              
              // Botão 3 - Configurações
              _buildNavItem(
                icon: Icons.settings,
                index: 3,
              ),
              
              // Botão 4 - Perfil
              _buildNavItem(
                icon: Icons.person,
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    bool isHighlighted = false,
  }) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: isHighlighted ? 32 : 28,
          color: isSelected
              ? const Color(0xFFFF4081)
              : isHighlighted
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
