import sqlite3

connection = sqlite3.connect('./yolo.db')

cursor = connection.cursor()
query_create_table_user = """


                          CREATE TABLE user
                          (
                              id   INTEGER PRIMARY KEY AUTOINCREMENT,
                              name TEXT    NOT NULL,
                              age  INTEGER Not NULL
                          )
                          """

# cursor.execute(query_create_table_user)
# cursor.execute("INSERT INTO user (name, age) VALUES ('John', 30)")
# cursor.execute("INSERT INTO user (name, age) VALUES ('Karyna', 19)")
# connection.commit()

cursor.execute("SELECT * FROM user")
results = cursor.fetchall()
for row in results:
    print(row)


cursor.close()
connection.close()
