
CREATE USER 'sdi'@'localhost' IDENTIFIED BY 'sdipassword';
GRANT ALL PRIVILEGES ON * . * TO 'sdi'@'localhost';
FLUSH PRIVILEGES;

create database MRDD;
use MRDD;

CREATE TABLE Author (
   id INT,
   name VARCHAR(25),
   PRIMARY KEY (id)
);