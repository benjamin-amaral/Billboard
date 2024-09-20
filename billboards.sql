/* Perguntas de negócio:
1 - Quem é o artista/banda que ficou mais vezes em primeiro lugar?
2 - Quantos albuns tem cada artista?
3 - Qual a média de duração geral e por cada artista?
4 - Qual a afinação mais usada? 0: 'C', 1: 'C#', 2: 'D', 3: 'D#', 4: 'E', 5: 'F', 6: 'F#', 7: 'G', 8: 'G#', 9: 'A', 10: 'A#', 11: 'B'
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

-- 3 - Qual a média de duração geral e por cada artista?




 
