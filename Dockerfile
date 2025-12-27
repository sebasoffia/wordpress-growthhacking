# Dockerfile para Railway - WordPress con Apache MPM arreglado
FROM wordpress:latest

# Arreglar Apache MPM antes de iniciar
RUN set -ex; \
    # Desactivar MPMs duplicados
    a2dismod mpm_prefork || true; \
    a2dismod mpm_worker || true; \
    # Activar solo mpm_event (mejor para WordPress)
    a2enmod mpm_event; \
    # Verificar configuración
    apache2ctl configtest || true

# Instalar dependencias adicionales si es necesario
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar configuración personalizada de Apache (opcional)
# COPY apache-config.conf /etc/apache2/conf-available/custom.conf
# RUN a2enconf custom

# El resto de la configuración de WordPress se maneja por la imagen base
EXPOSE 80

# Usar el entrypoint original de WordPress
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
