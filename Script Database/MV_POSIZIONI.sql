-- Trovare gli animali che stanno più vicini durante il pascolo
-- Di tali animali trovare quali non stanno nello stesso locale 
DROP TABLE IF EXISTS MV_POSIZIONI;
DROP EVENT IF EXISTS EVENT_POSIZIONI;
DROP PROCEDURE IF EXISTS PROCEDURE_POSIZIONI;
DROP PROCEDURE IF EXISTS RESOCONTO_POSIZIONI;
/* Creo la Materialized View */
CREATE TABLE MV_POSIZIONI(
	Animale CHAR(5),
    Latitudine INTEGER,
    Longitudine INTEGER,
    Time_Stamp TIMESTAMP,
	PRIMARY KEY(Animale,Time_Stamp)
);
DELIMITER $$
/* Creo l'Event che aggiornerà la Materialized View */
CREATE EVENT EVENT_POSIZIONI
ON SCHEDULE EVERY 30 DAY
STARTS '2030-01-29 23:27:00'
DO 
BEGIN 
	CALL PROCEDURE_POSIZIONI();
END $$
/* Creo la Procedura per l'aggiornamento effettivo */
CREATE PROCEDURE PROCEDURE_POSIZIONI()
BEGIN 
	-- Elimino i dati presenti nella tabella
	TRUNCATE TABLE MV_POSIZIONI;
    
    -- Inserisco i nuovi dati nella tabella
    INSERT INTO MV_POSIZIONI
    WITH PosizioniTarget AS(
		-- Trovo le posizioni degli animali durante il pascolo 
        -- solamente nell'ultimo mese 
		SELECT G.Animale,G.Latitudine,G.Longitudine,G.Time_Stamp
		FROM GPS G
			 INNER JOIN Animale A
			 ON G.Animale = A.CodiceAnimale
		WHERE TIME(G.Time_Stamp) BETWEEN (
					SELECT DISTINCT P.OraInizio
					FROM Pascolo P
					WHERE P.Locale = A.Locale
                    LIMIT 1
								   )
			  AND (
					SELECT DISTINCT P.OraFine
					FROM Pascolo P
					WHERE P.Locale = A.Locale
                    LIMIT 1
				  )
	)
    -- Seleziono gli animali che pascolano in gruppo 
	SELECT PT.Animale,PT.Latitudine,PT.Longitudine,PT.Time_Stamp
	FROM PosizioniTarget PT
	WHERE EXISTS(
			SELECT *
			FROM PosizioniTarget PT2
			WHERE PT.Time_Stamp = PT2.Time_Stamp
				  AND PT.Animale <> PT2.Animale
				  AND PT.Latitudine = PT2.Latitudine
                  AND PT.Longitudine = PT2.Longitudine
				)
	ORDER BY PT.Time_Stamp,PT.Latitudine,PT.Longitudine;
END $$
/* Creo la procedura che stamperà il resoconto della Materialized View */
CREATE PROCEDURE RESOCONTO_POSIZIONI()
BEGIN 
     WITH Animali AS(
		SELECT *
        FROM MV_POSIZIONI
    )
    SELECT GROUP_CONCAT( 
		CONCAT( 
			'SUM(IF(Animale <> ''',A.Animale,'''
				    AND Longitudine = ''',A.Longitudine,''' 
					AND Latitudine = ''',A.Latitudine,''' 
                    AND Time_Stamp = ''',A.Time_Stamp,''',1,0)) AS ''',A.Animale,''''
			  )
				   )
	FROM Animali A
	INTO @pivot_query;
    SET @pivot_query = CONCAT(
						'SELECT Animale,',@pivot_query,
						'FROM MV_POSIZIONI
                         GROUP BY Animale;'
						 );
	PREPARE sql_statement FROM @pivot_query;
	EXECUTE sql_statement;
END $$
DELIMITER ;