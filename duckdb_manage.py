# database.py
import duckdb

def connect_database(url="database.duckdb"):
    """Conecta ao banco de dados DuckDatabase."""
    print(f"==== CONECTANDO AO DUCK DB ==== ")
    try:
        connection = duckdb.connect(url)
        print(f"::: Conectado a : '{url}' ")
        return connection
    except Exception as e:
        print(f"Erro ao conectar: {e}")
        return None # Retorna None em caso de erro


def query_all_products():
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


def query_all_requirements():
    """Busca todos os registros da tabela requisitos."""
    result_list = []
    connection = connect_database()
    
    if not connection:
        print(f"Erro ao conectar:")
        return None # Inicializa connection
    
    try:
        result_list = connection.sql("SELECT descricao, prioridade FROM requisitos").fetchall()
        #result_list = [{"descricao": row[0], "prioridade": row[1]} for row in result]

    except Exception as e:
        print(f"Erro ao consultar: {e}")

    finally:
        connection.close() # Garante que a conexão seja fechada

    return result_list


def insert_requirement(dados):
    """Insere dados na tabela requisitos."""
    connection = connect_database()

    if not connection:
        print(f"erro de conexão")
        return None

    connection.sql("INSERT INTO requisitos (descricao, prioridade) VALUES(?, ?)", (dados['descricao'], dados['prioridade'])).commit()

    connection.close() # Garante que a conexão seja fechada