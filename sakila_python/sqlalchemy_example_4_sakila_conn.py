from sqlalchemy import create_engine, MetaData, select, URL
import os, urllib
from dotenv import load_dotenv

load_dotenv() # = os.path.join(os.path.dirname(__file__), '.env')

url_object = URL.create(drivername='mysql+pymysql',
                        username=os.getenv('DB_USER'),
                        password=os.getenv('DB_PASSWORD'),
                        host=os.getenv('DB_HOST') ,
                        port=os.getenv('DB_PORT'),
                        database=os.getenv('DB_NAME')

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
