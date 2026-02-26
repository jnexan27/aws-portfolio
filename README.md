# ☁️ AWS Portfolio - Jesus Manzanilla

[![AWS](https://img.shields.io/badge/AWS-S3%20%26%20CloudFront-orange?style=flat-square&logo=amazonaws)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-blue?style=flat-square&logo=github-actions)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

Este repositorio contiene el código fuente y la configuración de mi portafolio profesional, diseñado bajo una arquitectura **Serverless** y desplegado automáticamente en **Amazon Web Services (AWS)**.

---

## 🏗️ Arquitectura del Proyecto

El proyecto utiliza un enfoque moderno de infraestructura como código y servicios administrados para garantizar alta disponibilidad, seguridad y bajo costo.

- **Amazon S3**: Aloja los archivos estáticos del sitio (HTML, CSS, JS).
- **Amazon CloudFront**: Actúa como CDN para distribuir el contenido globalmente con baja latencia.
- **AWS OAC (Origin Access Control)**: Restringe el acceso al bucket S3 para que solo CloudFront pueda leer los objetos.
- **GitHub Actions**: Pipeline de CI/CD para automatizar el despliegue ante cada cambio en la rama `main`.

---

## 🚀 Características Clave

- **Seguridad**: HTTPS forzado y origen privado (S3 no público).
- **Rendimiento**: Aprovecha el almacenamiento en caché del edge de CloudFront.
- **Automatización**: Despliegue continuo sin intervención manual.
- **Operación Simple**: Sin servidores que parchar o escalar.

---

## 🛠️ Tecnologías Utilizadas

- **Frontend**: HTML5, Vanilla CSS, Simple.css.
- **Infraestructura**: AWS (S3, CloudFront, IAM).
- **IaC (Infraestructura como Código)**: Terraform (proveedor de AWS).
- **CI/CD**: GitHub Actions.
- **Control de Versiones**: Git & GitHub.

---

## 📖 Cómo desplegar este proyecto

### 1. Despliegue de Infraestructura (Terraform)
La infraestructura está definida como código en la carpeta `/terraform`.

1. Instala [Terraform](https://developer.hashicorp.com/terraform/downloads) y configura tus credenciales de AWS localmente (`aws configure`).
2. Entra al directorio: `cd terraform`
3. Inicializa el proyecto: `terraform init`
4. Revisa los cambios propuestos: `terraform plan`
5. Aplica los cambios en AWS: `terraform apply`

### 2. Despliegue del Frontend (CI/CD)
1. **GitHub Actions**: Al hacer push a la rama `main`, el workflow se conectará vía OIDC asumiendo el rol adecuado.
2. Sincronizará el HTML y CSS al S3 creado por Terraform.
3. Invalidará la caché de CloudFront automáticamente.

---

## 👤 Autor

**Jesus Manzanilla**
*DevOps | Especialista en AWS*



---
*Este proyecto es parte de mi camino de aprendizaje como DevOps Engineer.*
