-- QUESTÃO 01: prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
SELECT  numero_departamento, 
       AVG(salario) AS media_salarial	-- usa a função average para calcular a media
FROM funcionario 					 		-- seleciona a tabela funcionario 
GROUP BY numero_departamento
ORDER BY numero_departamento ;						-- agrupado e ordenado pelo número de departamento 


--QUESTÃO 02: prepare um relatório que mostre a média salarial dos homens e das mulheres.
SELECT sexo, 
       AVG(salario) AS media_genero					--usa a função average para calcular a média
       
FROM funcionario							-- seleciona a tabela funcionario  			
GROUP BY sexo
ORDER BY sexo ;									--agrupado e ordenado  por sexo


/*QUESTÃO 03: prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, --selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 							--selecionado a data de nascimento 
	DATE_PART('year', AGE(f.data_nascimento)) as idade, --idade do funcionário através da função AGE
	f.salario,
	d.nome_departamento 
FROM funcionario f 

JOIN departamento d on f.numero_departamento  = d.numero_departamento 
ORDER BY nome_departamento 	--ordenado por nome_departamento 


/*QUESTÃO 04:prepare um relatório que mostre o nome completo dos funcionários, a idade em anos completos, o salário atual e o salário com um reajuste que
obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o
reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a
35.000 o reajuste deve ser de 15%.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, --selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 
	DATE_PART('year', AGE(f.data_nascimento)) as idade, 			--idade do funcionário através da função AGE
	f.salario AS salario_atual,						-- o salario é  renomeado como salario_atual 
	(case when(f.salario < '35000') then f.salario * 1.20
			when (f.salario >= '35000')then f.salario * 1.15 end) as salario_reajuste /*usamos o case para uma condição de reajuste dependendo do salário
																					      do funcionário */				
FROM funcionario f 								--os dados selecionados vêm de funcionario 
	
