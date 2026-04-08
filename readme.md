# Web Docker

Simple Docker based php web development environment.

## Basic usage

### Projects directory symlink

```bash
ln -s /home/user/projects ./www/projects
```

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