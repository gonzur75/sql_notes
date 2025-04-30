from sqlalchemy import create_engine, text

engine = create_engine('sqlite:///yolo2.db', echo=True)

query_create_table_user = """
                          CREATE TABLE user
                          (
                              id   INTEGER PRIMARY KEY AUTOINCREMENT,
                              name TEXT    NOT NULL,
                              age  INTEGER Not NULL
                          )
                          """

with engine.connect() as connection:
    connection.execute(text(query_create_table_user))

    connection.execute(text("INSERT INTO user (name, age) VALUES ('John', 30)"))
    results = connection.execute(text("SELECT * FROM user"))
    for row in results:
        print(row)
