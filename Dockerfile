# Dockerfile para Railway - WordPress con Apache MPM arreglado
FROM wordpress:latest

# Copiar script de fix
COPY fix-apache-mpm.sh /usr/local/bin/fix-apache-mpm.sh
RUN chmod +x /usr/local/bin/fix-apache-mpm.sh

# Deshabilitar MPMs no deseados ANTES de ejecutar el fix
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true

# Ejecutar el fix DURANTE el build
RUN /usr/local/bin/fix-apache-mpm.sh && echo "MPM configured during image build"

# Instalar dependencias adicionales
RUN apt-get update && apt-get install -y \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Crear un wrapper del entrypoint original que ejecute el fix primero
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-original.sh

# Crear nuevo entrypoint mejorado que ejecuta el fix JUSTO ANTES de Apache
RUN echo '#!/bin/bash\n\
set -e\n\
echo "🔧 Applying Apache MPM fix..."\n\
/usr/local/bin/fix-apache-mpm.sh\n\
echo ""\n\
echo "✅ Starting WordPress..."\n\
exec /usr/local/bin/docker-entrypoint-original.sh "$@"' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# Exponer puerto 80
EXPOSE 80

# Usar el entrypoint modificado
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
