📘 SQL Notes – Sakila MySQL Examples
Docker MySQL

This project is a curated collection of SQL queries and scripts using the popular open-source Sakila database, powered by a local MySQL server running in Docker.

It is designed as a reference and learning resource for practicing:

SELECT, INSERT, UPDATE, and DELETE statements
Schema and data loading
SQL logic and syntax in a real-world dataset
🐬 Database Setup (Docker + Sakila)
This project uses Docker to spin up a MySQL instance with the Sakila sample database.

🔧 Start the MySQL container
Make sure you have Docker installed.
Run the following command in the project directory:
cd dbs_docker
docker-compose up -d
The container: • Exposes MySQL on localhost:3306 • Creates the database sakila • Uses user: user and password: password

🧩 Load Sakila schema and data

Once the container is running, load the schema and data:

docker exec -i <container_name_or_id> \
mysql -uuser -ppassword sakila < dbs_sources/mysql-sakila-schema.sql

docker exec -i <container_name_or_id> \
mysql -uuser -ppassword sakila < dbs_sources/mysql-sakila-insert-data.sql

🧪 SQL Examples

All example queries are stored in the examples/ directory:

File	Description
1.basic_select.sql	Basic SELECT queries
2.insert.sql	INSERT INTO statements
3.update.sql	UPDATE statements
4.delete.sql	Safe and unsafe DELETE use
📂 Project Structure


sql_notes/
├── dbs_docker/               ← Docker Compose setup
│   └── docker-compose.yaml
├── dbs_sources/              ← Sakila schema and data
│   ├── mysql-sakila-schema.sql
│   └── mysql-sakila-insert-data.sql
├── examples/                 ← SQL query examples
│   ├── 1.basic_select.sql
│   ├── 2.insert.sql
│   ├── 3.update.sql
│   └── 4.delete.sql
└── README.md

💡 About Sakila

Sakila is a sample database designed by MySQL, representing a fictional DVD rental store. It is perfect for learning joins, filtering, grouping, and real-world entity relationships.