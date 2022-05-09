-- Questão 1: prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
SELECT  numero_departamento, 
       AVG(salario) AS media_salarial 	-- usa a função average para calcular a media
FROM funcionario 						-- seleciona a tabela funcionario 
GROUP BY numero_departamento
order BY numero_departamento ;			-- agrupado e ordenado pelo número de departamento 


--Questão 2: prepare um relatório que mostre a média salarial dos homens e das mulheres.
SELECT sexo, 
       AVG(salario) AS media_genero		--usa a função average para calcular a média
       
FROM funcionario						-- seleciona a tabela funcionario  			
GROUP BY sexo
ORDER BY sexo ;							--agrupado e ordenado  por sexo


/*Questão 3: prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário.*/

select 
	f.primeiro_nome ||' '|| f.nome_meio||' '||f.ultimo_nome as nome_completo, --selecionado os nomes de todos os funcionários e agrupamos por nome_completo 
	f.data_nascimento, 
	DATE_PART('year', current_date)- DATE_PART('year', f.data_nascimento) as idade, --idade do funcionário através da data atual menos a data_nascimento
	f.salario,
	d.nome_departamento 
from 
	funcionario f 

join departamento d on f.numero_departamento  = d.numero_departamento 
order by  nome_departamento 			--ordenado por nome_departamento 
