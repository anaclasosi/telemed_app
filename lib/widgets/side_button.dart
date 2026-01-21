import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

/// Widget customizado que representa um botão circular para rastreamento de amamentação
/// Inclui:
/// - Borda tracejada ao redor
/// - Badge opcional "Último Lado"
/// - Ícone de play/pause
/// - Estado ativo/inativo
class SideButton extends StatelessWidget {
  final String side; // 'Esquerdo' ou 'Direito'
  final bool isActive; // Se o cronômetro está ativo para este lado
  final bool showLastSideBadge; // Se deve mostrar o badge "Último Lado"
  final VoidCallback onPressed;

  const SideButton({
    super.key,
    required this.side,
    required this.isActive,
    required this.showLastSideBadge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge "Último Lado" flutuante
        if (showLastSideBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4081),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Último Lado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 8),
        
        // Botão circular com borda tracejada
        GestureDetector(
          onTap: onPressed,
          child: DottedBorder(
            borderType: BorderType.Circle,
            dashPattern: const [8, 4],
            strokeWidth: 2,
            color: isActive ? const Color(0xFFFF4081) : Colors.white.withValues(alpha: 0.3),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive 
                    ? const Color(0xFFFF4081) 
                    : const Color(0xFF4A3356),
              ),
              child: Icon(
                isActive ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Label do lado (Esquerdo/Direito)
        Text(
          side,
          style: TextStyle(
            color: isActive ? const Color(0xFFFF4081) : Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
