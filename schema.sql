/* BASE DE DADOS DO POMAN */

-- -------------------------------------------------------------------
-- TABELAS DE ENTIDADES
-- -------------------------------------------------------------------

/*  PESSOAS : todas as pessoas cadastradas */
DROP TABLE IF EXISTS "pessoas";
CREATE TABLE IF NOT EXISTS "pessoas" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200) UNIQUE
);

-- Índices para colunas frequentemente consultadas
CREATE INDEX IF NOT EXISTS "idx_pessoas_nome" ON "pessoas" ("nome");


/*  PESSOAS : todas as pessoas cadastradas */
DROP TABLE IF EXISTS "proponentes";
CREATE TABLE IF NOT EXISTS "proponentes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200) UNIQUE,
    "representante_id" INTEGER,

    FOREIGN KEY("representante_id") REFERENCES "pessoas"("id")
);

-- Índices para chaves estrangeiras
CREATE INDEX IF NOT EXISTS "idx_proponentes_representante_id" ON "proponentes" ("representante_id");

-- Índices para colunas frequentemente consultadas
CREATE INDEX IF NOT EXISTS "idx_proponentes_nome" ON "proponentes" ("nome");


/*  MEMBROS : membros trabalham em um produto. é um especialização de pessoas */
DROP TABLE IF EXISTS "membros";
CREATE TABLE IF NOT EXISTS "membros"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "pessoa_id" INTEGER NOT NULL, -- tabela de especialização
    "funcao_id" INTEGER NOT NULL, -- tabela de referencia
    "produto_id" INTEGER NOT NULL, -- produto a qual pertence esse membro

    FOREIGN KEY ("pessoa_id") REFERENCES "pessoas"("id"),
    FOREIGN KEY ("funcao_id") REFERENCES "funcoes"("id"),
    FOREIGN KEY ("produto_id") REFERENCES "produtos"("id")
);

-- Índices para chaves estrangeiras
CREATE INDEX IF NOT EXISTS "idx_membros_pessoa_id" ON "membros" ("pessoa_id");
CREATE INDEX IF NOT EXISTS "idx_membros_funcao_id" ON "membros" ("funcao_id");
CREATE INDEX IF NOT EXISTS "idx_membros_produto_id" ON "membros" ("produto_id");

/*  PRODUTOS : entidade principal */
DROP TABLE IF EXISTS "produtos";
CREATE TABLE IF NOT EXISTS "produtos"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200) UNIQUE,
    "descricao" TEXT,
    "data_inicio" VARCHAR(30) DEFAULT '2025-01-01', --YYY-MM-DD
    "proponente_id" INTEGER NOT NULL,

    FOREIGN KEY ("proponente_id") REFERENCES "proponentes"("id")
);

-- Índices para chaves estrangeiras
CREATE INDEX IF NOT EXISTS "idx_produtos_proponente_id" ON "produtos" ("proponente_id");

-- Índices para colunas frequentemente consultadas
CREATE INDEX IF NOT EXISTS "idx_produtos_nome" ON "produtos" ("nome");


/* ESCOPOS : os escopos  correspondem a grupos de funcionalidades  do produto. */
DROP TABLE IF EXISTS "escopos";
CREATE TABLE IF NOT EXISTS "escopos"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200),
    "descricao" TEXT,
    "produto_id" INTEGER, -- GRUPO PERTENCE A UM PRODUTO

    FOREIGN KEY ("produto_id") REFERENCES "produtos"("id")
);

-- Índices para chaves estrangeiras
CREATE INDEX IF NOT EXISTS "idx_escopos_produto_id" ON "escopos" ("produto_id");


/* REQUISITOS : requisitos e estorias de um produto*/
DROP TABLE IF EXISTS "requisitos";
CREATE TABLE IF NOT EXISTS "requisitos"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "descricao" TEXT,
    "prioridade" VARCHAR(200) CHECK(prioridade IN ('alta', 'normal', 'baixa', 'urgente')),
    "data_status" INTEGER DEFAULT '2025-01-01', --YYY-MM-DD
    "tipo_id" INTEGER, -- requisito se classifica em um tipo
    "status_id" INTEGER, -- status do pedido
    "escopo_id" INTEGER, -- requisito deve pertencer ao escopo de um produto
    -- "produto_id" INTEGER, -- descomentar apenas se requisito puder existir sem escopo       
    -- FOREIGN KEY ("produto_id")  REFERENCES "produtos"("id"),
    FOREIGN KEY ("escopo_id") REFERENCES "escopos"("id"),
    FOREIGN KEY ("tipo_id") REFERENCES "tipos"("id"),
    FOREIGN KEY ("status_id") REFERENCES "status"("id")
);

