-- BASE DE DADOS DO POMAN

-- CRIANDO AS TABELAS

/* tabela dos produtos */

DROP TABLE IF EXISTS "produtos";
CREATE TABLE IF NOT EXISTS "produtos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
    "data_inicio" VARCHAR(30)
);

/* TABELA GRUPOS : 
os grupos correspondem ao escopo do produto. as funcionalides gerais
*/
DROP TABLE IF EXISTS "grupos";
CREATE TABLE IF NOT EXISTS "grupos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
    "produto_id" INTEGER, -- GRUPO PERTENCE A UM PRODUTO
    FOREIGN KEY ("produto_id") REFERENCES "produtos"("id")
);

/* TABELAS TIPOS
os requisitos são classificados nestes tipos : funcionais, não funcionais
*/
DROP TABLE IF EXISTS "tipos";
CREATE TABLE IF NOT EXISTS "tipos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200)
);
/* TABELA STATUS 
    Tabela de referencias para os status (lookup table) 
*/

DROP TABLE IF EXISTS "status";
CREATE TABLE IF NOT EXISTS "status"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(50)
);


/* TABELA REQUISITOS 
*/
DROP TABLE IF EXISTS "requisitos";
CREATE TABLE IF NOT EXISTS "requisitos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "produto_id" INTEGER, -- requisito pertence a um produto
    "grupo_id" INTEGER, -- requisito pertence a um grupo
    "tipo_id" INTEGER, -- requisito se classifica em um tipo
    "status_id" INTEGER, -- status do pedido
    "descricao" TEXT,
    "prioridade" VARCHAR(200) CHECK(prioridade IN ('alta', 'normal', 'baixa', 'urgente')),
    FOREIGN KEY ("produto_id")  REFERENCES "produtos"("id"),
    FOREIGN KEY ("grupo_id") REFERENCES "grupos"("id"),
    FOREIGN KEY ("tipo_id") REFERENCES "tipos"("id"),
    FOREIGN KEY ("status_id") REFERENCES "status"("id")
);

-- INSERINDO DADOS DE TESTE
INSERT INTO "requisitos"("descricao","prioridade" )
VALUES
('teste descricao', 'alta' );