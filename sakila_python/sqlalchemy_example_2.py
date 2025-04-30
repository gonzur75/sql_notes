

from sqlalchemy import create_engine, text, MetaData, Table, Column, Integer, String

engine = create_engine('sqlite:///yolo3.db', echo=True)
metadata = MetaData()

# SQLAlchemy Core
user_table = Table(
    'user',
    metadata,
    Column('id', Integer, primary_key=True ),
    Column('name', String, nullable=False),
    Column('age', Integer, nullable=False)
)

metadata.create_all(engine)

with engine.connect() as connection:
    connection.execute(user_table.insert().values(name="Janusz", age=40))
    results = connection.execute(user_table.select())
    for row in results:
        print(row)
