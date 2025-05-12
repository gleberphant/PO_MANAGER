from pymongo import MongoClient

## database manager MONGDB
def connect_database(url="mongodb://10.0.0.123:27017/"):
    try:
        connection = MongoClient(url)
        connection.admin.command('ping')
        print(f"Connected to : '{url}' ")
        return connection
    except Exception as e:
        print(e)
    

def query_all_requirements(connection, database_name="poman", collection_name="requisitos"):
    try: 
        collection = connection[database_name][collection_name]
        return collection.find()
    except Exception as e:
        print(e)


def query_requirement(connection, database_name="poman", collection_name="requisitos"):
    if connection:
        collection = connection[database_name][collection_name]
        
        return collection
