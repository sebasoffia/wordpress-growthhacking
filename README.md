# WordPress con Apache MPM arreglado

WordPress optimizado para Railway con Apache MPM configurado correctamente.

## Fix implementado

- Apache MPM Event activado (mejor rendimiento)
- MPM Prefork y Worker desactivados (evita conflictos)
- Optimizado para servir imágenes desde Cloudflare R2

## Despliegue en Railway

Este proyecto está configurado para desplegarse automáticamente en Railway usando el Dockerfile incluido.
