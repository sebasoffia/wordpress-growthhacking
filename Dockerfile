# Dockerfile para Railway - WordPress con Apache MPM arreglado
FROM wordpress:latest

# Copiar script de fix de Apache
COPY docker-entrypoint-fix.sh /usr/local/bin/

# Hacer el script ejecutable
RUN chmod +x /usr/local/bin/docker-entrypoint-fix.sh

# Instalar dependencias adicionales
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Exponer puerto 80
EXPOSE 80

# Usar nuestro script personalizado como entrypoint
# Este script arreglará Apache cada vez que el contenedor inicie
ENTRYPOINT ["docker-entrypoint-fix.sh"]

# Comando por defecto
CMD ["apache2-foreground"]
