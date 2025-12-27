#!/bin/bash
# Script que arregla Apache MPM modificando archivos directamente

echo "🔧 Fixing Apache MPM by removing config files..."

# Remover archivos de configuración de MPMs conflictivos
rm -f /etc/apache2/mods-enabled/mpm_prefork.conf
rm -f /etc/apache2/mods-enabled/mpm_prefork.load
rm -f /etc/apache2/mods-enabled/mpm_worker.conf
rm -f /etc/apache2/mods-enabled/mpm_worker.load

# Asegurar que mpm_event esté habilitado
ln -sf /etc/apache2/mods-available/mpm_event.conf /etc/apache2/mods-enabled/mpm_event.conf
ln -sf /etc/apache2/mods-available/mpm_event.load /etc/apache2/mods-enabled/mpm_event.load

echo "✅ Apache MPM fixed - only mpm_event enabled"
ls -la /etc/apache2/mods-enabled/mpm_*
