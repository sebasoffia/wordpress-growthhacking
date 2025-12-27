# Dockerfile para Railway - WordPress con Apache MPM arreglado
FROM wordpress:latest

# Copiar script de fix de Apache
COPY docker-entrypoint-fix.sh /usr/local/bin/docker-entrypoint-fix.sh

# Hacer el script ejecutable
RUN chmod +x /usr/local/bin/docker-entrypoint-fix.sh && \
    ls -la /usr/local/bin/docker-entrypoint-fix.sh

# Arreglar Apache MPM directamente en la imagen
RUN a2dismod mpm_prefork mpm_worker || true && \
    a2enmod mpm_event && \
    echo "MPM modules configured during build"

# Instalar dependencias adicionales
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Exponer puerto 80
EXPOSE 80

# Usar nuestro script personalizado como entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-fix.sh"]

# Comando por defecto
CMD ["apache2-foreground"]
