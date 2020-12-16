-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2019-05-25 16:58:50.279

-- tables
-- Table: cliente_final
CREATE TABLE cliente_final (
    id serial  NOT NULL,
    nome varchar(255)  NOT NULL,
    servico_seguranca_id int  NOT NULL,
    tipo_pessoa char(1) NOT NULL,
    CONSTRAINT cliente_final_pk PRIMARY KEY (id)
);

-- Table: endereco
CREATE TABLE endereco (
    id serial  NOT NULL,
    cep char(8)  NOT NULL,
    logradouro varchar(255)  NOT NULL,
    numero int  NOT NULL,
    referencia varchar(255)  NULL,
    bairro varchar(255)  NOT NULL,
    municipio varchar(255)  NOT NULL,
    uf char(2)  NOT NULL,
    CONSTRAINT endereco_pk PRIMARY KEY (id)
);

-- Table: instalacao
CREATE TABLE instalacao (
    id serial  NOT NULL,
    gas_threshold int NOT NULL,
    humi_threshold int NOT NULL,
    temp_threshold int NOT NULL,
    data_instalacao date  NOT NULL,
    cliente_final_id int  NOT NULL,
    endereco_id int  NOT NULL,
    dispositivo int  NOT NULL,
    CONSTRAINT dispositivo_unique UNIQUE (dispositivo) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT instalacao_pk PRIMARY KEY (id)
);

-- Table: ocorrencia
CREATE TABLE ocorrencia (
    id serial  NOT NULL,
    data_ocorrencia timestamp  NOT NULL,
    temperatura decimal(5,2)  NOT NULL,
    densidade_fumaca decimal(5,2)  NOT NULL,
    instalacao_id int  NOT NULL,
    estado int NOT NULL,
    CONSTRAINT ocorrencia_pk PRIMARY KEY (id)
);

-- Table: pessoa_fisica
CREATE TABLE pessoa_fisica (
    cliente_id int  NOT NULL,
    cpf char(11)  NOT NULL,
    CONSTRAINT cpf_unique UNIQUE (cpf) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT pessoa_fisica_pk PRIMARY KEY (cliente_id)
);

-- Table: pessoa_juridica
CREATE TABLE pessoa_juridica (
    cliente_id int  NOT NULL,
    cnpj char(15)  NOT NULL,
    CONSTRAINT cnpj_unique UNIQUE (cnpj) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT pessoa_juridica_pk PRIMARY KEY (cliente_id)
);

-- Table: servico_seguranca
CREATE TABLE servico_seguranca (
    id serial  NOT NULL,
    usuario varchar(255)  NOT NULL,
    senha varchar(40)  NOT NULL,
    CONSTRAINT servico_seguranca_pk PRIMARY KEY (id)
);

-- Table: telefone_associado
CREATE TABLE telefone_associado (
    id serial  NOT NULL,
    numero char(11)  NOT NULL,
    cliente_id int  NOT NULL,
    CONSTRAINT telefone_associado_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: cliente_final_servico_seguranca (table: cliente_final)
ALTER TABLE cliente_final ADD CONSTRAINT cliente_final_servico_seguranca
    FOREIGN KEY (servico_seguranca_id)
    REFERENCES servico_seguranca (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: instalacao_cliente_final (table: instalacao)
ALTER TABLE instalacao ADD CONSTRAINT instalacao_cliente_final
    FOREIGN KEY (cliente_final_id)
    REFERENCES cliente_final (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: instalacao_endereco (table: instalacao)
ALTER TABLE instalacao ADD CONSTRAINT instalacao_endereco
    FOREIGN KEY (endereco_id)
    REFERENCES endereco (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ocorrencia_instalacao (table: ocorrencia)
ALTER TABLE ocorrencia ADD CONSTRAINT ocorrencia_instalacao
    FOREIGN KEY (instalacao_id)
    REFERENCES instalacao (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: pessoa_fisica_cliente (table: pessoa_fisica)
ALTER TABLE pessoa_fisica ADD CONSTRAINT pessoa_fisica_cliente
    FOREIGN KEY (cliente_id)
    REFERENCES cliente_final (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: pessoa_juridica_cliente (table: pessoa_juridica)
ALTER TABLE pessoa_juridica ADD CONSTRAINT pessoa_juridica_cliente
    FOREIGN KEY (cliente_id)
    REFERENCES cliente_final (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: telefone_cliente (table: telefone_associado)
ALTER TABLE telefone_associado ADD CONSTRAINT telefone_cliente
    FOREIGN KEY (cliente_id)
    REFERENCES cliente_final (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

