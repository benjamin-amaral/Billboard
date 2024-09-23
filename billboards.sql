/* Perguntas de negócio:
1 - Quem é o artista/banda que ficou mais vezes em primeiro lugar?
2 - Quantos albuns tem cada artista?
3 - Qual a média de duração geral e por cada artista?
4 - Qual a afinação mais usada? 0: 'C', 1: 'C#', 2: 'D', 3: 'D#', 4: 'E', 5: 'F', 6: 'F#', 7: 'G', 8: 'G#', 9: 'A', 10: 'A#', 11: 'B'
5 - Qual a afinação média usada por artista
6 - Qual a afinação mais usada por artista?
*/
SELECT * from hot100;

-- Alterar nome quebrado da coluna para "Track"
ALTER TABLE hot100
RENAME COLUMN ï»¿Track TO Track;

-- Apagar linhas Nulas
DELETE FROM hot100 WHERE Track IS NULL;

-- Add nova coluna para correção futuramente converter o tempo
ALTER TABLE hot100
ADD COLUMN Duration_t time;

-- Atualizando a coluna Duration_t e convertempo o tempo da coluna Duration que está em milisegundos para H:M:S 
SET SQL_SAFE_UPDATES = 0;
update hot100
set Duration_t = SEC_TO_TIME(Duration/1000);

-- Exercício 1 - Quantas são e quem é o artista/banda que ficou mais vezes em primeiro lugar? R: São 87 bandas diferentes, 21 delas estão empatadas em 1º lugar com 10 músicas cada
SELECT COUNT(DISTINCT Artist)
From hot100;

SELECT Artist, COUNT(*)
From hot100
Group by Artist
order by COUNT(*) DESC;

-- Como tem vários artistas empatados com 10 tracks, vou mostrar somente os empatados em primeiro lugar

SELECT COUNT(*) AS Total_artistas
FROM(
	SELECT Artist, COUNT(*) AS Vezes_topo
	From hot100
	Group by Artist
	HAVING Vezes_topo = 10
	order by COUNT(*) DESC
) AS Subquery;

-- Exercício 2 - Quantos albuns tem cada artista?

SELECT Artist, count(Album) from hot100
group by Artist
Order by Count(Album) DESC;

-- 3 - Qual a média de duração geral e por cada artista? E a geral?

SELECT Artist, sec_to_time(AVG(Duration_t)) from hot100
group by Artist;

select sec_to_time(AVG(Duration_t)) from hot100; 

-- Exercício 4 - Qual a afinação mais usada? 0: 'C', 1: 'C#', 2: 'D', 3: 'D#', 4: 'E', 5: 'F', 6: 'F#', 7: 'G', 8: 'G#', 9: 'A', 10: 'A#', 11: 'B'

-- Criar uma tabela para inserir as afinações
ALTER TABLE hot100
ADD COLUMN Tuning VARCHAR(2);

SET SQL_SAFE_UPDATES = 0;
update hot100
SET Tuning = Case
    WHEN `Key` = 0 THEN 'C'
    WHEN `Key` = 1 THEN 'C#'
    WHEN `Key` = 2 THEN 'D'
    WHEN `Key` = 3 THEN 'D#'
    WHEN `Key` = 4 THEN 'E'
    WHEN `Key` = 5 THEN 'F'
    WHEN `Key` = 6 THEN 'F#'
    WHEN `Key` = 7 THEN 'G'
    WHEN `Key` = 8 THEN 'G#'
    WHEN `Key` = 9 THEN 'A'
    WHEN `Key` = 10 THEN 'A#'
    WHEN `Key` = 11 THEN 'B'
END;

-- Estava com problemas com o nome da coluna sendo Key, alterei para a coluna Chave, para facilitar as consultas
ALTER TABLE hot100
RENAME COLUMN `Key` TO Chave;

SELECT round(avg(Chave)), CASE
	WHEN round(avg(Chave)) = 0 THEN 'C'
    WHEN round(avg(Chave)) = 2 THEN 'D'
    WHEN round(avg(Chave)) = 3 THEN 'D#'
    WHEN round(avg(Chave)) = 4 THEN 'E'
    WHEN round(avg(Chave)) = 5 THEN 'F'
    WHEN round(avg(Chave)) = 6 THEN 'F#'
    WHEN round(avg(Chave)) = 7 THEN 'G'
    WHEN round(avg(Chave)) = 8 THEN 'G#'
    WHEN round(avg(Chave)) = 9 THEN 'A'
    WHEN round(avg(Chave)) = 10 THEN 'A#'
    WHEN round(avg(Chave)) = 11 THEN 'B'
