-- QUESTÃO 01: prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
SELECT  numero_departamento, 
       AVG(salario) AS media_salarial		-- usa a função average para calcular a media
FROM funcionario 				-- seleciona a tabela funcionario 
GROUP BY numero_departamento
ORDER BY numero_departamento ;			-- agrupado e ordenado pelo número de departamento 


--QUESTÃO 02: prepare um relatório que mostre a média salarial dos homens e das mulheres.
SELECT sexo, 
       AVG(salario) AS media_genero		--usa a função average para calcular a média
       
FROM funcionario				-- seleciona a tabela funcionario  			
GROUP BY sexo
ORDER BY sexo ;					--agrupado e ordenado  por sexo

/*QUESTÃO 03: prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, 		--selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 									--selecionado a data de nascimento 
	DATE_PART('year', AGE(f.data_nascimento))  as idade, 					--idade do funcionário através da função AGE
	f.salario,
	d.nome_departamento 
FROM 	funcionario f 

JOIN departamento d on f.numero_departamento  = d.numero_departamento 
ORDER BY nome_departamento 	--ordenado por nome_departamento 

/*QUESTÃO 04:prepare um relatório que mostre o nome completo dos funcionários, a idade em anos completos, o salário atual e o salário com um reajuste que
obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o
reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a
35.000 o reajuste deve ser de 15%.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, 	--selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 
	DATE_PART('year', AGE(f.data_nascimento)) as idade, 				--idade do funcionário através da função AGE
	f.salario AS salario_atual,							-- o salario é  renomeado como salario_atual 
	(case when(f.salario < '35000') then f.salario * 1.20
			when (f.salario >= '35000')then f.salario * 1.15 end) as salario_reajuste	/*usamos o case para uma condição de reajuste dependendo do salário
																					      do funcionário */				
FROM 	funcionario f 						--os dados selecionados vêm de funcionario 
	
/*QUESTÃO 05: prepare um relatório que liste, para cada departamento, o nome
do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento 
(em ordem crescente) e por salário dos funcionários (em ordem decrescente).
*/
SELECT D.nome_departamento,
CAST (case when D.cpf_gerente = f.cpf THEN 
	(f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) END AS varchar(31)) as nome_gerente, 
	(f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome_funcionario, 
	f.salario
FROM 	funcionario f	
	
INNER JOIN departamento d
ON F.numero_departamento = D.numero_departamento
ORDER BY D.nome_departamento ASC, F.salario DESC;	
	
/*QUESTÃO 06: prepare um relatório que mostre o nome completo dos funcionários que 
têm dependentes, o departamento onde eles trabalham e, para cada funcionário, também liste o nome completo dos dependentes, a idade em anos de cada
dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer
como “Masculino” ou “Feminino”).*/
SELECT F.numero_departamento,
(F.primeiro_nome ||' '|| F.nome_meio ||' '|| F.ultimo_nome) AS nome_funcionario,
D.nome_dependente, 
	DATE_PART('year', AGE(D.data_nascimento)) AS idade_dependente, (CASE WHEN (D.sexo='M') THEN 'Masculino' WHEN (D.sexo='F') THEN 'Feminino'END) AS sexo
	FROM funcionario AS F, dependente AS D
	WHERE F.cpf = D.cpf_funcionario;
	
/*QUESTÃO 07: prepare um relatório que mostre, para cada funcionário que NÃO
TEM dependente, seu nome completo, departamento e salário.*/

SELECT (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario,
F.numero_departamento,
F.salario
FROM 	funcionario AS F
	WHERE F.cpf NOT IN (SELECT D.cpf_funcionario FROM dependente AS D);

/*QUESTÃO 08: prepare um relatório que mostre, para cada departamento, os projetos desse departamento e o nome completo dos funcionários que estão alocados
em cada projeto. Além disso inclua o número de horas trabalhadas por cada funcionário, em cada projeto.
4*/

SELECT D.nome_departamento, P.nome_projeto, (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario,
CAST (CASE WHEN T.horas is null then 0 else T.horas end as DECIMAL(3, 1)) as horas

FROM funcionario AS F
		
	INNER JOIN trabalha_em AS T
	ON F.cpf = T.cpf_funcionario
	INNER JOIN projeto AS P
	ON T.numero_projeto = P.numero_projeto
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	ORDER BY D.nome_departamento, P.nome_projeto, F.salario DESC;

/*QUESTÃO 09: prepare um relatório que mostre a soma total das horas de cada
projeto em cada departamento. Obs.: o relatório deve exibir o nome do departamento, o nome do projeto e a soma total das horas.*/

SELECT D.nome_departamento, P.nome_projeto,
CAST (CASE WHEN SUM(T.horas) is null then 0 else SUM(T.horas) end as DECIMAL(3, 1)) AS total_horas

FROM 	funcionario AS F
		
	INNER JOIN trabalha_em AS T
	ON F.cpf = T.cpf_funcionario
	INNER JOIN projeto AS P
	ON T.numero_projeto = P.numero_projeto
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	GROUP BY D.nome_departamento, P.nome_projeto;

/*QUESTÃO 10: prepare um relatório que mostre a média salarial dos funcionários
de cada departamento.*/

SELECT D.nome_departamento,
CAST (AVG(salario) AS DECIMAL(10,2)) AS media_salarial
FROM 	funcionario AS F
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	GROUP BY D.nome_departamento;

--falta comentar
