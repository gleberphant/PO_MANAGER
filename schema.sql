/* BASE DE DADOS DO POMAN */

-- -------------------------------------------------------------------
-- TABELAS DE ENTIDADES
-- -------------------------------------------------------------------

/*  PESSOAS : todas as pessoas cadastradas */
DROP TABLE IF EXISTS "pessoas"
CREATE TABLE IF NOT EXISTS "pessoas" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
);

/*  MEMBROS : membros trabalham em um produto. é um especialização de pessoas */
DROP TABLE IF EXISTS "membros"
CREATE TABLE IF NOT EXISTS "membros"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "pessoa_id" INTEGER NOT NULL, -- tabela de especialização
    "funcao_id" INTEGER NOT NULL, -- tabela de referencia
    "produto_id" INTEGER NOT NULL, -- produto a qual pertence esse membro
    FOREIGN KEY ("pessoa_id") REFERENCES "pessoas"("id"),
    FOREIGN KEY ("funcao_id") REFERENCES "funcoes"("id"),
    FOREIGN KEY ("produto_id") REFERENCES "produtos"("id")
);

/*  PRODUTOS : entidade principal */
DROP TABLE IF EXISTS "produtos";
CREATE TABLE IF NOT EXISTS "produtos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
    "descricao" TEXT,
    "data_inicio" VARCHAR(30)
);

/* ESCOPOS : os escopos  correspondem a grupos de funcionalidades  do produto. */
DROP TABLE IF EXISTS "escopos";
CREATE TABLE IF NOT EXISTS "escopos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
    "produto_id" INTEGER, -- GRUPO PERTENCE A UM PRODUTO
    FOREIGN KEY ("produto_id") REFERENCES "produtos"("id")
);

/* REQUISITOS : requisitos de um produto*/
DROP TABLE IF EXISTS "requisitos";
CREATE TABLE IF NOT EXISTS "requisitos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "descricao" TEXT,
    "prioridade" VARCHAR(200) CHECK(prioridade IN ('alta', 'normal', 'baixa', 'urgente')),
    "data_status" INTEGER,
    "tipo_id" INTEGER, -- requisito se classifica em um tipo
    "status_id" INTEGER, -- status do pedido
    "produto_id" INTEGER, -- requisito pertence a um produto
    "grupo_id" INTEGER, -- requisito pertence a um grupo
       
    FOREIGN KEY ("produto_id")  REFERENCES "produtos"("id"),
    FOREIGN KEY ("grupo_id") REFERENCES "grupos"("id"),
    FOREIGN KEY ("tipo_id") REFERENCES "tipos"("id"),
    FOREIGN KEY ("status_id") REFERENCES "status"("id")
);

-- -------------------------------------------------------------------
-- TABELAS DE REFERENCIA - 
-- -------------------------------------------------------------------

/* FUNCOES: com os tipos de funcções dos membros  */
DROP TABLE IF EXISTS "funcoes"
CREATE TABLE IF NOT EXISTS "funcoes"(
    "id"
    "nome"
    "descricao"
);

/* TIPOS : Tabela de referencias para os tipos de requisito : funcionais, não funcionais ...*/
DROP TABLE IF EXISTS "tipos";
CREATE TABLE IF NOT EXISTS "tipos"
(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200)
);


/*  STATUS : Tabela de referencias para os status: pendente, desenvolvimento, concluido ...*/
DROP TABLE IF EXISTS "status";
CREATE TABLE IF NOT EXISTS "status"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(50)
);


-- -------------------------------------------------------------------
-- INSERINDO DADOS DE CONFIGURAÇAO 
-- -------------------------------------------------------------------
INSERT INTO "funcoes"("nome")
VALUES
('Gerente de Produto (PO)'),
('Gerente de Qualidade (QA)'),
('Chefe Desenvolvimento'),
('Desenvolvimento');

INSERT INTO "tipos"("nome")
VALUES
('funcionais'),
('não funcionais'),
('interface'),
('hardware');


INSERT INTO "status"("nome")
VALUES
('pendente'),
('desenvolvimento'),
('revisao'),
('concluido');