import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_bottom_nav.dart';

/// Tela de Estatísticas e Gráficos
/// Exibe análises visuais sobre amamentação e alimentação do bebê
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Índice da bottom navigation
  int _bottomNavIndex = 2; // Gráficos
  
  // Filtro de tempo selecionado
  int _selectedTimeFilter = 1; // 0: Hoje, 1: Semana, 2: Mês
  final List<String> _timeFilters = ['Hoje', 'Semana', 'Mês'];
  
  // Dados de exemplo - em produção viriam de um banco de dados
  final Map<String, dynamic> _todayStats = {
    'totalMinutes': 145,
    'lastFeedingTime': '14:30',
    'totalVolume': '350 ml',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B36),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                const Text(
                  'Estatísticas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Filtros de Tempo
                _buildTimeFilters(),
                
                const SizedBox(height: 24),
                
                // Cards de Resumo
                _buildSummaryCards(),
                
                const SizedBox(height: 30),
                
                // Gráfico de Pizza - Distribuição de Alimentos
                _buildSectionTitle('Distribuição por Tipo'),
                const SizedBox(height: 16),
                _buildPieChart(),
                
                const SizedBox(height: 30),
                
                // Gráfico de Barras - Evolução Temporal
                _buildSectionTitle('Evolução nos Últimos 7 Dias'),
                const SizedBox(height: 16),
                _buildBarChart(),
                
                const SizedBox(height: 30),
                
                // Insights de Qualidade
                _buildSectionTitle('Análise de Qualidade'),
                const SizedBox(height: 16),
                _buildQualityInsights(),
                
                const SizedBox(height: 20),
              ],
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
          
          // Navegação para outras telas
          if (index == 1) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 3) {
            Navigator.of(context).pushNamed('/diary');
          } else if (index == 4) {
            Navigator.of(context).pushNamed('/profile');
          } else if (index != 2) {
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

  /// Constrói os filtros de tempo (Hoje, Semana, Mês)
  Widget _buildTimeFilters() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(_timeFilters.length, (index) {
          final isSelected = _selectedTimeFilter == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeFilter = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFFFF4081) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _timeFilters[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Constrói os cards de resumo diário
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total de Hoje',
            '${_todayStats['totalMinutes']} min',
            Icons.timer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Última Refeição',
            _todayStats['lastFeedingTime'],
            Icons.schedule,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Volume Total',
            _todayStats['totalVolume'],
            Icons.local_drink,
          ),
        ),
      ],
    );
  }

  /// Constrói um card individual de resumo
  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF4081),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um título de seção
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Constrói o gráfico de pizza
  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFFFF4081),
                    value: 45,
                    title: '45%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF9C27B0),
                    value: 30,
                    title: '30%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFBA68C8),
                    value: 25,
                    title: '25%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legenda
          _buildLegend(),
        ],
      ),
    );
  }

  /// Constrói a legenda do gráfico de pizza
  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendItem('Peito (Direto)', const Color(0xFFFF4081)),
        const SizedBox(height: 8),
        _buildLegendItem('Leite Materno', const Color(0xFF9C27B0)),
        const SizedBox(height: 8),
        _buildLegendItem('Fórmula', const Color(0xFFBA68C8)),
      ],
    );
  }

  /// Constrói um item da legenda
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Constrói o gráfico de barras
  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 200,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => const Color(0xFF3D2A47),
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()} min',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Text(
                        days[value.toInt()],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withValues(alpha: 0.1),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              _buildBarGroup(0, 120),
              _buildBarGroup(1, 145),
              _buildBarGroup(2, 130),
              _buildBarGroup(3, 160),
              _buildBarGroup(4, 150),
              _buildBarGroup(5, 135),
              _buildBarGroup(6, 140),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um grupo de barras
  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF4081),
              Color(0xFF9C27B0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 16,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de insights de qualidade
  Widget _buildQualityInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildQualityItem(
            'Peito (Direto)',
            4.5,
            'Bebê mais satisfeito',
            Icons.child_care,
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 24,
          ),
          _buildQualityItem(
            'Leite Materno',
            4.0,
            'Boa aceitação',
            Icons.local_drink,
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 24,
          ),
          _buildQualityItem(
            'Fórmula',
            3.5,
            'Aceitação moderada',
            Icons.baby_changing_station,
          ),
        ],
      ),
    );
  }

  /// Constrói um item de qualidade
  Widget _buildQualityItem(
    String type,
    double rating,
    String observation,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4081).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF4081),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                observation,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating.floor()
                      ? Icons.star
                      : (index < rating ? Icons.star_half : Icons.star_border),
                  color: const Color(0xFFFF4081),
                  size: 16,
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Color(0xFFFF4081),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
