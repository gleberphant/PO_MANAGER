# database.py
import sqlite3

connection = None

def connect_sqlite(url="database.db"):
    """Conecta ao banco de dados SQLite."""
    try:
        connection = sqlite3.Connection(url)
        print(f"Connected to : '{url}' ")
        return connection
    except Exception as e:
        print(f"Erro ao conectar: {e}")
        return None # Retorna None em caso de erro


def query_products():
    """lista os produtos."""
    connection = connect_sqlite()

    if not connection:
        print(f"erro de conexão")
        return None
    try:
        cursor=  connection.cursor()
        result = cursor.execute("SELECT * from lista_produtos")
        result_list = [row for row in result]
    except Exception as e:
        print(f"Erro ao consultar : {e}")
    finally:
        return result_list

def query_all_table():
    """Busca todos os registros da tabela requisitos."""
    result_list = []
    connection = connect_sqlite()
    
    if not connection:
        print(f"Erro ao conectar:")
        return None # Inicializa connection
    
    try:
        cursor = connection.cursor()
        result = cursor.execute("SELECT descricao, prioridade FROM requisitos").fetchall()
        result_list = [{"descricao": row[0], "prioridade": row[1]} for row in result]

    except Exception as e:
        print(f"Erro ao consultar: {e}")

    finally:
        connection.close() # Garante que a conexão seja fechada

    return result_list

def insert_data_sqlite(dados):
    """Insere dados na tabela requisitos."""
    connection = None # Inicializa connection
    try:
        connection = connect_sqlite()
        if connection: # Verifica se a conexão foi bem sucedida
            cursor = connection.cursor()
            cursor.execute("INSERT INTO requisitos (descricao, prioridade) VALUES(?, ?)", (dados['descricao'], dados['prioridade']))
            connection.commit()
    except Exception as e:
        print(f"Erro ao inserir: {e}")
    finally:
        if connection:
            connection.close() # Garante que a conexão seja fechada