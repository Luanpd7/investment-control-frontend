# 💰 Controle de Investimentos — Front-end

Aplicação web desenvolvida em Flutter para gerenciamento e acompanhamento de investimentos e patrimônio financeiro.

Este projeto é o **front-end** da aplicação e se comunica com uma API REST desenvolvida em Go.

## 🚀 Tecnologias

- **Flutter:** utilizado para desenvolvimento da interface da aplicação.
- **Dart:** linguagem utilizada no desenvolvimento do aplicativo Flutter.
- **Provider:** utilizado para gerenciamento de estado da aplicação.
- **Dio:** utilizado para realizar requisições HTTP e comunicação com a API.
- **REST API:** utilizada para comunicação entre o front-end e o back-end.
- **Clean Architecture:** utilizada para organização do código e separação de responsabilidades.
- **Git:** utilizado para controle de versão e gerenciamento das alterações do projeto.

## 📋 Funcionalidades

* Visualização do patrimônio total
* Visualização da reserva de emergência
* Acompanhamento de renda fixa
* Acompanhamento de renda variável
* Cadastro de registros de investimentos
* Consulta do histórico de investimentos
* Filtro por ano e mês
* Visualização da variação do patrimônio
* Gráficos de evolução do patrimônio
* Gráficos de crescimento por categoria
* Consulta dos anos disponíveis

## 🏗️ Arquitetura

O projeto utiliza **Clean Architecture** para organizar as responsabilidades da aplicação e facilitar a manutenção e evolução do código.

```text
lib/
│
├── data/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── presentation/
│
├── util/
│
└── main.dart
```

## 🔌 Integração com o Back-end

O front-end se comunica com uma API REST desenvolvida em **Go + Gin**, responsável pelo gerenciamento dos dados de investimentos.

### Back-end

[Link para o repositório do back-end]

Principais endpoints utilizados:

| Método | Endpoint                | Descrição                              |
| ------ | ----------------------- | -------------------------------------- |
| `POST` | `/saveInvestment`       | Salva um novo registro de investimento |
| `GET`  | `/getAllInvestment`     | Retorna os registros de investimentos  |
| `GET`  | `/dataDashboard`        | Retorna os dados do dashboard          |
| `GET`  | `/assetGrowth`          | Retorna o crescimento do patrimônio    |
| `GET`  | `/categoryGrowth`       | Retorna o crescimento por categoria    |
| `GET`  | `/availableYears`       | Retorna os anos disponíveis            |
| `GET`  | `/lastInvestmentRecord` | Retorna o último registro              |

