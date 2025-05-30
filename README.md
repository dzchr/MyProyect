## 🚀 Nagios Core - Docker Image

Este proyecto contiene una imagen Docker construida paso a paso desde una imagen base (debian:bullseye) para compilar e instalar Nagios Core 4.4.14, con todas sus dependencias. Está diseñada para ser reutilizable, portable y desplegable en ambientes cloud como AWS ECS.

## 📦 Contenido:

🏗️ Construcción de la imagen desde cero (multi-stage build)
👤 Usuario y grupo Nagios configurado
⚙️ Apache2 + PHP habilitado
🌐 Acceso web sin necesidad de /nagios
🔧 Puerto personalizado: 8080

## 🛠️ Pasos para construir la imagen:

🔁 Clona el repositorio:
Clona este repositorio con Git y accede al directorio de trabajo.

🧱 Construye la imagen Docker:
docker build -t nagios-core .

▶️ Ejecuta el contenedor:
docker run -d -p 8080:8080 --name nagios-test nagios-core

🌍 Accede desde tu navegador:
http://<IP-del-host>:8080

## 🔐 Credenciales por defecto

👤 Usuario: nagiosadmin
🔑 Contraseña: admin

## 📁 Estructura del repositorio

MyProyect/
├── Dockerfile
├── README.md
└── .gitignore

## 📋 Requisitos:

🐳 Docker Engine instalado
💻 Sistema compatible (Linux/macOS/WSL2)
🌐 Red local o pública para acceso vía IP

## 🧠 Notas finales
Esta imagen está lista para ser subida a un repositorio y desplegada en la nube. Permite acceder a Nagios directamente desde la IP en el puerto 8080.

Puedes modificar las configuraciones adicionales en:
/usr/local/nagios/etc/

## 🎓 Autor:
Christopher Cabrera González
📧 chr.cabrera@duocuc.cl
📚 Evaluación Parcial 2 - Tecnologías de Virtualización (DIY7111)

