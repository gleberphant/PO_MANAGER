# database.py
import duckdb

def connect_database(url="database.duckdb"):
    """Conecta ao banco de dados DuckDatabase."""
    print(f"==== CONECTANDO AO DUCK DB ==== ")
    try:
        connection = duckdb.connect(url)
        print(f"::: Connectado a : '{url}' ")
        return connection
    except Exception as e:
        print(f"Erro ao conectar: {e}")
        return None # Retorna None em caso de erro


def query_products():
    """lista os produtos."""
    connection = connect_database()


    if not connection:
        print(f"erro de conexão")
        return None
    print(f"==== LISTANDO PRODUTOS ==== ")    
    try:
        result_list = connection.sql("SELECT * from lista_produtos").fetchall()
        #result_list = [row for row in result]
    except Exception as e:
        print(f"::::Erro ao consultar : {e}")
    finally:
        connection.close() # Garante que a conexão seja fechada

        return result_list
    return result_list

