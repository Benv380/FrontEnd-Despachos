CREATE DATABASE IF NOT EXISTS ventas_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS despachos_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

GRANT ALL PRIVILEGES ON ventas_db.* TO 'appuser'@'%';
GRANT ALL PRIVILEGES ON despachos_db.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
