
-- Criação da role para admistração do banco de dados.
CREATE ROLE guiaraujo WITH
	CREATEDB
	INHERIT
	LOGIN
	PASSWORD '1234';

--criação do banco de dados e decidir seu proprietário
--codificação UTF-8
CREATE DATABASE uvv
    WITH 
    OWNER = guiaraujo
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    CONNECTION LIMIT = -1;


\c uvv
--Criação d schema elmasri e autorização para o usuário criado anteriormente.
CREATE SCHEMA elmasri  AUTHORIZATION guiaraujo;

--Tornando o Schema elmasri como padrão.
SET SEARCH_PATH TO elmasri, "\$user", public;
select current_schema();

--crição da tabela funcionario
CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(60),
                sexo CHAR(1) CHECK(sexo= 'M' OR sexo= 'F'),
                salario NUMERIC(10,2) CHECK(salario>0),
                cpf_supervisor CHAR(11) CHECK(cpf_supervisor != cpf),-- verificação da chave primária em relação ao cpf do supervisor
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (cpf) --criação da primary key da tabela
);

--crição da tabela dependente
CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1) CHECK(sexo= 'M' OR sexo= 'F'),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT dependente_pk PRIMARY KEY (cpf_funcionario, nome_dependente) --criação da tabela para armazenar os dependentes dos funcionários
);

--criação da tabela para armazenar os departamentos
CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL CHECK (numero_departamento>=0),
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT departamento_pk PRIMARY KEY (numero_departamento)
);

-- criação da alternate key da tabela departamento
CREATE UNIQUE INDEX departamento_ak
 ON elmasri.departamento
 ( nome_departamento );

--criação da tabela para armazenar os projetos
CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL CHECK (numero_projeto>=0),
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL CHECK(numero_departamento>=0),
                CONSTRAINT projeto_pk PRIMARY KEY (numero_projeto)
);

--criação da alternate key da tabela projeto
CREATE UNIQUE INDEX projeto_ak
 ON elmasri.projeto
 ( nome_projeto );

--criação da tabela de local de trabalho
CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL CHECK (numero_projeto>=0),
                horas NUMERIC(3,1) CHECK(horas>=0),
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);


--criação da tabela para armazenar a localização dos departamentos
CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL CHECK (numero_departamento>=0),
                local VARCHAR(15) NOT NULL,
                CONSTRAINT localizacoes_departamento_pk PRIMARY KEY (numero_departamento, local)
);
 

--criação da foreign key cpf_gerente na tabela departamento
ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key cpf_funcionario na tabela dependente
ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key cpf_funcionario na tabela trabalha_em
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key cpf_supervisor na tabela funcionário
ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key numero_departamento na tabela localizacoes_departamento
ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key numero_departamento na tabela projeto
ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--criação da foreign key numero_projeto na tabela trabalha_em
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


--FORMAT0 DATE: YYYY/MM/DD
--inserção dos dados na tabela funcionário
INSERT INTO elmasri.funcionario(
    cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
    VALUES (88866555576, 'Jorge', 'E', 'Brito', '1937/11/10', 'Rua do Horto 35 São Paulo, SP', 'M', 55000,NULL, 1),
           (98765432168,'Jennifer','S', 'Souza', '1941/06/20','Av.Arthur d Lima, 54, Santo André, SP', 'F', 43000,88866555576, 4),
           (99988777767,'Alice','J', 'Zelaya', '1968/01/19','Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, 98765432168, 4),
           (98798798733,'André','V', 'Pereira', '1969/03/29','Rua Timbira,35, São Paulo, SP', 'M', 25000, 98765432168, 4),
           (33344555587,'Fernando','T', 'Wong', '1955/12/08','Rua da Lapa, 34, São Paulo, SP', 'M', 40000, 88866555576, 5),
           (45345345376,'Joice','A', 'Leite', '1972/07/31','Av.Lucas Obes 74, São Paulo, SP', 'F', 25000, 33344555587, 5),
           (66688444476,'Ronaldo','K', 'Lima', '1962/09/15','Rua Rebouças, 65, Piracicaba, SP', 'M', 38000, 33344555587, 5),
           (12345678966,'João','B', 'Silva', '1965/01/09','Rua das Flores, 751,São Paulo, SP', 'M', 30000, 33344555587, 5);
		   
--inserção dos dados na tabela departamento
INSERT INTO elmasri.departamento(
	numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
	VALUES (5,'Pesquisa',33344555587 , '1988/05/22'),
           (4,'Administração',98765432168 , '1995/01/01'),
           (1,'Matriz',88866555576, '1981/06/19');
		   
--inserção dos dados na tabela localizacoes_departamento		   
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (1, 'São Paulo'),
           (4, 'Mauá'),
           (5, 'Santo André'),
           (5, 'Itu'),
           (5, 'São Paulo');

--inserção dos dados na tabela projeto
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (1, 'ProdutoX', 'Santo André', 5),
           (2, 'ProdutoY', 'Itu', 5),
           (3, 'ProdutoZ', 'São Paulo', 5),
           (10, 'Informatização', 'Mauá', 4),
           (20, 'Reorganização', 'São Paulo', 1),
           (30, 'Novosbenefícios', 'Mauá', 4);

--inserção dos dados na tabela dependente
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (33344555587, 'Alicia', 'F', '1986/04/05', 'Filha'),
           (33344555587, 'Tiago', 'M', '1983/10/25', 'Filho'),
           (33344555587, 'Janaina', 'F', '1958/05/03', 'Esposa'),
           (98765432168, 'Antonio', 'M', '1942/02/28', 'Marido'),
           (12345678966, 'Michael', 'M', '1988/01/04', 'Filho'),
           (12345678966, 'Alicia', 'F', '1988/12/30', 'Filha'),
           (12345678966, 'Elizabeth', 'F', '1967/05/05', 'Esposa');
		   
--inserção dos dados na tabela trabalha em
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (12345678966, 1, 32.5),
           (12345678966, 2, 7.5),
           (66688444476, 3, 40.0),
           (45345345376, 1, 20.0),
           (45345345376, 2, 20.0),
           (33344555587, 2, 10.0),
           (33344555587, 3, 10.0),
           (33344555587, 10, 10.0),
           (33344555587, 20, 10.0),
           (99988777767, 30, 30.0),
           (99988777767, 10, 10.0),
           (98798798733, 10, 35.0),
           (98798798733, 30, 5.0),
           (98765432168, 30, 20.0),
           (98765432168, 20, 15.0),
           (88866555576, 20, NULL);