/*QUESTÃO 05: prepare um relatório que liste, para cada departamento, o nome
do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento 
(em ordem crescente) e por salário dos funcionários (em ordem decrescente).
*/
SELECT D.nome_departamento,
CAST (case when D.cpf_gerente = f.cpf THEN 
	(f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) END AS varchar(31)) as nome_gerente, 	/**/
	(f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome_funcionario, 
	f.salario
FROM funcionario f	
	
INNER JOIN departamento d
ON F.numero_departamento = D.numero_departamento
ORDER BY D.nome_departamento ASC, F.salario DESC;
	
	
/*QUESTÃO 06: prepare um relatório que mostre o nome completo dos funcionários que 
têm dependentes, o departamento onde eles trabalham e, para cada funcionário, também liste o nome completo dos dependentes, a idade em anos de cada
dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer
como “Masculino” ou “Feminino”).*/

SELECT F.numero_departamento,
(F.primeiro_nome ||' '|| F.nome_meio ||' '|| F.ultimo_nome) AS nome_completo ,
D.nome_dependente, 
	DATE_PART('year', AGE(D.data_nascimento)) AS idade_dependente,
	(CASE WHEN (D.sexo='M') THEN 'Masculino' WHEN (D.sexo='F') THEN 'Feminino'END) AS sexo
	--idade do funcionário através da função AGE
	FROM funcionario AS F, dependente AS D
	WHERE F.cpf = D.cpf_funcionario;

	
/*QUESTÃO 07: prepare um relatório que mostre, para cada funcionário que NÃO
TEM dependente, seu nome completo, departamento e salário.*/

SELECT (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario,
F.numero_departamento,
F.salario
	FROM funcionario AS F
	WHERE F.cpf NOT IN (SELECT D.cpf_funcionario FROM dependente AS D);

/*QUESTÃO 08: prepare um relatório que mostre, para cada departamento, os projetos desse departamento e o nome completo dos funcionários que estão alocados
em cada projeto. Além disso inclua o número de horas trabalhadas por cada funcionário, em cada projeto.
4*/

SELECT D.nome_departamento, P.nome_projeto,
(F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario,
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

	FROM funcionario AS F
		
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
	FROM 
		funcionario AS F
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	GROUP BY D.nome_departamento;



/*QUESTÃO 11: considerando que o valor pago por hora trabalhada em um projeto
é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o
nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas naquele projeto.*/

SELECT (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario,
P.nome_projeto, CAST (CASE WHEN T.horas is null then 0 else (T.horas * 50) END AS DECIMAL(10,2)) AS valor_total  --a cada hora se recebe 50 reais como valor total 
	FROM funcionario AS F
	INNER JOIN trabalha_em AS T
	ON F.cpf = T.cpf_funcionario
	INNER JOIN projeto AS P
	ON T.numero_projeto = P.numero_projeto
	ORDER BY F.salario DESC;						--ordenado por salário do funcionário por ordem decrescente 


/*QUESTÃO 12: seu chefe está verificando as horas trabalhadas pelos funcionários
nos projetos e percebeu que alguns funcionários, mesmo estando alocadas à algum
projeto, não registraram nenhuma hora trabalhada. Sua tarefa é preparar um relatório 
que liste o nome do departamento, o nome do projeto e o nome dos funcionários
que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada.*/

SELECT D.nome_departamento, P.nome_projeto,
(F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario_sem_horas
FROM funcionario AS F
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	INNER JOIN trabalha_em AS T
	ON F.cpf = T.cpf_funcionario
	INNER JOIN projeto AS P
	ON T.numero_projeto = P.numero_projeto
	WHERE T.horas IS NULL;							-- Quando as horas forem nulas, será consultado tal(ais) funcionario(s) 

/*QUESTÃO 13: Um relatório que listasse o nome completo das pessoas a serem
presenteadas (funcionários e dependentes), o sexo e a idade em anos completos
(para poder comprar um presente adequado). Esse relatório deve estar ordenado
pela idade em anos completos, de forma decrescente.*/

SELECT (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_completo ,
(case when (F.sexo='M') then 'Masculino' when (F.sexo='F') then 'Feminino'end) as sexo,		
	DATE_PART('year', AGE(F.data_nascimento)) AS idade
	FROM funcionario AS F							--selecionando os funcionários a receberem presentes
	
	union  									--unindo os funcionários e dependentes 
	
	SELECT (D.nome_dependente) AS nome_completo ,
	(case when (D.sexo='M') then 'Masculino' when (D.sexo='F') then 'Feminino'end) as sexo,
	DATE_PART('year', AGE(D.data_nascimento)) AS idade
	FROM dependente AS D							--selecionando os dependentes a receberem presentes
	ORDER BY idade DESC;							--ordenado por idade em ordem decrescente 


/*QUESTÃO 14: prepare um relatório que exiba quantos funcionários cada departamento tem.*/
SELECT D.nome_departamento, COUNT(F.cpf) AS quantidade_funcionarios 		-- função COUNT que faz a contagem o cpf dos funcionários por departamento 
	FROM funcionario AS F
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	GROUP BY D.nome_departamento;						--ordenado pelo nome do departamento 



/*QUESTÃO 15: como um funcionário pode estar alocado em mais de um projeto,
prepare um relatório que exiba o nome completo do funcionário, o departamento
desse funcionário e o nome dos projetos em que cada funcionário está alocado.
Atenção: se houver algum funcionário que não está alocado em nenhum projeto,
o nome completo e o departamento também devem aparecer no relatório.*/

SELECT (F.primeiro_nome||' '|| F.nome_meio||' '|| F.ultimo_nome) AS nome_funcionario, D.nome_departamento,
P.nome_projeto
	FROM funcionario AS F
	INNER JOIN trabalha_em AS T
	ON F.cpf = T.cpf_funcionario
	INNER JOIN projeto AS P
	ON T.numero_projeto = P.numero_projeto
	INNER JOIN departamento AS D
	ON F.numero_departamento = D.numero_departamento
	ORDER BY nome_funcionario;


