import os
import decimal

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, select, update
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.automap import automap_base
import sqlalchemy as sa


load_dotenv(dotenv_path='.env')

url_object = sa.URL.create(
    drivername="mysql+pymysql",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    database=os.getenv("DB_NAME")
)

engine = sa.create_engine(url_object)
Session = sessionmaker(bind=engine)


Base = automap_base()
Base.prepare(autoload_with=engine, classname_for_table=lambda cls, table_name, table_obj: table_name.title())


Payment = Base.classes.Payment


df_excel = pd.read_excel('./report.xlsx')

with Session() as session:
    query = select(
        Payment.payment_id,
        Payment.payment_date,
        Payment.amount.label("amount")
    ).limit(100)

    db_results = session.execute(query).mappings()
    df_sql = pd.DataFrame(db_results)

    df_sql["amount"] = df_sql["amount"].astype(float)
    df_excel["amount"] = df_excel["amount"].astype(float)

    diff = df_excel.loc[~df_excel.eq(df_sql).all(axis=1)]

    if not diff.empty:
        payment_id = int(diff["payment_id"].iloc[0])
        new_amount = decimal.Decimal(diff["amount"].iloc[0])

        upd_query = (
            update(Payment)
            .where(Payment.payment_id == payment_id)
            .values(amount=new_amount)
        )
        session.execute(upd_query)
        session.commit()


    updated_results = session.execute(query).mappings()
    print(list(updated_results))