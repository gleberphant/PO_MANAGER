from flask import Flask, render_template, redirect, url_for, request
import duckdb_manage as dbm


app = Flask(__name__)



## FLASK routes 
# main - metodo posto para inserir novo item
@app.route("/", methods=['POST'])
def insert_item():
    
    print(f">> ROTA POST {request.form["descricao"]} ")

    new_row = {
        "descricao": request.form["descricao"],
        "prioridade": request.form["prioridade"]
    }
    
    # dbm.insert_data_sqlite(new_row)
    # get_collection(connect_database()).insert_one(new_doc)

    return redirect(url_for("index"))


@app.route("/", methods=['GET'])
def index():
    
    result_list = dbm.query_all_products()
    return render_template("index.html.jinja", result=result_list)
         

if __name__ == "__main__":

    app.run(debug=True)