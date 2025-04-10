#!/bin/bash
# DBName=nombre de la base de datos para wordpress
# DBUser=usuario de mariadb para wordpress
# DBPassword=contraseña para el usuario de mariadb para wordpress
# DBRootPassword=contraseña de root para mariadb

# PASO 1 - Configurar las variables de autenticación que se utilizan a continuación
DBName='blockstellartwordpress'
DBUser='blockstellartwordpress'
DBPassword='7m1m4l$4L1f3'
DBRootPassword='7m1m4l$4L1f3'

# PASO 2 - Instalar el software del sistema - incluyendo el servidor web y de base de datos
sudo dnf install wget php-mysqlnd httpd php-fpm php-mysqli mariadb105-server php-json php php-devel -y

# PASO 3 - Poner en línea los servidores web y de base de datos - y configurar para el inicio
sudo systemctl enable httpd
sudo systemctl enable mariadb
sudo systemctl start httpd
sudo systemctl start mariadb

# PASO 4 - Establecer la contraseña de root de Mariadb
sudo mysqladmin -u root password $DBRootPassword

# PASO 5 - Instalar Wordpress
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
sudo tar -zxvf latest.tar.gz
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
sudo rm latest.tar.gz

# PASO 6 - Configurar Wordpress
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php   
sudo chown apache:apache * -R

# PASO 7 - Crear la base de datos de Wordpress
echo "CREATE DATABASE $DBName;" >> /tmp/db.setup
echo "CREATE USER '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;" >> /tmp/db.setup
mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup

# PASO 8 - Navegar a http://your_instance_public_ipv4_ip