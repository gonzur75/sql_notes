from sqlalchemy import create_engine, MetaData, select, URL
import os, urllib

url_object = URL.create(drivername='mysql+pymysql',
                        username="user",
                        password="password",
                        host="localhost",
                        port=3306,
                        database="sakila"

                        )
# connection_string = f'mysql+pymysql://user:password@localhost:3306/sakila?charset=utf8'

engine = create_engine(url_object)

metadata = MetaData()
metadata.reflect(bind=engine, schema='sakila')

actor = metadata.tables['sakila.actor']

query = select(actor.c.first_name, actor.c.last_name).limit(10)

with engine.connect() as conn:
    results = conn.execute(query)
    for row in results:
        print(row)
