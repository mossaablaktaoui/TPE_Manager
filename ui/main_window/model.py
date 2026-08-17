from sql.tools import db_connection
from PySide6.QtCore import QObject, Slot
import datetime


class MainWindowModel(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

    @Slot(str, str, str, str, result="QVariantList")
    @db_connection
    def obtenir_operations(self, cursor, date_debut, date_fin, operation_type="ALL", transaction_type="ALL"):
        query = """
            SELECT *
            FROM operations
            WHERE date BETWEEN ? AND ?
              AND supprime = 0
        """
        parameters = [date_debut, date_fin]

        if operation_type != "ALL":
            query += "\n  AND operation_type = ?"
            parameters.append(operation_type)

        if transaction_type != "ALL":
            query += "\n  AND transaction_type = ?"
            parameters.append(transaction_type)

        query += "\nORDER BY date ASC, time ASC, id ASC"
        cursor.execute(query, parameters)

        result = cursor.fetchall()
        return [list(row) for row in result]



    @Slot(str, str, str, int, float, float, float, float, float, float, float, float, str, result=int)
    @db_connection
    def ajouter_operation(self, cursor,
                          date,
                          operation_type,
                          transaction_type=None,
                          numero_facture=None,
                          montant=0,
                          montant_verse=0,
                          montant_deductible=0,
                          commission_CMI=0,
                          benefice=0,
                          benefice_supplementaire=0,
                          solde_avant=0,
                          solde_apres=0,
                          remarque=None):
        date, time = self._normaliser_date_heure(date)
        if operation_type == "FOURNITURE":
            transaction_type = None
            numero_facture = None
        cursor.execute("""
            INSERT INTO operations (
                date,
                time,
                operation_type,
                transaction_type,
                numero_facture,
                montant,
                montant_verse,
                montant_deductible,
                commission_CMI,
                benefice,
                benefice_supplementaire,
                solde_avant,
                solde_apres,
                remarque
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (date,
                  time,
                  operation_type,
                  transaction_type,
                  numero_facture,
                  montant,
                  montant_verse,
                  montant_deductible,
                  commission_CMI,
                  benefice,
                  benefice_supplementaire,
                  solde_avant,
                  solde_apres,
                  remarque))
        return cursor.lastrowid

    @Slot(int, str, str, str, int, float, float, float, float, float, float, float, float, str, result=int)
    @db_connection
    def modifier_operation(self, cursor,
                           operation_id,
                           date,
                           operation_type,
                           transaction_type=None,
                           numero_facture=None,
                           montant=0,
                           montant_verse=0,
                           montant_deductible=0,
                           commission_CMI=0,
                           benefice=0,
                           benefice_supplementaire=0,
                           solde_avant=0,
                           solde_apres=0,
                           remarque=None):
        date, time = self._normaliser_date_heure(date)
        if operation_type == "FOURNITURE":
            transaction_type = None
            numero_facture = None
        cursor.execute("""
            UPDATE operations
            SET
                date = ?,
                time = ?,
                operation_type = ?,
                transaction_type = ?,
                numero_facture = ?,
                montant = ?,
                montant_verse = ?,
                montant_deductible = ?,
                commission_CMI = ?,
                benefice = ?,
                benefice_supplementaire = ?,
                solde_avant = ?,
                solde_apres = ?,
                remarque = ?
            WHERE id = ?
                AND supprime = 0
            """, (date,
                  time,
                  operation_type,
                  transaction_type,
                  numero_facture,
                  montant,
                  montant_verse,
                  montant_deductible,
                  commission_CMI,
                  benefice,
                  benefice_supplementaire,
                  solde_avant,
                  solde_apres,
                  remarque,
                  operation_id))
        return cursor.rowcount

    @staticmethod
    def _normaliser_date_heure(value):
        parts = str(value).strip().split(maxsplit=1)
        date = parts[0]
        if len(parts) == 2:
            time = parts[1]
            if len(time) == 5:
                time += ":00"
        else:
            time = datetime.datetime.now().strftime("%H:%M:%S")
        return date, time

    @Slot(str, int)
    @staticmethod
    @db_connection
    def remplir_bilan_quotidienne(cursor, date, numero_facture):
        cursor.execute("""
            SELECT
                COALESCE(SUM(montant), 0),
                COALESCE(SUM(montant_verse), 0),
                COALESCE(SUM(montant_deductible), 0),
                COALESCE(SUM(commission_CMI), 0),
                COALESCE(SUM(benefice), 0),
                COALESCE(SUM(benefice_supplementaire), 0)
            FROM operations
            WHERE date = ?
            AND numero_facture = ?
            AND supprime = 0
        """, (date, numero_facture))

        totals = cursor.fetchone()

        cursor.execute('''SELECT COUNT(*) FROM bilan_quotidien
                   WHERE date = ?
                   AND numero_facture = ?''', (date, numero_facture))
        exist = cursor.fetchone() != 0

        if exist:
            cursor.execute("""
                            UPDATE bilan_quotidien SET
                                total_montant_verse = ?,
                                total_benefice = ?,
                                total_benefice_supplementaire = ?,
                                total_commission_CMI = ?,
                                total_montant_deductible = ?,
                                total_montant = ?
                        """, totals)
        else:
            cursor.execute("""
                INSERT INTO bilan_quotidien (
                    date,
                    numero_facture,
                    total_montant_verse,
                    total_benefice,
                    total_benefice_supplementaire,
                    total_commission_CMI,
                    total_montant_deductible,
                    total_montant
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                date,
                numero_facture,
                totals[1],  # montant_verse
                totals[4],  # benefice
                totals[5],  # benefice_supplementaire
                totals[3],  # commission_CMI
                totals[2],  # montant_deductible
                totals[0]   # montant
            ))

    @Slot(str, str)
    @staticmethod
    @db_connection
    def obtenir_bilan_quotidien(cursor, date_debut, date_fin):
        cursor.execute(""" SELECT * FROM bilan_quotidien 
                           WHERE date BETWEEN ? AND ?
                           """,(date_debut, date_fin))
        result = cursor.fetchall()
        return [list(row) for row in result]

    @Slot(int, result=int)
    @db_connection
    def supprimer_operation(self, cursor, operation_id):
        cursor.execute("""
            UPDATE operations
            SET supprime = 1
            WHERE id = ?
              AND supprime = 0
            """, (operation_id,))
        return cursor.rowcount

    @Slot(int, result=int)
    @db_connection
    def dupliquer_operation(self, cursor, operation_id):
        now = datetime.datetime.now()
        cursor.execute("""
            INSERT INTO operations (
                date,
                time,
                operation_type,
                transaction_type,
                numero_facture,
                montant,
                montant_verse,
                montant_deductible,
                commission_CMI,
                benefice,
                benefice_supplementaire,
                solde_avant,
                solde_apres,
                remarque
            )
            SELECT
                ?,
                ?,
                operation_type,
                transaction_type,
                numero_facture,
                montant,
                montant_verse,
                montant_deductible,
                commission_CMI,
                benefice,
                benefice_supplementaire,
                solde_avant,
                solde_apres,
                remarque
            FROM operations
            WHERE id = ?
              AND supprime = 0
            """, (
                now.strftime("%Y-%m-%d"),
                now.strftime("%H:%M:%S"),
                operation_id,
            ))
        return cursor.lastrowid if cursor.rowcount == 1 else 0

    @Slot(float, list, int)
    @staticmethod
    def montant_deductible(montant, ranges, transaction_type):
        if transaction_type:
            for item in ranges:
                limites = item[0]
                valeur = item[1]

                minimum = limites[0]
                maximum = limites[1]
                if minimum <= montant <= maximum:
                    return valeur
            return montant * 0.02
        return montant * 0.04

    @Slot(float, float)
    @staticmethod
    def montant_verse(montant, montant_deductible):
        return montant - montant_deductible

    @Slot(float, int)
    @staticmethod
    def commission_CMI(montant, transaction_type):
        if transaction_type:
            return montant * 0.01
        return montant * 0.027

    @Slot(float, float)
    @staticmethod
    def benefice(commission_CMI, montant_deductible):
        return montant_deductible - commission_CMI

    @Slot(float, float)
    @staticmethod
    def solde_apres(solde_avant, montant_verse):
        return solde_avant - montant_verse

    @Slot(float, float, int)
    @staticmethod
    def benefice_supplementaire(benefice, commission_CMI, transaction_type):
        if transaction_type:
            return benefice - (commission_CMI * 2)
        return 0


    @Slot(str, result=float)
    @db_connection
    def solde_avant(self, cursor, date):
        cursor.execute("""
            SELECT solde_apres
            FROM operations
            WHERE supprime = 0
              AND date <= ?
            ORDER BY date DESC, time DESC, id DESC
            LIMIT 1
            """, (date,))
        row = cursor.fetchone()
        if row is None:
            return 0
        return row[0] if row[0] is not None else 0



    @Slot(str)
    @staticmethod
    @db_connection
    def solde_restant(cursor, date):
        cursor.execute("""
            SELECT solde_apres
            FROM operations
            WHERE supprime = 0
              AND date <= ?
            ORDER BY date DESC, time DESC, id DESC
            LIMIT 1
            """, (date,))
        row = cursor.fetchone()
        if row is None:
            return 0
        return row[0] if row[0] is not None else 0



    @Slot(str, str, str)
    @staticmethod
    @db_connection
    def total(cursor, date_debut, date_fin, variable):
        cursor.execute("""
            SELECT COALESCE(SUM(?), 0)
            FROM operations
            WHERE date BETWEEN ? AND ?
              AND operation_type = 'TRANSACTION'
              AND supprime = 0
            """, (variable, date_debut, date_fin,))
        return cursor.fetchone()[0]



    def export_operations_to_excel(self, operations, file_path):
        from openpyxl import Workbook

        workbook = Workbook()
        sheet = workbook.active
        sheet.title = "Operations"

        sheet.append([
            "ID", "Date", "Time", "Operation Type", "Transaction Type",
            "Invoice Number", "Amount", "Amount Paid", "Deductible Amount",
            "CMI Commission", "Profit", "Additional Profit",
            "Balance Before", "Balance After", "Remark"
        ])

        for operation in operations:
            sheet.append(list(operation))

        workbook.save(file_path)