-- Índices para chaves estrangeiras
CREATE INDEX IF NOT EXISTS "idx_requisitos_tipo_id" ON "requisitos" ("tipo_id");
CREATE INDEX IF NOT EXISTS "idx_requisitos_status_id" ON "requisitos" ("status_id");
CREATE INDEX IF NOT EXISTS "idx_requisitos_escopo_id" ON "requisitos" ("escopo_id");
-- CREATE INDEX IF NOT EXISTS "idx_requisitos_produto_id" ON "requisitos" ("produto_id"); 

-- Índices para colunas frequentemente consultadas
CREATE INDEX IF NOT EXISTS "idx_requisitos_prioridade" ON "requisitos" ("prioridade");
CREATE INDEX IF NOT EXISTS "idx_requisitos_data_status" ON "requisitos" ("data_status");


-- -------------------------------------------------------------------
-- TABELAS DE REFERENCIA - 
-- -------------------------------------------------------------------

/* FUNCOES: Tabela de referencias para os tipos de funções dos membros: PO, QA, DEV  */
DROP TABLE IF EXISTS "funcoes";
CREATE TABLE IF NOT EXISTS "funcoes"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(100) UNIQUE,
    "descricao" TEXT
);

/* TIPOS : Tabela de referencias para os tipos de requisito : funcionais, não funcionais ...*/
DROP TABLE IF EXISTS "tipos";
CREATE TABLE IF NOT EXISTS "tipos"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(200) UNIQUE
);


/* STATUS : Tabela de referencias para os status: pendente, desenvolvimento, concluido ...*/
DROP TABLE IF EXISTS "status";
CREATE TABLE IF NOT EXISTS "status"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" VARCHAR(50) UNIQUE
);


-- -------------------------------------------------------------------
-- INSERINDO DADOS DE CONFIGURAÇAO 
-- -------------------------------------------------------------------
INSERT INTO "funcoes"("id", "nome", "descricao")
VALUES
    (0, 'Gerente de Produto (PO)', ''),
    (1, 'Gerente de Qualidade (QA)', ''),
    (2, 'Chefe Desenvolvimento', ''),
    (3, 'Analista de Produto', ''),
    (4, 'Desenvolvimento', '');

INSERT INTO "tipos"("id", "nome")
VALUES
    (0, 'Estoria do usuário'),
    (1, 'Funcional'),
    (2, 'Não Funcional'),
    (3, 'Interface');


INSERT INTO "status"("id", "nome")
VALUES
    (0, 'Pendente'),
    (1, 'Desenvolvimento'),
    (2, 'Revisao'),
    (3, 'Concluido');


-- -------------------------------------------------------------------
-- CREATE VIEWS
-- -------------------------------------------------------------------

-- listar todos os produtos
DROP VIEW IF EXISTS "lista_produtos";
CREATE VIEW IF NOT EXISTS "lista_produtos" AS
    SELECT 
        "produtos"."nome" AS '"produto"',
        "produtos"."descricao" AS '"descrição"',
        "produtos"."data_inicio" AS 'inicio',
        "proponentes"."nome" AS 'proponente',
        "pessoas"."nome" AS 'representante'

    FROM "produtos"
        JOIN "proponentes" ON "proponentes"."id" = "produtos"."proponente_id"
        JOIN "pessoas" ON "pessoas"."id" = "proponentes"."representante_id";
    
-- listar requisitos por produto
DROP VIEW IF EXISTS "lista_requisitos";
CREATE VIEW IF NOT EXISTS "lista_requisitos" AS
    SELECT
        "produtos"."id" AS "id_produto",
        "requisitos"."id" AS "id_requisito",
        "produtos"."nome" AS "produto",
        "escopos"."nome" AS "escopo",
        "requisitos"."descricao" AS "requisito",
        "requisitos"."prioridade" AS "prioridade",
        "status"."nome" AS "status",
        "requisitos"."data_status" AS "data_status",
        "tipos"."nome" AS "tipo"
        
        
    FROM "requisitos"
        JOIN "status" ON "status"."id" = "requisitos"."status_id"
        JOIN "tipos" ON "tipos"."id" = "requisitos"."tipo_id"
        JOIN "escopos" ON "escopos"."id" =  "requisitos"."escopo_id"
        JOIN "produtos" ON "produtos"."id" = "escopos"."produto_id";

