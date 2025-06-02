# 🚀 Nagios Core - Docker Image Personalizada

Este proyecto contiene una imagen Docker construida para **Nagios Core 4.4.14**, utilizando una base Debian (`debian:12-slim`) y el método de compilación por etapas (multi-stage build). Está diseñada para ser **ligera, reutilizable y lista para producción**, incluyendo una configuración funcional de Apache2 y los plugins necesarios.

## 📦 Características principales

- 🏗️ **Compilación completa desde fuentes** con `make` y `configure`
- 👤 **Usuarios y grupos personalizados** (`nagios`, `nagcmd`)
- ⚙️ **Apache2 + PHP integrados** con CGI habilitado
- 🌐 **Interfaz accesible directamente** desde `http://<IP>:8080`
- 📂 **Estructura de volúmenes** definida para configuración y datos (`/opt/nagios/etc`, `/opt/nagios/var`)
- 🔒 **Autenticación HTTP básica** ya configurada

## 🛠️ Pasos para construir y ejecutar localmente

### 1. 🔁 Clona este repositorio
```bash
git clone https://github.com/dzchr/MyProyect.git
cd MyProyect

### 2. 🧱 Construye la imagen Docker
docker build -t nagios-core .

### 3. ▶️ Ejecuta el contenedor
docker run -d -p 8080:80 --name nagios-test nagios-core

### 4. 🌍 Accede a la interfaz web
Navega a:
http://<IP-de-tu-host>:8080

## 🔐 Credenciales por defecto

👤 Usuario: nagiosadmin
🔑 Contraseña: admin123

Puedes modificar estas credenciales en el archivo htpasswd.users.

## 📁 Estructura del repositorio
<pre>
MyProyect/
    ├── Dockerfile
    ├── README.md
    └── .gitignore
</pre>

## 📋 Requisitos

### 🐳 Docker Engine (v20 o superior)
### 💻 Linux/macOS/WSL2 con terminal bash
### 🌐 Acceso de red para visualizar interfaz

## 🎓 Autor
### Christopher Cabrera González
📧 chr.cabrera@duocuc.cl
📘 Duoc UC – Ingeniería en Infraestructura y Plataformas Tecnológicas
🧪 Evaluación Parcial 2 – Asignatura: Tecnologías de Virtualización (DIY7111)
