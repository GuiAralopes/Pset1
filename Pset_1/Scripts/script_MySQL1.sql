CREATE USER 'guiaraujo'@'localhost' IDENTIFIED BY 'pgdb123';

-- Criar o banco de dados e o esquema no MariaDB
CREATE SCHEMA uvv
--codificação UTF-8
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

--definir privilégios para o usuário
GRANT ALL PRIVILEGES ON uvv.* TO 'guiaraujo'@'localhost';
SYSTEM mysql -u guiaraujo -p;
