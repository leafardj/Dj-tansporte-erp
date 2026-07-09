# 🚛 DJ Transportes ERP

Sistema inteligente de gestão de transportadoras, desenvolvido para controlar viagens, abastecimentos, despesas, manutenção da frota e resultados financeiros.

## 📋 Sobre o Projeto

O DJ Transportes ERP nasceu para facilitar o dia a dia de transportadoras e motoristas, reunindo em um único aplicativo todas as informações da operação.

O sistema funcionará **offline**, sincronizando os dados automaticamente quando houver internet.

---

## ✨ Principais Recursos

### 🚛 Gestão de Viagens
- Cadastro de viagens
- Origem e destino
- Cliente
- Motorista
- Caminhão
- Quilometragem inicial e final
- Valor do frete

### ⛽ Combustíveis
- Controle de Diesel
- Controle de Arla 32
- Histórico de abastecimentos
- Consumo médio (km/L)

### 💰 Financeiro
- Custo da viagem
- Custo por quilômetro
- Lucro líquido
- Margem de lucro
- Contas a receber

### 🚚 Frota
- Cadastro de caminhões
- Controle de manutenção
- Alertas de revisão
- Documentação dos veículos

### 👨 Motoristas
- Cadastro completo
- Histórico de viagens
- Desempenho

### 👥 Clientes
- Cadastro completo
- Histórico de fretes

---

## 📊 Dashboard

O painel principal exibirá:

- Faturamento do mês
- Lucro do mês
- Viagens em andamento
- Gasto com Diesel
- Gasto com Arla
- Custo médio por KM
- Alertas de manutenção

---

## 🛠️ Tecnologias

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| Flutter | 3.5+ | Framework UI multiplataforma |
| Dart | 3.5+ | Linguagem de programação |
| SQLite | 2.4.1 | Banco de dados local (offline) |
| Firebase | 3.8.0+ | Autenticação e sincronização |
| Provider | 6.1.2 | Gerenciamento de estado |
| FL Chart | 0.69.0 | Gráficos e visualizações |
| PDF | 3.11.1 | Geração de relatórios |

---

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/          # Constantes globais
│   ├── theme/              # Temas e estilos
│   └── utils/              # Funções utilitárias
│
├── database/               # SQLite e operações de BD
│
├── models/                 # Modelos de dados
│
├── services/               # Lógica de negócio
│
├── screens/                # Telas da aplicação
│   ├── login/
│   ├── dashboard/
│   ├── viagens/
│   ├── clientes/
│   ├── motoristas/
│   ├── caminhoes/
│   ├── abastecimento/
│   ├── financeiro/
│   ├── manutencao/
│   └── relatorios/
│
├── widgets/                # Componentes reutilizáveis
│
├── app.dart                # Configuração da app
└── main.dart               # Ponto de entrada
```

---

## 🚀 Começando

### Pré-requisitos
- Flutter 3.5.0 ou superior
- Dart 3.5.0 ou superior
- Git

### Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/leafardj/Dj-tansporte-erp.git
cd dj-transportes-erp
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Execute a aplicação:**
```bash
flutter run
```

### Configuração Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie um novo projeto
3. Configure autenticação (Email/Password)
4. Configure Firestore Database
5. Baixe as configurações e coloque nos diretórios Android/iOS/Web

---

## 📅 Roadmap

### Versão 1.0 ✅
- [x] Estrutura base da aplicação
- [x] Dashboard inicial
- [ ] Login e autenticação
- [ ] Clientes (CRUD)
- [ ] Caminhões (CRUD)
- [ ] Motoristas (CRUD)
- [ ] Viagens (CRUD)
- [ ] Controle de Diesel
- [ ] Controle de Arla
- [ ] Relatórios básicos

### Versão 2.0 🔄
- [ ] GPS em tempo real
- [ ] Controle de pneus
- [ ] Painel Web
- [ ] Backup automático
- [ ] Inteligência Artificial
- [ ] Notificações push

### Versão 3.0 📋
- [ ] App de motorista (versão específica)
- [ ] Integração com sistemas de frete
- [ ] Análise preditiva de manutenção
- [ ] Gestão de documentos digitais

---

## 👨‍💼 Idealizador

**Rafael Dela Justina**

---

## 🤝 Desenvolvimento

Projeto desenvolvido com apoio do ChatGPT (OpenAI) e GitHub Copilot.

---

## 📝 Licença

Este projeto é propriedade intelectual de Rafael Dela Justina.

---

## 📞 Suporte

Para reportar bugs ou sugerir melhorias, abra uma [issue](https://github.com/leafardj/Dj-tansporte-erp/issues).

---

**DJ Transportes ERP** — Gestão inteligente para quem vive na estrada. 🚛
