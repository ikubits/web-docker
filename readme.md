# Web Docker

Simple Docker based php web development environment.

## Basic usage

### Projects directory symlink
Best way to use web-docker with external projects is to create symlink for projects directory.
```bash
ln -s /home/user/projects ./www/projects
```

### Add project vhost
Copy `example.test.conf` as `project-name.test.conf`.
Update it like:
```bash
<VirtualHost *:80>
    ServerName project-name.test
    DocumentRoot /var/www/html/project-name

    <Directory /var/www/html/project-name>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```
Container `/var/www/html`is bind to the local `./www/projects`.


## DB import/export

### MariaDB

#### import
```bash
docker exec -i mariadb-container mariadb -u root -proot db_name < ./example_path/db_name.sql
```

#### export
```bash
docker exec -i mariadb-container mariadb-dump -u root -proot db_name > ./example_path/db_name.sql
```

### MySQL

#### import
```bash
docker exec -i mysql-container mysql -u root -proot db_name < ./example_path/db_name.sql
```

#### export
```bash
docker exec -i mysql-container mysqldump -u root -proot db_name > ./example_path/db_name.sql
```