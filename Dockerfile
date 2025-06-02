# Etapa 1: Compilación (builder)
# En esta primera etapa se descargan y compilan los archivos fuente de Nagios.
# Aquí se usan herramientas de desarrollo que no se incluirán en la imagen final.
FROM debian:12-slim AS builder

ARG NAGIOS_VERSION=4.4.14
ENV DEBIAN_FRONTEND=noninteractive

# Instala herramientas necesarias para compilar Nagios desde el código fuente
RUN apt-get update && apt-get install -y \
    wget ca-certificates build-essential \
    autoconf gcc libc6 make libgd-dev libssl-dev \
    libmcrypt-dev unzip perl tar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea los usuarios y grupos que Nagios necesita para instalarse correctamente
RUN groupadd -r nagios && \
    groupadd -r nagcmd && \
    useradd -r -g nagios -d /opt/nagios -s /bin/bash nagios && \
    usermod -aG nagcmd nagios

WORKDIR /tmp

# Descarga el archivo comprimido con el código fuente de Nagios
RUN wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-${NAGIOS_VERSION}.tar.gz && \
    tar -xzf nagios-${NAGIOS_VERSION}.tar.gz

# Compila e instala Nagios
WORKDIR /tmp/nagios-${NAGIOS_VERSION}
RUN ./configure \
    --prefix=/opt/nagios \
    --enable-event-broker \
    --with-nagios-user=nagios \
    --with-nagios-group=nagios \
    --with-command-user=nagios \
    --with-command-group=nagcmd && \
    make all && \
    make install && \
    make install-config && \
    make install-commandmode

# Etapa 2: Imagen final (ejecución)
# Aquí se construye la imagen final con solo lo necesario para ejecutar Nagios.

FROM debian:12-slim

# Información del creador de esta imagen Docker
LABEL maintainer="Christopher Cabrera <chr.cabrera@duocuc.cl>" \
      description="Imagen Docker personalizada de Nagios Core"

ENV NAGIOS_HOME=/opt/nagios \
    NAGIOS_USER=nagios \
    NAGIOS_GROUP=nagios \
    NAGIOS_CMDGROUP=nagcmd \
    NAGIOSADMIN_USER=nagiosadmin \
    NAGIOSADMIN_PASS=admin123 \
    DEBIAN_FRONTEND=noninteractive

# Instala Apache, PHP y los plugins básicos de monitoreo
RUN apt-get update && apt-get install -y \
    apache2 apache2-utils php libapache2-mod-php \
    iputils-ping monitoring-plugins-basic ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea los usuarios y grupos necesarios para que Nagios funcione
RUN groupadd -r ${NAGIOS_GROUP} && \
    groupadd -r ${NAGIOS_CMDGROUP} && \
    useradd -r -g ${NAGIOS_GROUP} -d ${NAGIOS_HOME} -s /bin/bash ${NAGIOS_USER} && \
    usermod -aG ${NAGIOS_CMDGROUP} ${NAGIOS_USER} && \
    usermod -aG ${NAGIOS_CMDGROUP} www-data

# Copia los archivos compilados de Nagios desde la etapa anterior
COPY --from=builder /opt/nagios /opt/nagios
COPY --from=builder /tmp/nagios-4.4.14/sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

# Activa la configuración de Nagios en Apache
RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/nagios.conf && \
    a2dissite 000-default && \
    a2enmod rewrite cgi

# Copia los plugins de monitoreo y ajusta permisos
RUN mkdir -p ${NAGIOS_HOME}/libexec && \
    cp /usr/lib/nagios/plugins/check_* ${NAGIOS_HOME}/libexec/ && \
    chown -R ${NAGIOS_USER}:${NAGIOS_GROUP} ${NAGIOS_HOME}/libexec

# Crea el usuario web para acceder a la interfaz
RUN htpasswd -cb ${NAGIOS_HOME}/etc/htpasswd.users ${NAGIOSADMIN_USER} ${NAGIOSADMIN_PASS}

# Script de arranque que inicia Apache y Nagios
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Iniciando Nagios..."\n\
chown -R nagios:nagios /opt/nagios\n\
rm -f /opt/nagios/var/nagios.lock /opt/nagios/var/rw/nagios.cmd || true\n\
mkfifo /opt/nagios/var/rw/nagios.cmd || true\n\
chown nagios:nagcmd /opt/nagios/var/rw/nagios.cmd\n\
chmod 660 /opt/nagios/var/rw/nagios.cmd\n\
apache2ctl start\n\
exec /opt/nagios/bin/nagios /opt/nagios/etc/nagios.cfg\n' > /start-nagios.sh && chmod +x /start-nagios.sh

# Expone el puerto web y define volúmenes para configuración y datos
EXPOSE 80
VOLUME ["/opt/nagios/etc", "/opt/nagios/var"]
CMD ["/start-nagios.sh"]

