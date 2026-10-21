CREATE DATABASE IF NOT EXISTS example_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'example_user'@'%' IDENTIFIED BY 'example_secure_password';
GRANT ALL PRIVILEGES ON example_db.* TO 'example_user'@'%';