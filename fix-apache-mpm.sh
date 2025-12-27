#!/bin/bash
# Script que arregla Apache MPM - WordPress necesita mpm_prefork (no threaded)

echo "🔧 Fixing Apache MPM - enabling mpm_prefork for PHP compatibility..."

# Deshabilitar TODOS los MPMs usando a2dismod (método oficial)
a2dismod mpm_event 2>/dev/null || true
a2dismod mpm_worker 2>/dev/null || true
a2dismod mpm_prefork 2>/dev/null || true

# Remover cualquier symlink residual
rm -f /etc/apache2/mods-enabled/mpm_*.conf
rm -f /etc/apache2/mods-enabled/mpm_*.load

# Activar SOLO mpm_prefork usando a2enmod (método oficial)
a2enmod mpm_prefork

echo "✅ Apache MPM fixed - only mpm_prefork enabled (PHP-safe)"
echo "📋 MPM modules status:"
ls -la /etc/apache2/mods-enabled/mpm_* 2>/dev/null || echo "No MPM symlinks found"

# Verificar configuración de Apache
echo "🔍 Testing Apache configuration..."
apache2ctl configtest 2>&1 || echo "⚠️  Apache config test failed (this might be OK if ran during build)"
