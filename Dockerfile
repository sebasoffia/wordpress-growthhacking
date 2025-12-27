# Dockerfile para Railway - WordPress con Apache MPM arreglado
FROM wordpress:latest

# Copiar script de fix
COPY fix-apache-mpm.sh /usr/local/bin/fix-apache-mpm.sh
RUN chmod +x /usr/local/bin/fix-apache-mpm.sh

# Ejecutar el fix DURANTE el build
RUN /usr/local/bin/fix-apache-mpm.sh

# Instalar dependencias adicionales
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Crear un wrapper del entrypoint original que ejecute el fix primero
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-original.sh

# Crear nuevo entrypoint que ejecuta el fix y luego el original
RUN echo '#!/bin/bash\n\
echo "🔧 Re-applying Apache MPM fix..."\n\
/usr/local/bin/fix-apache-mpm.sh\n\
echo "✅ Starting WordPress..."\n\
exec /usr/local/bin/docker-entrypoint-original.sh "$@"' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# Exponer puerto 80
EXPOSE 80

# Usar el entrypoint modificado
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
