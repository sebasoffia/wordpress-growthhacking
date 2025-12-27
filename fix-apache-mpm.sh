#!/bin/bash
# Script que arregla Apache MPM - WordPress necesita mpm_prefork (no threaded)

echo "🔧 Fixing Apache MPM - enabling mpm_prefork for PHP compatibility..."

# Remover TODOS los MPMs primero
rm -f /etc/apache2/mods-enabled/mpm_*.conf
rm -f /etc/apache2/mods-enabled/mpm_*.load

# Activar SOLO mpm_prefork (compatible con PHP no-threadsafe)
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load

echo "✅ Apache MPM fixed - only mpm_prefork enabled (PHP-safe)"
ls -la /etc/apache2/mods-enabled/mpm_*
