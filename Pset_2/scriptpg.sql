-- QUESTÃO 01: prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
SELECT  numero_departamento, 
       AVG(salario) AS media_salarial 		-- usa a função average para calcular a media
FROM funcionario 							-- seleciona a tabela funcionario 
GROUP BY numero_departamento
order BY numero_departamento ;				-- agrupado e ordenado pelo número de departamento 


--QUESTÃO 02: prepare um relatório que mostre a média salarial dos homens e das mulheres.
SELECT sexo, 
       AVG(salario) AS media_genero			--usa a função average para calcular a média
       
FROM funcionario							-- seleciona a tabela funcionario  			
GROUP BY sexo
ORDER BY sexo ;								--agrupado e ordenado  por sexo


/*QUESTÃO 03: prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, 		--selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 																--selecionado a data de nascimento 
	DATE_PART('year', current_date)- DATE_PART('year', f.data_nascimento) as idade, --idade do funcionário através da data atual menos a data_nascimento
	f.salario,
	d.nome_departamento 
FROM
	funcionario f 

JOIN departamento d on f.numero_departamento  = d.numero_departamento 
ORDER BY nome_departamento 															--ordenado por nome_departamento 


/*QUESTÃO 04:prepare um relatório que mostre o nome completo dos funcionários, a idade em anos completos, o salário atual e o salário com um reajuste que
obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o
reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a
35.000 o reajuste deve ser de 15%.*/

SELECT
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, 			--selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 
	DATE_PART('year', current_date)- DATE_PART('year', f.data_nascimento) as idade, 	--idade do funcionário através da data atual menos a data_nascimento
	f.salario AS salario_atual,															-- o salario é  renomeado como salario_atual 
	(case when(f.salario < '35000') then f.salario * 1.20
			when (f.salario >= '35000')then f.salario * 1.15 end) as salario_reajuste	/*usamos o case para uma condição de reajuste dependendo do salário
																					      do funcionário */				
FROM 
	funcionario f 						--os dados selecionados vêm de funcionario 
	
/*QUESTÃO 05: prepare um relatório que liste, para cada departamento, o nome
do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento 
(em ordem crescente) e por salário dos funcionários (em ordem decrescente).
*/

		
