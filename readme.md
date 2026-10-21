# Web Docker Dev Environment

A simplified, centralized Docker-based PHP and MariaDB development environment designed to host multiple projects on a single server setup.


## 🚀 Getting Started

The easiest way to interact with the environment is using the included bash script (`web-docker.sh`), which automatically handles your local user permissions.

### 💡 Pro Tip: Set Up a Global Alias

To run the environment commands from anywhere on your system, we highly recommend adding a bash alias. We have included an example `.bash_aliases` file in this project. 

You can copy its contents to your own `~/.bash_aliases` (or `~/.bashrc` / `~/.zshrc`) file:

1. Open your local aliases file:
   ```bash
   nano ~/.bash_aliases

```

2. Add the alias, making sure to replace `~/tools/web-docker` with the actual path to where you placed this environment:
```bash
alias web-docker='sh ~/tools/web-docker/web-docker.sh'

```

3. Apply the changes to your current terminal session:
```bash
source ~/.bash_aliases

```

### 🛠️ Available Commands

Once your alias is set up, you can manage your server from anywhere using:

```bash
web-docker up     # Start the environment
web-docker down   # Stop the environment
web-docker build  # Rebuild the PHP/Apache container
web-docker bash   # Enter the web container shell
web-docker logs   # View server logs
web-docker stats  # Check server performance stats
web-docker edit   # Open the server directory in VS Code

```

*(If you prefer not to use the alias, simply run `./web-docker.sh <command>` from inside the project folder).*


## 📁 Managing Projects

### 1. Linking your projects directory

The best way to use this environment with external projects is to create a symlink from your host machine's project folder into the environment.

**Step 1: Create the symlink**
Run this command, replacing `/home/user/projects` with the actual path to your projects:
```bash
ln -s /home/user/projects ./www/projects

```

**Step 2: Update `docker-compose.yml`**
Next, you need to tell Docker to mount this new symlink instead of the default static directory. Open your `docker-compose.yml` and modify the `volumes` section under the `web` service.

Comment out the default `./www/html` line and uncomment the `./www/projects` line:

```yaml
    volumes:
      # Choose a projects location local or symlink
      # - ./www/html:/var/www/html # ./www/html is a static folder inside
      - ./www/projects:/var/www/html # ./www/projects is a symlink from another location

```

*(After making this change, you will need to run `web-docker down` and `web-docker up` to apply the new volume mapping).*


### 2. Adding a Project Virtual Host

1. Copy `example.test.conf` to `./apache/vhosts/project-name.test.conf`.
2. Update the configuration to point to your project's directory:

A standard clean configuration looks like this:

```apache
<VirtualHost *:80>
    ServerName project-name.test
    DocumentRoot /var/www/html/project-name

    <Directory /var/www/html/project-name>
        AllowOverride All
        Require all granted
        Options -Indexes +FollowSymLinks
        php_admin_value open_basedir "/var/www/html/project-name:/tmp:/var/lib/php/sessions"
        php_admin_value disable_functions "exec,passthru,shell_exec,system,proc_open,popen"
    </Directory>
</VirtualHost>
```

For reference, here is the same configuration fully commented to explain what each directive does:

```apache
# Define a VirtualHost that listens for standard HTTP traffic on port 80
<VirtualHost *:80>
    # The local domain name used to access this specific project in your browser
    ServerName project-name.test
    
    # The path inside the container pointing to the project's folder
    DocumentRoot /var/www/html/project-name

    # Apply specific access controls and permissions rules to this directory
    <Directory /var/www/html/project-name>
        # Allow .htaccess files to override global settings (crucial for URL rewriting like in WordPress/Laravel)
        AllowOverride All
        
        # Permit web server access to this directory
        Require all granted
        
        # Disable file tree browsing (-Indexes) and allow symbolic links (+FollowSymLinks)
        Options -Indexes +FollowSymLinks
        
        # Restrict PHP file access strictly to this project, temp storage, and sessions
        php_admin_value open_basedir "/var/www/html/project-name:/tmp:/var/lib/php/sessions"
        
        # Disable dangerous system command execution functions for security
        php_admin_value disable_functions "exec,passthru,shell_exec,system,proc_open,popen"
    </Directory>
</VirtualHost>

```

*Note: Ensure you map `project-name.test` to `127.0.0.1` in your host machine's `/etc/hosts` file.*


### 3. Container Network Aliases (Override File)

To ensure your local virtual hosts are resolvable by containers from other compose stacks on the `global-devnet` network, you need to list them in the Docker Compose override file.

Docker Compose picks this file up automatically, and keeping it as an untracked override ensures your local domains don't conflict with other developers.

**Step 1: Create the override file**
Copy the included example file to create your local, git-ignored override file:

```bash
cp docker-compose.override.example.yml docker-compose.override.yml

```

**Step 2: Add your local vhosts**
Open `docker-compose.override.yml` and list your project domains under the `web` service's network aliases:

```yaml
services:
  web:
    networks:
      devnet:
        aliases:
          - example.test
          - project-name.test # Add your new local vhosts here

```

**Step 3: Apply the changes**
Whenever you modify the override file, you must restart the environment:

```bash
web-docker down && web-docker up

```


## 🗄️ Database Management

You can manage your databases visually via phpMyAdmin at `http://localhost:8080`, or via the CLI:

### MariaDB (Default)

**Import a database:**
```bash
docker exec -i mariadb-container mariadb -u root -proot db_name < ./example_path/db_name.sql

```

**Export a database:**

```bash
docker exec -i mariadb-container mariadb-dump -u root -proot db_name > ./example_path/db_name.sql

```


### MySQL (Alternative / Not configured by default)

*If you decide to swap MariaDB for MySQL in your `docker-compose.yml`, the container name and CLI tools change slightly:*

**Import a database:**

```bash
docker exec -i mysql-container mysql -u root -proot db_name < ./example_path/db_name.sql

```

**Export a database:**

```bash
docker exec -i mysql-container mysqldump -u root -proot db_name > ./example_path/db_name.sql

```


## 🌐 Connecting External Docker Containers

This environment creates a global network named `global-devnet`. If you have a separate Docker compose project that needs to talk to this server's database or web container, add the following to the external project's `docker-compose.yml`:

```yaml
networks:
  default:
    name: global-devnet
    external: true

```
