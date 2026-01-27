import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  
  // Controllers para os campos de texto do usuário
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Controllers para informações dos bebês
  final List<Map<String, TextEditingController>> _babiesControllers = [];
  
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Adiciona um bebê por padrão
    _addBaby();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // Limpar controllers dos bebês
    for (var babyControllers in _babiesControllers) {
      babyControllers['name']?.dispose();
      babyControllers['ageInMonths']?.dispose();
      babyControllers['weightInKg']?.dispose();
    }
    super.dispose();
  }

  /// Adiciona um novo bebê à lista
  void _addBaby() {
    setState(() {
      _babiesControllers.add({
        'name': TextEditingController(),
        'ageInMonths': TextEditingController(),
        'weightInKg': TextEditingController(),
      });
    });
  }

  /// Remove um bebê da lista
  void _removeBaby(int index) {
    if (_babiesControllers.length > 1) {
      setState(() {
        _babiesControllers[index]['name']?.dispose();
        _babiesControllers[index]['ageInMonths']?.dispose();
        _babiesControllers[index]['weightInKg']?.dispose();
        _babiesControllers.removeAt(index);
      });
    }
  }

  /// Alterna entre modo Login e Cadastro
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      // Limpa o formulário ao alternar
      _formKey.currentState?.reset();
      
      // Se estiver indo para o cadastro e não houver bebês, adiciona um
      if (!_isLogin && _babiesControllers.isEmpty) {
        _addBaby();
      }
    });
  }

  /// Processa o login ou cadastro
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Se for cadastro, mostrar informações dos bebês
      if (!_isLogin) {
        for (int i = 0; i < _babiesControllers.length; i++) {
          final controllers = _babiesControllers[i];
          debugPrint('Bebê ${i + 1}: ${controllers['name']!.text}, '
              '${controllers['ageInMonths']!.text} meses, '
              '${controllers['weightInKg']!.text}kg');
        }
      }
      
      // Aqui você implementaria a lógica de autenticação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin ? 'Login realizado!' : 'Cadastro realizado com sucesso!'),
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
          
          // Informações dos bebês (apenas no cadastro)
          if (!_isLogin) ...[
            const SizedBox(height: 32),
            _buildBabiesSection(),
          ],
        ],
      ),
    );
  }

  /// Constrói a seção de informações dos bebês
  Widget _buildBabiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título da seção
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Informações do(s) Bebê(s)',
              style: TextStyle(
                color: Color(0xFFFF4081),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_babiesControllers.length < 3)
              IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFFFF4081),
                ),
                onPressed: _addBaby,
                tooltip: 'Adicionar outro bebê (gêmeos)',
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _babiesControllers.length > 1
              ? 'Cadastre as informações de cada bebê'
              : 'Preencha as informações do bebê',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        
        // Lista de bebês
        ...List.generate(_babiesControllers.length, (index) {
          return _buildBabyForm(index);
        }),
      ],
    );
  }

  /// Constrói o formulário para um bebê
  Widget _buildBabyForm(int index) {
    final controllers = _babiesControllers[index];
    final babyNumber = _babiesControllers.length > 1 ? ' ${index + 1}' : '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2A47).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF4081).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho do card do bebê
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.child_care,
                    color: Color(0xFFFF4081),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bebê$babyNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_babiesControllers.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => _removeBaby(index),
                  tooltip: 'Remover bebê',
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Nome do bebê
          _buildTextField(
            controller: controllers['name']!,
            label: 'Nome do Bebê',
            icon: Icons.baby_changing_station,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira o nome do bebê';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          // Idade em meses
          _buildTextField(
            controller: controllers['ageInMonths']!,
            label: 'Idade (meses)',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira a idade em meses';
              }
              final age = int.tryParse(value);
              if (age == null || age < 0 || age > 36) {
                return 'Idade deve estar entre 0 e 36 meses';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          // Peso em kg
          _buildTextField(
            controller: controllers['weightInKg']!,
            label: 'Peso (kg)',
            icon: Icons.monitor_weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira o peso do bebê';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight > 20) {
                return 'Peso deve estar entre 0 e 20 kg';
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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
