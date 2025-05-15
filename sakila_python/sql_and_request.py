import os
import pandas as pd
from dotenv import load_dotenv
import sqlalchemy as sa
from sqlalchemy.ext.automap import automap_base
import requests
load_dotenv()

url_object = sa.URL.create(drivername='mysql+pymysql',
                           username=os.getenv('DB_USER'),
                           password=os.getenv('DB_PASSWORD'),
                           host=os.getenv('DB_HOST'),
                           port=os.getenv('DB_PORT'),
                           database=os.getenv('DB_NAME')

                           )

engine = sa.create_engine(url_object)

Session = sa.orm.sessionmaker(engine)
Base = automap_base()
Base.prepare(engine)

Payment = Base.classes.payment

response = requests.get('https://api.nbp.pl/api/exchangerates/rates/a/usd/?format=json')
usd_rate = response.json()['rates'][0]['mid']
print(usd_rate)
with Session() as session:
    query = (
        sa.update(Payment).values(amount=sa.func.round(usd_rate * Payment.amount, 2))
    )
    session.execute(query)
    session.commit()
