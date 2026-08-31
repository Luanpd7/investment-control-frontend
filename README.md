# 💰 Controle de investimento

API REST desenvolvida em Go para gerenciamento e acompanhamento de
investimentos e patrimônio financeiro.

## 🚀 Tecnologias

- Go
- Gin
- PostgreSQL
- REST API
- Clean Architecture
- Git

## 📋 Funcionalidades

- Cadastro de registros de investimentos
- Consulta do patrimônio
- Consulta do histórico de investimentos
- Filtro por ano e mês
- Cálculo de variação do patrimônio
- Consulta por categoria de investimento

## 🏗️ Arquitetura

O projeto utiliza Clean Architecture para separar as responsabilidades
da aplicação.

```text
financial-independence/
│
├── data/
│   ├── database/
│   │
│   └── repository/     
│
├── domain/
│   ├── entities/
│   │
│   ├── repositories/
│   │
│   └── usecase/
│
├── handlers/
│
└── routes/
```
## 🔌 Endpoints

A API disponibiliza os seguintes endpoints:

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/saveInvestment` | Salva um novo registro de investimento |
| `GET` | `/getAllInvestment` | Retorna todos os registros de investimentos |
| `GET` | `/dataDashboard` | Retorna os dados utilizados no dashboard |
| `GET` | `/assetGrowth` | Retorna os dados de crescimento do patrimônio |
| `GET` | `/categoryGrowth` | Retorna o crescimento dos investimentos por categoria |
| `GET` | `/availableYears` | Retorna os anos disponíveis nos registros |
| `GET` | `/lastInvestmentRecord` | Retorna o último registro de investimento |
