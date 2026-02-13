# 💰 FinOps on AWS – Cost Optimization & Cloud Financial Governance

![finops](FinOps_AWS.jpg)

---

## 📌 Sobre o Projeto

Este projeto implementa práticas de FinOps em ambiente AWS, com foco em:

- Monitoramento de custos em tempo real
- Alertas de billing automatizados
- Identificação de recursos ociosos
- Rightsizing de instâncias
- Comparação entre On-Demand vs Spot
- Estratégia de redução de custos sem impacto operacional

O objetivo é simular um ambiente corporativo onde governança financeira cloud é prioridade.

---

# 🏗️ Arquitetura da Solução

## Componentes Utilizados

- AWS Cost Explorer
- AWS Budgets
- AWS CloudWatch
- AWS Compute Optimizer
- EC2 On-Demand
- EC2 Spot Instances
- EKS Cluster
- Lambda para automações
- SNS para alertas

---

# 📊 Estratégia Implementada

## 1️⃣ Monitoramento de Custos

- Dashboard no Cost Explorer
- Métricas por:
  - Serviço
  - Tag
  - Ambiente
  - Conta

Tagging Strategy obrigatória:

- Environment
- Owner
- Application
- CostCenter

---

## 2️⃣ Alertas de Billing

- AWS Budget configurado
- Alertas automáticos via SNS
- Notificação quando atingir:
  - 50%
  - 80%
  - 100% do orçamento

---

## 3️⃣ Rightsizing

Uso do AWS Compute Optimizer para:

- Identificar instâncias subutilizadas
- Sugerir downgrade
- Analisar savings estimados

---

## 4️⃣ Spot vs On-Demand Comparison

Simulação com:

- Workload tolerante a interrupção → Spot
- Workload crítico → On-Demand

Análise comparativa:

| Tipo | Custo | Disponibilidade |
|------|-------|----------------|
| On-Demand | Alto | Alta |
| Spot | Baixo | Variável |

---

## 5️⃣ Automação com Lambda

Funções automatizadas para:

- Desligar instâncias fora do horário comercial
- Identificar recursos sem tag
- Enviar relatórios semanais de custo

---

# 🔐 Governança Aplicada

- Tag enforcement policy
- IAM restritivo
- Separação de contas por ambiente
- Controle de acesso a billing

---

# 📈 Métricas Avaliadas

- Custo mensal total
- Custo por aplicação
- Custo por ambiente
- Economia estimada com Spot
- Economia estimada com Rightsizing

---

# 🧠 Decisões Técnicas

- Separação de workloads críticos e não críticos
- Uso estratégico de Spot
- Automação para evitar desperdício
- Cultura FinOps aplicada na arquitetura

---

# 📚 Aprendizados Aplicados

- Governança financeira em cloud
- Estratégias reais de redução de custo
- Monitoramento avançado de billing
- Automação de economia

---

# 🎯 Foco do Projeto

Cloud Engineer  
FinOps Engineer  
Cloud Architect  
DevOps com foco em custo  

---

> Este projeto demonstra aplicação prática de FinOps em ambiente AWS, simulando governança financeira em cloud corporativa.
