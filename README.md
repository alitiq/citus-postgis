# citus-postgis
Citus-postgis is a PostgreSQL-based distributed RDBMS based on this [repository](https://github.com/citusdata/docker). For more information, see the [Citus data](https://www.citusdata.com/) and the [PostGIS](https://postgis.net/) webites. 
.

## Load pre-built Docker image
We provide a pre built docker image in this repository.

1. Login to github's docker.pkg:

```bash
docker login docker.pkg.github.com -u  "username" -p  "token"
```
Note: You need a github developer token.
2. Pull image:
```bash 
docker pull docker.pkg.github.com/meteointelligence/citus-postgis/citus-postgis
```
3. [Optional] Tag image:
```bash 
docker tag docker.pkg.github.com/meteointelligence/citus-postgis/citus-postgis citus-postgis 
```

## Build
If you do not want to use github pre-built docker image you can build image from this project:
Go into the project directory and run: 
```bash
docker build -t "citus-postgis" .
````

## Usage
We recommend the following usage: 

#### Default settings:
```bash
docker run --name citus_standalone -p 5432:5432 citusdata/citus
```
#### Specified User:
```bash
docker run --rm --name pg-docker -e PGUSER=<user> -e POSTGRES_PASSWORD=<pwd> -d -p 5432:5432 citusdata/citus:pg12 
```

You should now be able to connect to `127.0.0.1` on port `5432` using e.g. `psql` to run a few commands (see the Citus documentation for more information).
As with the PostgreSQL image, the default `PGDATA` directory will be mounted as a volume, so it will persist between restarts of the container.


## Enable postgis
PostGIS is an extension you have to enable to each database you want to use it in.
1. Create your database
2. Log in to your database and activate PostGIS:
```psql
CREATE EXTENSION postgis; 
```
For more details, check out the PostGIS documentation.
### Docker Compose

The included `docker-compose.yml` file provides an easy way to get started with a Citus cluster, complete with multiple workers. Just copy it to your current directory and run:

```bash
docker-compose -p citus up

# Creating network "citus_default" with the default driver
# Creating citus_worker_1
# Creating citus_master
# Creating citus_config
# Attaching to citus_worker_1, citus_master, citus_config
# worker_1    | The files belonging to this database system will be owned by user "postgres".
# worker_1    | This user must also own the server process.
# ...
```

That’s it! As with the standalone mode, you’ll want to find your `docker-machine ip` if you’re using that technology, otherwise, just connect locally to `5432`. By default, you’ll only have one worker:

```sql
SELECT master_get_active_worker_nodes();

--  master_get_active_worker_nodes
-- --------------------------------
--  (citus_worker_1,5432)
-- (1 row)
```

But you can add more workers at will using `docker-compose scale` in another tab. For instance, to bring your worker count to five…

```bash
docker-compose -p citus scale worker=5

# Creating and starting 2 ... done
# Creating and starting 3 ... done
# Creating and starting 4 ... done
# Creating and starting 5 ... done
```

```sql
SELECT master_get_active_worker_nodes();

--  master_get_active_worker_nodes
-- --------------------------------
--  (citus_worker_5,5432)
--  (citus_worker_1,5432)
--  (citus_worker_3,5432)
--  (citus_worker_2,5432)
--  (citus_worker_4,5432)
-- (5 rows)
```

If you inspect the configuration file, you’ll find that there is a container that is neither a master nor worker node: `citus_config`. It simply listens for new containers tagged with the worker role, then adds them to the config file in a volume shared with the master node. If new nodes have appeared, it calls `master_initialize_node_metadata` against the master to repopulate the node table. See Citus’ [`workerlist-gen`][workerlist-gen] repo for more details.

You can stop your cluster with `docker-compose -p citus down`.