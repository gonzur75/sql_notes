from sqlalchemy import create_engine, MetaData, URL, Table, Column, Integer, String, ForeignKey, CheckConstraint, \
    UniqueConstraint
from sqlalchemy.dialects.mysql import INTEGER

import os, urllib
from dotenv import load_dotenv
from sqlalchemy.schema import CreateTable

UnsignedInt = Integer().with_variant(INTEGER(unsigned=True), 'mysql')

load_dotenv()  # = os.path.join(os.path.dirname(__file__), '.env')

url_object = URL.create(drivername='mysql+pymysql',
                        username=os.getenv('DB_USER'),
                        password=os.getenv('DB_PASSWORD'),
                        host=os.getenv('DB_HOST'),
                        port=os.getenv('DB_PORT'),
                        database=os.getenv('DB_NAME')
                        )

engine = create_engine(url_object)

metadata = MetaData()
metadata.reflect(bind=engine, schema='sakila')

if 'sakila.feedback' in metadata.tables:
    print("Table sakila.actor already exists")
else:
    feedback_table = Table(
        'feedback',
        metadata,
        Column('feedback_id', Integer, primary_key=True),
        Column('film_id', UnsignedInt, ForeignKey('sakila.film.film_id'), nullable=False),
        Column('contact_id', UnsignedInt, ForeignKey('sakila.customer.customer_id'), nullable=False),
        Column('rating', Integer, CheckConstraint('rating >= 1 AND rating <= 5'), nullable=False),
        Column('comment', String(255), nullable=True),
        UniqueConstraint('film_id', 'contact_id', name='unique_film_id_contact_id'),
        schema='sakila'
    )

    for table_name in metadata.sorted_tables:
        print(f"- {table_name}")

    print(str(CreateTable(feedback_table).compile(engine)))
    engine.echo = True
    metadata.create_all(engine)
    engine.echo = False