END AS Avg_Tuning
From hot100;

-- Exercício 5 - Qual a afinação média usada por artista?
SELECT Artist, round(avg(Chave)) , CASE
	WHEN round(avg(Chave)) = 0 THEN 'C'
    WHEN round(avg(Chave)) = 2 THEN 'D'
    WHEN round(avg(Chave)) = 3 THEN 'D#'
    WHEN round(avg(Chave)) = 4 THEN 'E'
    WHEN round(avg(Chave)) = 5 THEN 'F'
    WHEN round(avg(Chave)) = 6 THEN 'F#'
    WHEN round(avg(Chave)) = 7 THEN 'G'
    WHEN round(avg(Chave)) = 8 THEN 'G#'
    WHEN round(avg(Chave)) = 9 THEN 'A'
    WHEN round(avg(Chave)) = 10 THEN 'A#'
    WHEN round(avg(Chave)) = 11 THEN 'B'
END AS Avg_Tuning
From hot100
Group by Artist;

-- 5 - Qual a afinação mais usada por artista

Select count(Chave),Chave
from hot100
group by chave
order by chave;
	
-- chatgpt solução
SELECT Artist, Most_Tuning, MAX(Chave_Contagem) AS Contagem
FROM (
    SELECT Artist, 
           CASE
               WHEN Chave = 0 THEN 'C'
               WHEN Chave = 1 THEN 'C#'
               WHEN Chave = 2 THEN 'D'
               WHEN Chave = 3 THEN 'D#'
               WHEN Chave = 4 THEN 'E'
               WHEN Chave = 5 THEN 'F'
               WHEN Chave = 6 THEN 'F#'
               WHEN Chave = 7 THEN 'G'
               WHEN Chave = 8 THEN 'G#'
               WHEN Chave = 9 THEN 'A'
               WHEN Chave = 10 THEN 'A#'
               WHEN Chave = 11 THEN 'B'
           END AS Most_Tuning,
           COUNT(*) AS Chave_Contagem
    FROM hot100
    GROUP BY Artist, Chave
) AS Subquery
GROUP BY Artist, Most_Tuning
ORDER BY Contagem DESC;

-- entendendo a subquery anterior

SELECT Artist, 
           CASE
               WHEN Chave = 0 THEN 'C'
               WHEN Chave = 1 THEN 'C#'
               WHEN Chave = 2 THEN 'D'
               WHEN Chave = 3 THEN 'D#'
               WHEN Chave = 4 THEN 'E'
               WHEN Chave = 5 THEN 'F'
               WHEN Chave = 6 THEN 'F#'
               WHEN Chave = 7 THEN 'G'
               WHEN Chave = 8 THEN 'G#'
               WHEN Chave = 9 THEN 'A'
               WHEN Chave = 10 THEN 'A#'
               WHEN Chave = 11 THEN 'B'
           END AS Most_Tuning,
           COUNT(*) AS Chave_Contagem
    FROM hot100
    GROUP BY Artist, Chave;

-- Executando depois de aprender a aplicação do chat GPT

select Artist, chaves_af, max(contagem)
from (SELECT Artist, Case 
		WHEN Chave = 0 THEN 'C'
		WHEN Chave = 1 THEN 'C#'
		WHEN Chave = 2 THEN 'D'
		WHEN Chave = 3 THEN 'D#'
		WHEN Chave = 4 THEN 'E'
		WHEN Chave = 5 THEN 'F'
		WHEN Chave = 6 THEN 'F#'
		WHEN Chave = 7 THEN 'G'
		WHEN Chave = 8 THEN 'G#'
		WHEN Chave = 9 THEN 'A'
		WHEN Chave = 10 THEN 'A#'
		WHEN Chave = 11 THEN 'B'
		End as chaves_af,
		count(*) as contagem
	from hot100
	group by artist, chaves_af
) as subquery
group by Artist, chaves_af
order by contagem;



