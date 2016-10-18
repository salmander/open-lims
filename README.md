1. Do `docker-compose up -d` to start the containers.
2. SSH into the DB container and create a new DB user `dbadmin` and grant all permissions to db `web` by:
    ```
    docker exec -it openlims_db_1 bash
    
    pgsql -U web
    
    CREATE USER dbadmin;
    
    GRANT ALL PRIVILEGES ON DATABASE web TO dbadmin;
    ```
3. Then restore the db backup by doing the following:
    ```
    // SSH to DB container first by `docker exec -it openlims_db_1 bash`
    
    cd `/open-lims-src/db-backup/`
    
    pg_restore -d web -U web open-lims.backup
    
    ```
4. Open `http://localhost:8080/index.php` to browse your `Open-Lims` application.
5. Once you are done. Do `docker-compose down` to shutdown all containers.

P.S. The `postgres` DB maintains its persistence even if the containers have been destroyed. This is because the DB data directory is locally mounted.