# ☁️ AWS Portfolio - Jesus Manzanilla

[![AWS](https://img.shields.io/badge/AWS-Serverless-orange?style=flat-square&logo=amazonaws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-purple?style=flat-square&logo=terraform)](https://www.terraform.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-blue?style=flat-square&logo=github-actions)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

Este repositorio contiene el código fuente y la infraestructura como código de mi portafolio profesional, diseñado bajo una arquitectura **Serverless** y gestionado con **Terraform** en **Amazon Web Services (AWS)**.

---

## 🏗️ Arquitectura del Proyecto

La arquitectura combina una capa estática (Frontend en S3 + CloudFront) con una capa dinámica (Backend Serverless para el formulario de contacto).

### Frontend (Sitio Estático)
- **Amazon S3**: Aloja los archivos estáticos (HTML, CSS). Bucket privado, sin acceso público directo.
- **Amazon CloudFront**: CDN global con HTTPS forzado y OAC para acceso seguro al bucket S3.

### Backend Serverless (Formulario de Contacto)
- **Amazon API Gateway (HTTP API)**: Punto de entrada HTTPS público para el formulario web.
- **AWS Lambda (Node.js 18)**: Función sin servidor que valida y procesa los mensajes del formulario.
- **Amazon SNS**: Entrega las notificaciones directamente al correo personal del propietario.

### Infraestructura (IaC con Terraform)
- **Terraform**: Gestiona todos los recursos de AWS de forma automatizada y versionada.
- **S3 Remote State**: El estado de Terraform se guarda de forma segura en un bucket S3 separado con versionamiento.
- **DynamoDB State Locking**: Una tabla DynamoDB actúa como "candado" para prevenir la corrupción del estado en ejecuciones concurrentes.

---

## 🚀 Características Clave

- **Serverless Total**: Sin servidores EC2 que administrar, parchar o escalar.
- **Seguridad**: HTTPS forzado, S3 privado (OAC), IAM con mínimo privilegio, OIDC para GitHub Actions.
- **Rendimiento**: CloudFront distribuye el contenido desde el edge más cercano al usuario.
- **Automatización**: CI/CD con GitHub Actions y toda la infraestructura descrita como código (IaC).
- **Costo Zero**: Operación dentro del free tier de AWS. AWS Budgets configurado para alertar ante cualquier costo inesperado.

---

## 🛠️ Stack Tecnológico

| Capa | Servicio | Propósito |
|---|---|---|
| CDN / Hosting | S3 + CloudFront + OAC | Sitio web estático, seguro y global |
| Backend | API Gateway + Lambda + SNS | Formulario de contacto sin servidores |
| IaC | Terraform | Gestión automatizada de infraestructura |
| IaC State | S3 + DynamoDB | Remote State y State Locking |
| CI/CD | GitHub Actions + OIDC | Despliegue automático ante cada push |
| Seguridad | IAM + Budgets + CloudWatch | Acceso mínimo privilegio y FinOps |

---

## 📖 Cómo desplegar este proyecto

### 1. Pre-requisitos
- Instala [Terraform](https://developer.hashicorp.com/terraform/downloads) y configura AWS CLI (`aws configure`).
- Configura los secrets de GitHub Actions (`AWS_ROLE_ARN`, `CLOUDFRONT_DISTRIBUTION_ID`).

### 2. Despliegue de Infraestructura (Terraform)
```bash
cd terraform
terraform init    # Inicializa el backend remoto (S3 + DynamoDB)
terraform plan    # Revisa los cambios propuestos
terraform apply   # Aprovisiona todos los recursos AWS
```

### 3. Despliegue del Frontend (CI/CD)
Al hacer `git push` a la rama `main`, GitHub Actions:
1. Se conecta a AWS de forma segura vía **OIDC** (sin claves estáticas).
2. Sincroniza el HTML y CSS al bucket S3.
3. Invalida la caché de CloudFront automáticamente.

---

## 👤 Autor

**Jesus Manzanilla**
*DevOps Engineer | Cloud Specialist AWS*

---
*Este proyecto es parte de mi camino de aprendizaje como Cloud & DevOps Engineer.*
