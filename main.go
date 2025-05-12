package main

import (
	"database/sql"

	_ "github.com/marcboeker/go-duckdb/v2"

	"fmt"
	"log"
)

type myDatabase struct {
	con *sql.DB
}

func (db *myDatabase) connectDatabase() error {
	// db, erro := sql.Open("sqlite3", "file:database.sqlite")
	var err error

	db.con, err = sql.Open("duckdb", "database.duckdb")

	if err != nil {
		fmt.Printf("Error ao abrir conexão %w", err)
		return err
	}

	fmt.Println("Conectado a base de dados")

	return nil
}

func (db *myDatabase) queryAllRequirements() (*sql.Rows, error) {
	var rows *sql.Rows
	var err error

	rows, err = db.con.Query(`SELECT "id", "descricao" FROM "requisitos" `)

	if err != nil {
		return nil, err
	}

	return rows, nil

}

func (db *myDatabase) closeDatabase() {
	db.con.Close()
}

func main() {

	fmt.Println("Bem Vindo ao POMAN-GO")
	var err error
	var connection myDatabase

	connection.connectDatabase()

	if err != nil {
		log.Fatal(err)
		return
	}

	defer connection.closeDatabase()

	fmt.Println("Consultando tabelas")

	var rows *sql.Rows

	rows, _ = connection.queryAllRequirements()

	defer rows.Close()

	fmt.Println("Resultados: ")
	for rows.Next() {

		var id, descricao string

		erro := rows.Scan(&id, &descricao)
		if erro != nil {
			fmt.Printf("erro leitura da linha : %s\n", erro)
		} else {
			fmt.Printf("| ID: %s | DESCRIÇÃO: %s |\n", id, descricao)
		}
	}

}
