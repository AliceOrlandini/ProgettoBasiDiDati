DROP TABLE IF EXISTS MV_QUALITAPROCESSO;
DROP EVENT IF EXISTS EVENT_QUALITAPROCESSO;
DROP PROCEDURE IF EXISTS PROCEDURE_QUALITAPROCESSO;
DROP PROCEDURE IF EXISTS RESOCONTO_QUALITAPROCESSO;
/* Creo la Materialized View */
CREATE TABLE MV_QUALITAPROCESSO(
	Formaggio VARCHAR(100),
    Fase VARCHAR(100),
    VariazioneDurata DOUBLE,
    VariazioneTemperatura DOUBLE,
    VariazioneRiposo DOUBLE,
	PRIMARY KEY(Formaggio,Fase)
);
DELIMITER $$
/* Creo l'Event che aggiornerà la Materialized View */
CREATE EVENT EVENT_QUALITAPROCESSO
ON SCHEDULE EVERY 1 MONTH 
STARTS '2030-01-29 23:27:00'
DO 
BEGIN 
	CALL PROCEDURE_QUALITAPROCESSO();
END $$
/* Creo la Procedura per l'aggiornamento effettivo */
CREATE PROCEDURE PROCEDURE_QUALITAPROCESSO()
BEGIN 
	-- Elimino i dati presenti nella materialized view
	TRUNCATE TABLE MV_QUALITAPROCESSO;
    -- Inserisco i nuovi dati nella materialized view
    INSERT INTO MV_QUALITAPROCESSO
	WITH FormaggiTarget AS(
		-- Per ogni formaggio ed ogni sua fase di preparazione
        -- trovo la media delle durate, della temperatura e dei
        -- tempi di riposo 
		SELECT P.Formaggio,
			   P.Fase,
			   AVG(P.Durata) AS MediaDurata,
			   AVG(P.Temperatura) AS MediaTemperatura,
			   AVG(P.Riposo) AS MediaRiposo
		FROM Possiede P
			 INNER JOIN Unita U
			 ON P.Unita = U.Codice
		GROUP BY P.Formaggio,P.Fase
	)
    -- Seleziono il formaggio, la fase e il modulo delle medie dei singoli
    -- valori meno i valori effettivi per quella fase
	SELECT FT.Formaggio,
		   FT.Fase,
		   ABS(FT.MediaDurata - F.Durata),
		   ABS(FT.MediaTemperatura - F.Temperatura),
		   ABS(FT.MediaRiposo - F.Riposo)
	FROM FormaggiTarget FT
		 INNER JOIN Fase F
		 ON (FT.Formaggio = F.Formaggio
		 AND FT.Fase = F.NomeFase);
END $$
/* Creo la procedura che stamperà il resoconto della Meterialized view */
CREATE PROCEDURE RESOCONTO_QUALITAPROCESSO()
BEGIN 
	SELECT *
    FROM MV_QUALITAPROCESSO;
END $$
DELIMITER ;