import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_bottom_nav.dart';

/// Tela de Perfil do Usuário
/// Exibe informações do usuário, dados do bebê, configurações e opções de menu
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Índice da bottom navigation
  int _bottomNavIndex = 4; // Perfil

  // Controles de switches
  bool _remindersEnabled = true;
  bool _notificationsEnabled = true;
  
  // Imagem de perfil
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Dados do usuário (exemplo - seria substituído por dados reais)
  String _userName = 'Ana Silva';
  String _userEmail = 'ana.silva@email.com';
  String _babyName = 'Sofia';
  String _babyBirthDate = '15/10/2025';
  String _babyWeight = '5.2 kg';

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
                const SizedBox(height: 20),

                // Cabeçalho do Perfil
                _buildProfileHeader(),

                const SizedBox(height: 30),

                // Dados do Bebê
                _buildSectionTitle('Dados do Bebê'),
                const SizedBox(height: 12),
                _buildBabyInfoCard(),

                const SizedBox(height: 24),

                // Configurações de Amamentação
                _buildSectionTitle('Configurações de Amamentação'),
                const SizedBox(height: 12),
                _buildBreastfeedingSettingsCard(),

                const SizedBox(height: 24),

                // Preferências
                _buildSectionTitle('Preferências'),
                const SizedBox(height: 12),
                _buildPreferencesCard(),

                const SizedBox(height: 24),

                // Menu de Opções
                _buildSectionTitle('Mais Opções'),
                const SizedBox(height: 12),
                _buildMenuOptions(),

                const SizedBox(height: 30),

                // Botão Sair
                _buildLogoutButton(),

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
            // Navegar para a tela de rastreamento de amamentação
            Navigator.of(context).pushNamed('/home');
          } else if (index == 2) {
            // Navegar para a tela de gráficos
            Navigator.of(context).pushNamed('/analytics');
          } else if (index == 3) {
            // Navegar para a tela de diário
            Navigator.of(context).pushNamed('/diary');
          } else if (index != 4) {
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

  /// Constrói o cabeçalho do perfil com avatar, nome, email e botão editar
  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar com borda rosa
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF4081),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF3D2A47),
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFFFF4081),
                      )
                    : null,
              ),
            ),
            // Botão editar foto
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4081),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    _showImageSourceDialog();
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Nome do usuário
        Text(
          _userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // Email do usuário
        Text(
          _userEmail,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 16),

        // Botão Editar Perfil
        OutlinedButton.icon(
          onPressed: () {
            _showEditProfileDialog();
          },
          icon: const Icon(
            Icons.edit,
            size: 18,
            color: Color(0xFFFF4081),
          ),
          label: const Text(
            'Editar Perfil',
            style: TextStyle(
              color: Color(0xFFFF4081),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0xFFFF4081),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ],
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

  /// Constrói o card com informações do bebê
  Widget _buildBabyInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.child_care,
            title: 'Nome do Bebê',
            value: _babyName,
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildInfoTile(
            icon: Icons.cake,
            title: 'Data de Nascimento',
            value: _babyBirthDate,
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildInfoTile(
            icon: Icons.monitor_weight,
            title: 'Peso Atual',
            value: _babyWeight,
          ),
        ],
      ),
    );
  }

  /// Constrói o card com configurações de amamentação
  Widget _buildBreastfeedingSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_active,
            title: 'Lembretes de Mamada',
            subtitle: 'Receber notificações nos horários',
            value: _remindersEnabled,
            onChanged: (value) {
              setState(() {
                _remindersEnabled = value;
              });
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildClickableTile(
            icon: Icons.flag,
            title: 'Metas Diárias',
            subtitle: '8 mamadas por dia',
            onTap: () {
              _showMessage('Configurar metas diárias');
            },
          ),
        ],
      ),
    );
  }

  /// Constrói o card com preferências
  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildClickableTile(
            icon: Icons.straighten,
            title: 'Unidades de Medida',
            subtitle: 'ml (mililitros)',
            onTap: () {
              _showMessage('Alterar unidades de medida');
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildClickableTile(
            icon: Icons.language,
            title: 'Idioma',
            subtitle: 'Português (Brasil)',
            onTap: () {
              _showMessage('Alterar idioma');
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Notificações',
            subtitle: 'Receber todas as notificações',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Constrói o menu de opções
  Widget _buildMenuOptions() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.history,
            title: 'Histórico de Atividades',
            onTap: () {
              _showMessage('Visualizar histórico');
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildMenuTile(
            icon: Icons.picture_as_pdf,
            title: 'Exportar Relatórios (PDF)',
            onTap: () {
              _showMessage('Exportar relatórios');
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildMenuTile(
            icon: Icons.alarm,
            title: 'Notificações e Alarmes',
            onTap: () {
              _showMessage('Configurar notificações');
            },
          ),
          const Divider(
            color: Color(0xFF2D1B36),
            height: 1,
          ),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Ajuda e Suporte',
            onTap: () {
              _showMessage('Acessar ajuda');
            },
          ),
        ],
      ),
    );
  }

  /// Constrói um tile de informação simples
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFF4081),
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Constrói um tile com switch
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: const Color(0xFFFF4081),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFFF4081),
      activeTrackColor: const Color(0xFFFF4081).withValues(alpha: 0.5),
    );
  }

  /// Constrói um tile clicável com subtítulo
  Widget _buildClickableTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFF4081),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  /// Constrói um tile de menu simples
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFF4081),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  /// Constrói o botão de logout
  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _showLogoutConfirmation();
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: const Text(
        'Sair da Conta',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    );
  }

  /// Mostra uma mensagem de feedback
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF4081),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Mostra diálogo para editar perfil
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final babyNameController = TextEditingController(text: _babyName);
    final babyBirthController = TextEditingController(text: _babyBirthDate);
    final babyWeightController = TextEditingController(text: _babyWeight);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de dados do usuário
              const Text(
                'Seus Dados',
                style: TextStyle(
                  color: Color(0xFFFF4081),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Campo Nome
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFFF4081)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFF4081), width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Campo Email
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFFF4081)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFF4081), width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Seção de dados do bebê
              const Text(
                'Dados do Bebê',
                style: TextStyle(
                  color: Color(0xFFFF4081),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Campo Nome do Bebê
              TextField(
                controller: babyNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome do Bebê',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.child_care, color: Color(0xFFFF4081)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFF4081), width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Campo Data de Nascimento
              TextField(
                controller: babyBirthController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.cake, color: Color(0xFFFF4081)),
                  hintText: 'DD/MM/AAAA',
                  hintStyle: const TextStyle(color: Colors.white30),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFF4081), width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Campo Peso
              TextField(
                controller: babyWeightController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso Atual',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.monitor_weight, color: Color(0xFFFF4081)),
                  hintText: 'Ex: 5.2 kg',
                  hintStyle: const TextStyle(color: Colors.white30),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFF4081), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.dispose();
              emailController.dispose();
              babyNameController.dispose();
              babyBirthController.dispose();
              babyWeightController.dispose();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Atualizar os dados
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
                _babyName = babyNameController.text;
                _babyBirthDate = babyBirthController.text;
                _babyWeight = babyWeightController.text;
              });
              
              Navigator.pop(context);
              _showMessage('Perfil atualizado com sucesso!');
              
              // Limpar os controllers
              nameController.dispose();
              emailController.dispose();
              babyNameController.dispose();
              babyBirthController.dispose();
              babyWeightController.dispose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4081),
            ),
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para escolher fonte da imagem (câmera ou galeria)
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Escolher Foto de Perfil',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFFFF4081),
              ),
              title: const Text(
                'Galeria',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: Color(0xFFFF4081),
              ),
              title: const Text(
                'Câmera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  /// Seleciona uma imagem da galeria ou câmera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        _showMessage('Foto de perfil atualizada!');
      }
    } catch (e) {
      _showMessage('Erro ao selecionar imagem: $e');
    }
  }

  /// Mostra diálogo de confirmação de logout
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D2A47),
        title: const Text(
          'Sair da Conta',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Você tem certeza que deseja sair da sua conta?',
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
              Navigator.pop(context);
              _showMessage('Saindo da conta...');
              // Aqui você implementaria a lógica de logout
            },
            child: Text(
              'Sair',
              style: TextStyle(color: Colors.red[400]),
            ),
          ),
        ],
      ),
    );
  }
}
