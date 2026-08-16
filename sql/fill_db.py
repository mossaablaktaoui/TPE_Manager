from tools import db_connection

@db_connection


def remplir_db(cursor):
    with open("sql/remplir_query.sql", "r") as file:
        sql_script = file.read()

    cursor.executescript(sql_script)
if __name__ == "__main__" :
    remplir_db()