from flask import Flask, render_template, redirect, url_for, request
from pymongo import MongoClient


app = Flask(__name__)

## database manager
def connect_database(url="mongodb://10.0.0.123:27017/" ):
    try:
        connection = MongoClient(url)
        connection.admin.command('ping')
        print(f"Connected to : '{url}' ")
    except Exception as e:
        print(e)
    return connection

def query_all_collection(connection, database_name="poman", collection_name="requisitos"):
    if connection:
        collection = connection[database_name][collection_name]
        
        return collection.find()


def get_collection(connection, database_name="poman", collection_name="requisitos"):
    if connection:
        collection = connection[database_name][collection_name]
        
        return collection

## routes 

@app.route("/", methods=['POST'])
def insert_item():
    
    print(f">> ROTA POST {request.form["descricao"]} ")

    new_doc = {
        "descricao": request.form["descricao"],
        "prioridade": request.form["prioridade"]
    }
    
    get_collection(connect_database()).insert_one(new_doc)

    return redirect(url_for("index"))


@app.route("/", methods=['GET'])
def index():
    result = query_all_collection(connect_database())
    return render_template("index.html.jinja", result=result)
         

if __name__ == "__main__":

    app.run(debug=True)