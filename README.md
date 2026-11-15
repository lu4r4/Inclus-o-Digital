# 📱 Aplicativo de Inclusão Digital - Apoio à Comunidade

Aplicação web desenvolvida em **Flutter** com o objetivo de promover a inclusão digital de idosos, facilitando o acesso a centros de estudo presenciais, utilidades governamentais, serviços de saúde e emergência, além de inscrições em aulas.

---

## ✨ Funcionalidades Principais

1. **Locais de Estudos Presenciais:** 
   * Listagem de centros de apoio e polos de inclusão com moradas/ruas e bairros detalhados.
2. **Tutoriais Práticos (Passo a Passo):** 
   * Guias essenciais focados na autonomia do público sénior, destacando:
     * Como chamar uma ambulância (**SAMU 192**).
     * Como utilizar o aplicativo **Gov.br**.
     * Como utilizar o aplicativo **Saúde Já**.
3. **Cadastro para Aulas:** 
   * Formulário intuitivo e acessível para a inscrição rápida em cursos de informática básica e cidadania digital.

---

## 🛠️ Tecnologias Utilizadas

* **Frontend:** Flutter Web (Dart)
* **Backend:** Node.js / Express (API para recuperação de dados locais e de tutoriais)
* **Ambiente de Desenvolvimento:** GitHub Codespaces / VS Code

---

## 📁 Estrutura do Projeto

```text
inclusao_digital_app/
├── lib/
│   ├── models/        # Modelos de dados (ex: tutorial_model.dart)
│   ├── services/      # Comunicação com a API Node.js (ex: tutorial_service.dart)
│   ├── widgets/       # Componentes visuais reutilizáveis (ex: tutorial_card_widget.dart)
│   └── main.dart      # Ponto de entrada e rotas principais (BottomNavigationBar)
├── pubspec.yaml       # Dependências e configurações do projeto Flutter
└── README.md          # Documentação do projeto
