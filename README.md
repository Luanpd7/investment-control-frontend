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
