import os
import pandas as pd
from dotenv import load_dotenv
import sqlalchemy as sa

load_dotenv()

url_object = sa.URL.create(drivername='mysql+pymysql',
                           username=os.getenv('DB_USER'),
                           password=os.getenv('DB_PASSWORD'),
                           host=os.getenv('DB_HOST'),
                           port=os.getenv('DB_PORT'),
                           database=os.getenv('DB_NAME')

                           )

engine = sa.create_engine(url_object)
# pobranie danych z bazy bezposrednio z SQLZ
pd.read_sql("payment", con=engine).to_excel('report.xlsx', index=False)