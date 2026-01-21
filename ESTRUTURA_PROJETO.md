# 📱 Estrutura do Projeto

```
lib/
├── main.dart                              # Ponto de entrada do app
├── screens/
│   └── breastfeeding_tracker_screen.dart  # Tela principal de rastreamento
└── widgets/
    ├── side_button.dart                   # Botão circular com borda tracejada
    └── custom_bottom_nav.dart             # Bottom navigation customizada
```

## 🎨 Identidade Visual

### Cores Principais
- **Fundo Principal**: `#2D1B36` (Roxo profundo e escuro)
- **Destaque Rosa**: `#FF4081` (Rosa vibrante para botões e texto ativo)
- **Elementos Secundários**: `#4A3356` (Roxo médio para botões inativos)
- **Superfície**: `#3D2A47` (Roxo médio para cards e dialogs)

## 🚀 Funcionalidades Implementadas

### ✅ Tela de Rastreamento
- 3 abas (Amamentação, Mamadeira, Sólidos)
- Cronômetro funcional com formato MM:SS
- Dois botões circulares com bordas tracejadas
- Badge "Último Lado" indicando qual foi usado por último
- Alternância automática entre lados

### ✅ Lógica do Cronômetro
- Inicia ao pressionar um lado (Esquerdo/Direito)
- Pausa ao pressionar o mesmo lado novamente
- Alterna automaticamente ao pressionar o outro lado
- Controle de estado completo

### ✅ Elementos de UI
- Header com botão fechar, seletor de abas e ajuda
- Cronômetro central em rosa vibrante
- Botões circulares grandes com ícones de play/pause
- Bordas tracejadas usando pacote `dotted_border`
- Bottom navigation com 5 ícones
- Botão "Entrada Manual" no rodapé

### ✅ Diálogos
- Confirmação ao sair com cronômetro ativo
- Ajuda com instruções de uso
- Entrada manual (placeholder)

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  dotted_border: ^2.1.0  # Para bordas tracejadas
```

## 🏃 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Emulador iOS/Android ou dispositivo físico conectado

### Passos

1. **Instalar dependências**
```bash
flutter pub get
```

2. **Executar o app**
```bash
flutter run
```

3. **Executar testes**
```bash
flutter test
```

## 📱 Compatibilidade

- ✅ Android
- ✅ iOS
- ⚠️ Web (funcional mas otimizado para mobile)
- ⚠️ Desktop (funcional mas otimizado para mobile)

## 🎯 Próximas Funcionalidades (Sugestões)

- [ ] Persistência de dados (SQLite ou Hive)
- [ ] Histórico de amamentações
- [ ] Gráficos e estatísticas
- [ ] Notificações e lembretes
- [ ] Entrada manual de dados
- [ ] Sincronização em nuvem
- [ ] Modo escuro/claro
- [ ] Exportação de dados
- [ ] Múltiplos bebês
- [ ] Localização (i18n)

## 📝 Código Limpo e Comentado

Todo o código foi desenvolvido seguindo as melhores práticas:
- ✅ Comentários em português explicando cada componente
- ✅ Separação de responsabilidades (widgets, screens)
- ✅ Nomeação descritiva de variáveis e funções
- ✅ Uso de const para otimização
- ✅ StatefulWidget para gerenciamento de estado
- ✅ Código organizado e indentado

## 🛠️ Tecnologias

- **Flutter**: Framework principal
- **Dart**: Linguagem de programação
- **Material Design**: Componentes de UI
- **dotted_border**: Bordas tracejadas customizadas

---

Desenvolvido com ❤️ para a disciplina de Telemedicina - UFU
