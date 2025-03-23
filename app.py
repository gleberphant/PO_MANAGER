from flask import Flask, render_template, redirect, url_for, request

import sqlite3

app = Flask(__name__)

## database manager SQLITE
def connect_sqlite(url="database.db"):
    try:
        connection = sqlite3.Connection(url)
        print(f"Connected to : '{url}' ")
        return connection
    except Exception as e:
        print(e) 

def query_all_table(connection):
    result_list = []

    try:
        connection = connect_sqlite()
        cursor = connection.cursor()
        result = cursor.execute("SELECT descricao, prioridade FROM requisitos").fetchall()
        result_list = [{"descricao": row[0], "prioridade": row[1]} for row in result]
        connection.close()

    except Exception as e:
        print(e)

    return result_list

def insert_data_sqlite(dados):
    try:
        connection = connect_sqlite()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO requisitos (descricao, prioridade) VALUES(? , ?)", (dados['descricao'], dados['prioridade']))
        connection.commit()
        connection.close()
    except Exception as e:
        print(e)


## FLASK routes 

@app.route("/", methods=['POST'])
def insert_item():
    
    print(f">> ROTA POST {request.form["descricao"]} ")

    new_row = {
        "descricao": request.form["descricao"],
        "prioridade": request.form["prioridade"]
    }
    
    insert_data_sqlite(new_row)
    # get_collection(connect_database()).insert_one(new_doc)

    return redirect(url_for("index"))


@app.route("/", methods=['GET'])
def index():
    # result = query_all_collection(connect_database())
    result = query_all_table(connect_sqlite())
    return render_template("index.html.jinja", result=result)
         

if __name__ == "__main__":

    app.run(debug=True)