# 💰 Controle de Investimentos — Front-end

Aplicação web desenvolvida em Flutter para gerenciamento e acompanhamento de investimentos e patrimônio financeiro.

O projeto permite registrar e acompanhar a evolução do patrimônio ao longo do tempo, separando os investimentos entre reserva de emergência, renda fixa e renda variável, além de disponibilizar indicadores e gráficos para análise.

Este repositório contém o front-end da aplicação, que consome uma API REST desenvolvida em Go (Golang).

## 🚀 Tecnologias

- **Flutter:** utilizado para desenvolvimento da interface da aplicação.
- **Dart:** linguagem utilizada no desenvolvimento do aplicativo Flutter.
- **Provider:** utilizado para gerenciamento de estado da aplicação.
- **Dio:** utilizado para realizar requisições HTTP e comunicação com a API.
- **REST API:** utilizada para comunicação entre o front-end e o back-end.
- **Clean Architecture:** utilizada para organização do código e separação de responsabilidades.
- **Git:** utilizado para controle de versão e gerenciamento das alterações do projeto.
- **Vercel:** hospedagem do front-end web.
- 
## 📋 Funcionalidades

* Dashboard com indicadores financeiros
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

O front-end consome uma API REST desenvolvida utilizando:

* Go (Golang)
* Gin
* PostgreSQL
* Clean Architecture
* Amazon EC2
* Amazon RDS
  
### Back-end

[https://github.com/Luanpd7/investment-control-backend-]

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

## ☁️ Fluxo de Comunicação

```text
Flutter Web
     │
     │ Dio / HTTPS
     ▼
Cloudflare Tunnel
     │
     ▼
Go REST API
AWS EC2
     │
     │ PostgreSQL
     ▼
AWS RDS
```

- **Flutter Web:** interface da aplicação responsável pela interação com o usuário.
- **Dio / HTTPS:** realiza as requisições HTTP para a API.
- **Cloudflare Tunnel:** fornece uma conexão HTTPS segura entre o front-end e o back-end.
- **AWS EC2:** hospeda e executa a API REST desenvolvida em **Go + Gin**.
- **AWS RDS:** hospeda o banco de dados **PostgreSQL**, responsável pela persistência dos dados.

## 🎯 Objetivo do Projeto

O projeto foi desenvolvido com o objetivo de aplicar e aprimorar conhecimentos em desenvolvimento **Full Stack e Cloud**, integrando front-end, back-end, banco de dados e infraestrutura em nuvem.

Além do desenvolvimento da aplicação, o projeto também teve como objetivo colocar em prática conhecimentos de **AWS**, realizando o deploy e a configuração da infraestrutura necessária para executar a aplicação em ambiente de nuvem.

Durante o desenvolvimento e deploy foram aplicados conceitos como:

- Desenvolvimento de APIs REST com **Go + Gin**
- **Clean Architecture**
- **PostgreSQL**
- Deploy de aplicações Go em **Amazon EC2**
- Hospedagem do PostgreSQL no **Amazon RDS**
- Configuração de **VPC**
- Utilização de **subnets públicas e privadas**
- Configuração de **Security Groups**
- Comunicação entre **EC2 e RDS**
- Configuração de regras de entrada e saída de rede
- Utilização de **Internet Gateway e Route Tables**
- Acesso e gerenciamento de instâncias EC2 via **SSH**
- Configuração de variáveis de ambiente no servidor
- Utilização do **Cloudflare Tunnel** para disponibilização da API via HTTPS
- Integração entre **Flutter Web, API REST e infraestrutura AWS**

Dessa forma, o projeto também serviu como ambiente prático para compreender como uma aplicação pode ser **implantada, configurada e executada na AWS**, abrangendo conceitos de infraestrutura, rede, segurança e computação em nuvem.
