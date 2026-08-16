import sqlite3
from functools import wraps
from pathlib import Path
from tkinter import Tk, filedialog
from tkinter import messagebox
import shutil
from pathlib import Path



def db_connection(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        connection = None

        try:
            connection = sqlite3.connect("sql/bdd.db")
            cursor = connection.cursor()

            result = func(cursor, *args, **kwargs)

            connection.commit()
            return result

        except sqlite3.Error as e:
            print(f"Database error: {e}")
            if connection:
                connection.rollback()

        finally:
            if connection:
                connection.close()

    return wrapper


@db_connection
def create_db(cursor):
    with open("sql/requetes.sql", "r") as file:
        sql_script = file.read()

    cursor.executescript(sql_script)


def export_db():
    root = Tk()
    root.withdraw()

    destination = filedialog.asksaveasfilename(
        title="Save file as",
        defaultextension=".db"
    )

    if destination:
        shutil.copy("sql/bdd.db", destination)

        print(f"Database saved to: {destination} successfully")
        return True
    else:
        print("Database export canceled.")
        return False

@db_connection
def importe_db(cursor):
    destination = Path("sql/bdd.db")
    root = Tk()
    root.withdraw()

    is_table_emty = cursor.execute("SELECT COUNT(*) FROM operations").fetchone()[0] == 0
    print(is_table_emty)
    if destination.exists():
        if not is_table_emty:
            choix = messagebox.askyesnocancel(
                "Données existantes",
                "L'ancienne base contient des données.\n\n"
                "Voulez-vous exporter/sauvegarder l'ancienne base "
                "avant d'importer la nouvelle ?"
            )

            # Annulation
            if choix is None:
                messagebox.showinfo(
                    "Annulé",
                    "l'importation a été annulées.")
                return

            # yes
            elif choix == True:
                backup = export_db()

                if not backup:
                    messagebox.showinfo(
                                "Annulé",
                                "L'exportation a été annulées.")
                    return  # Annulé

        source = filedialog.askopenfilename(
            title="Sélectionner le fichier de base de données à importer",
            filetypes=[("Database files", "*.db")]
        )
    
        if source:
            shutil.copy(source, "sql/bdd.db")
            print(f"Database imported from: {source} successfully")
            messagebox.showinfo(
                        "Succès",
                        "Le fichier a été importé avec succès."
                    )
            return True
        else:
            print("Database import canceled.")
            messagebox.showinfo(
                        "Annulé",
                        "L'importation est annulé"
                    )
            return False

        



if __name__ == "__main__":
    create_db()