-- listar membros

DROP VIEW IF EXISTS "lista_membros";
CREATE VIEW IF NOT EXISTS "lista_membros" AS
    SELECT 
        "membros"."id" AS "id_membro",
        "pessoas"."nome" AS "membro",
        "funcoes"."nome" AS "funcao",
        "produtos"."nome" AS "produto"
    FROM "membros"
        JOIN "pessoas" ON "pessoas"."id" = "membros"."pessoa_id" 
        JOIN "funcoes" ON "funcoes"."id" = "membros"."funcao_id"
        JOIN "produtos" ON "produtos"."id" = "membros"."produto_id";

-- lista todos os escopos
DROP VIEW IF EXISTS "lista_escopos";
CREATE VIEW IF NOT EXISTS "lista_escopos" AS 
    SELECT 
        "escopos"."id" as "id_escopo",
        "produtos"."nome" as "produto",
        "escopos"."nome" AS "escopo",
        "escopos"."descricao" AS "descricao"
    FROM "escopos"
        JOIN "produtos" ON "produtos"."id" = "escopos"."produto_id"
    ORDER BY "produto";
-- -------------------------------------------------------------------
-- INSERINDO DADOS TESTES 
-- -------------------------------------------------------------------

-- inserções testes na tabela de pessoas
INSERT INTO "pessoas" ("id","nome")
VALUES
    (0, 'Gleber'),
    (1, 'Alencar'),
    (2, 'Suelly'),
    (3, 'Cap Monteiro'),
    (4, 'Cap Benedict'),
    (5, 'Maj Luis');

-- inserções testes na tabela de proponentes
INSERT INTO "proponentes"("id","nome", "representante_id")
VALUES
    (0, 'CORREGEDOR3A', 3),
    (1, 'DAL', 4),
    (2, 'DGA', 5);

-- inserções testes na tabela de produtos
INSERT INTO "produtos" ("id","nome", "descricao", "data_inicio", "proponente_id")
VALUES 
    (0, 'Sis Demandas Corregedoria', 'descricao', '2025-03-02', 0),
    (1, 'Sis Reserva DAL', 'descricao', '2025-03-02', 1),
    (2, 'Sis Contratos DGA', 'descricao', '2025-03-02', 2);

-- inserções testes na tabela de membros
INSERT INTO "membros" ("id", "pessoa_id", "funcao_id", "produto_id")
VALUES
    (0, 0, 0, 0), -- PO SIS CORREGEDORIA
    (1, 1, 1, 0), -- QA SIS CORREGEDORIA
    (2, 2, 2, 0), -- DV SIS CORREGEDORIA
    (3, 0, 0, 1), -- PO SIS RESERVA
    (4, 1, 1, 1), -- QA SIS RESERVA
    (5, 2, 2, 1), -- DV SIS RESERVA
    (6, 0, 0, 2), -- PO SIS CONTRATOS
    (7, 1, 1, 2), -- QA SIS CONTRATOS
    (8, 2, 2, 2); -- DV SIS CONTRATOS

-- inserções testes na tabela de escopo
INSERT INTO "escopos"("id", "nome", "descricao", "produto_id")
VALUES
    (0, 'Gestão e Controle de Usuários', 'CRUD de Usuarios', 0 ),
    (1, 'Gestão e Controle de Usuários', 'CRUD de Usuarios', 1 ),
    (2, 'Gestão e Controle de Usuários', 'CRUD de Usuarios', 2 ),
    (3, 'Cadastro de Demanda', 'CRUD de demandas', 0 ),
    (4, 'Gestão de Cautelas', 'CRUD de Cautelas', 1 ),
    (5, 'Cadastro Contratos', 'CRUD de Contratos', 2 );

-- inserções testes na tabela de requisitos
INSERT INTO "requisitos" ("id", "descricao", "prioridade", "data_status", "tipo_id", "status_id", "escopo_id")
VALUES
    (0, 'cadastrar uma demanda da corregedoria', 'normal', '2025-03-02', 0, 0, 3 ),
    (1, 'Registrar uma cautela no nome de um militar', 'normal', '2025-03-02', 0, 0, 4 ),
    (2, 'cadastrar um contrato de serviço', 'normal', '2025-03-02', 0, 0, 5 ),
    (3, 'designar um gestor para o contrato', 'normal', '2025-03-02', 0, 0, 5 );