import 'package:flutter/material.dart';

/// Tela de autenticação que alterna dinamicamente entre Login e Cadastro
/// Utiliza AnimatedSwitcher para transições suaves entre os estados
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controle de estado: true = Login, false = Cadastro
  bool _isLogin = true;
  
  // Controle de visibilidade da senha
  bool _obscurePassword = true;
  
  // Controllers para os campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Alterna entre modo Login e Cadastro
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      // Limpa o formulário ao alternar
      _formKey.currentState?.reset();
    });
  }

  /// Processa o login ou cadastro
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui você implementaria a lógica de autenticação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin ? 'Login realizado!' : 'Cadastro realizado!'),
          backgroundColor: const Color(0xFFFF4081),
        ),
      );
      
      // Navega para a tela principal após autenticação
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B36),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo centralizada
                _buildLogo(),
                
                const SizedBox(height: 40),
                
                // Título dinâmico
                _buildTitle(),
                
                const SizedBox(height: 40),
                
                // Campos de entrada com animação
                _buildFormFields(),
                
                const SizedBox(height: 32),
                
                // Botão principal
                _buildSubmitButton(),
                
                const SizedBox(height: 16),
                
                // Alternador de estado (Login/Cadastro)
                _buildToggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói a logo centralizada
  Widget _buildLogo() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          'assets/logo_circularsf.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback caso a imagem não seja encontrada
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4081),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.child_care,
                size: 60,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Constrói o título dinâmico
  Widget _buildTitle() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _isLogin ? 'Bem-vindo de volta' : 'Crie sua conta',
        key: ValueKey<bool>(_isLogin),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Constrói os campos de formulário com animação
  Widget _buildFormFields() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey<bool>(_isLogin),
        children: [
          // Campo Nome (apenas no cadastro)
          if (!_isLogin) ...[
            _buildTextField(
              controller: _nameController,
              label: 'Nome',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                if (value.length < 3) {
                  return 'Nome deve ter pelo menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Campo E-mail
          _buildTextField(
            controller: _emailController,
            label: 'E-mail',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu e-mail';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Por favor, insira um e-mail válido';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Campo Senha
          _buildTextField(
            controller: _passwordController,
            label: 'Senha',
            icon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua senha';
              }
              if (value.length < 6) {
                return 'Senha deve ter pelo menos 6 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Constrói um campo de texto customizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFFF4081),
        ),
        // Ícone de visibilidade da senha
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        // Estilo do campo
        filled: true,
        fillColor: const Color(0xFF3D2A47),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFFF4081),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  /// Constrói o botão principal (ENTRAR/CADASTRAR)
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF4081),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        shadowColor: const Color(0xFFFF4081).withValues(alpha: 0.5),
      ),
      child: Text(
        _isLogin ? 'ENTRAR' : 'CADASTRAR',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Constrói o botão de alternância (Login/Cadastro)
  Widget _buildToggleButton() {
    return TextButton(
      onPressed: _toggleAuthMode,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: _isLogin 
                  ? 'Não tem uma conta? ' 
                  : 'Já possui uma conta? ',
            ),
            TextSpan(
              text: _isLogin ? 'Cadastre-se' : 'Faça Login',
              style: const TextStyle(
                color: Color(0xFFFF4081),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
