#!/bin/bash
set -e

echo "🔧 Fixing Apache MPM configuration..."

# Desactivar MPMs duplicados
echo "  → Disabling mpm_prefork..."
a2dismod mpm_prefork 2>/dev/null || true

echo "  → Disabling mpm_worker..."
a2dismod mpm_worker 2>/dev/null || true

echo "  → Disabling mpm_event (to re-enable cleanly)..."
a2dismod mpm_event 2>/dev/null || true

# Activar solo mpm_event
echo "  → Enabling mpm_event..."
a2enmod mpm_event

# Verificar configuración
echo "  → Testing Apache configuration..."
apache2ctl configtest || true

echo "✅ Apache MPM fixed! Starting WordPress..."

# Ejecutar el entrypoint original de WordPress
exec docker-entrypoint.sh "$@"
