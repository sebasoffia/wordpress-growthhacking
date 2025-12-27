<?php
/**
 * Script temporal para actualizar URLs de WordPress en la base de datos
 * Subir a la raíz de WordPress y ejecutar visitando: https://growthhacking.cl/update-urls.php
 * ELIMINAR después de usar
 */

// Credenciales de base de datos desde variables de entorno
$db_host = getenv('WORDPRESS_DB_HOST') ?: 'mariadb.railway.internal:3306';
$db_name = getenv('WORDPRESS_DB_NAME') ?: 'railway';
$db_user = getenv('WORDPRESS_DB_USER') ?: 'railway';
$db_pass = getenv('WORDPRESS_DB_PASSWORD');

// Nueva URL del sitio
$new_url = 'https://growthhacking.cl';

// URL vieja que queremos reemplazar
$old_url = 'https://primary-production-479b.up.railway.app';

echo "<h1>🔧 WordPress URL Updater</h1>";
echo "<pre>";

try {
    // Conectar a la base de datos
    echo "📡 Conectando a la base de datos...\n";
    echo "Host: $db_host\n";
    echo "Database: $db_name\n";
    echo "User: $db_user\n\n";

    $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name);

    if ($mysqli->connect_error) {
        die("❌ Error de conexión: " . $mysqli->connect_error);
    }

    echo "✅ Conexión exitosa\n\n";

    // Actualizar siteurl
    echo "🔄 Actualizando 'siteurl'...\n";
    $query1 = "UPDATE wp_options SET option_value = '$new_url' WHERE option_name = 'siteurl'";
    if ($mysqli->query($query1)) {
        echo "✅ siteurl actualizado: $new_url\n";
    } else {
        echo "❌ Error: " . $mysqli->error . "\n";
    }

    // Actualizar home
    echo "🔄 Actualizando 'home'...\n";
    $query2 = "UPDATE wp_options SET option_value = '$new_url' WHERE option_name = 'home'";
    if ($mysqli->query($query2)) {
        echo "✅ home actualizado: $new_url\n";
    } else {
        echo "❌ Error: " . $mysqli->error . "\n";
    }

    // Verificar cambios
    echo "\n📋 Verificando URLs actuales:\n";
    $result = $mysqli->query("SELECT option_name, option_value FROM wp_options WHERE option_name IN ('siteurl', 'home')");

    while ($row = $result->fetch_assoc()) {
        echo "  • {$row['option_name']}: {$row['option_value']}\n";
    }

    echo "\n✅ ¡Actualización completada!\n";
    echo "\n🎯 Próximos pasos:\n";
    echo "1. Visita: $new_url/wp-admin\n";
    echo "2. Inicia sesión con tus credenciales\n";
    echo "3. ⚠️  IMPORTANTE: Elimina este archivo (update-urls.php) por seguridad\n";

    $mysqli->close();

} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage();
}

echo "</pre>";
?>
