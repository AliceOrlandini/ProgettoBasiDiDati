DROP TABLE IF EXISTS MV_FORMAGGIRESI;
DROP TABLE IF EXISTS MV_FORMAGGIRECENSITI;
DROP EVENT IF EXISTS EVENT_TRACCIABILITA;
DROP PROCEDURE IF EXISTS PROCEDURE_FORMAGGIRESI;
DROP PROCEDURE IF EXISTS PROCEDURE_FORMAGGIRECENSITI;
DROP PROCEDURE IF EXISTS RESOCONTO_TRACCIABILITA;
/* Creo la Materialized View relativa ai formaggi più resi */
CREATE TABLE MV_FORMAGGIRESI(
	Formaggio VARCHAR(100),
    PercentualeResi DOUBLE,
    PRIMARY KEY(Formaggio)
);
/* Creo la Materialized View relativi ai formaggi peggio recensiti */
CREATE TABLE MV_FORMAGGIRECENSITI(
	Formaggio VARCHAR(100),
    MediaRecensioni DOUBLE,
    PRIMARY KEY(Formaggio)
);
DELIMITER $$
/* Creo l'Event che aggiornerà le due Materialized View */
CREATE EVENT EVENT_TRACCIABILITA
ON SCHEDULE EVERY 1 MONTH 
STARTS '2030-01-29 23:27:00'
DO 
BEGIN 
	CALL PROCEDURE_FORMAGGIRESI();
    CALL PROCEDURE_FORMAGGIRECENSITI();
END $$
/* Creo la Procedura per l'aggiornamento effettivo dei formaggi resi */
CREATE PROCEDURE PROCEDURE_FORMAGGIRESI()
BEGIN 
	TRUNCATE TABLE MV_FORMAGGIRESI;
    INSERT INTO MV_FORMAGGIRESI
    WITH FormaggiResi AS(
		SELECT T.Formaggio,
			   (SUM(T.Quantita)/(
					SELECT SUM(A.Quantita)
                    FROM Acquisto A
                    WHERE A.Formaggio = T.Formaggio
								))*100 AS PercentualeResi
		FROM Tipo T
		GROUP BY T.Formaggio
		)
	SELECT *
	FROM FormaggiResi
	WHERE PercentualeResi > 50;
END $$
/* Creo la Procedura per l'aggiornamento effettivo dei formaggi recensiti */
CREATE PROCEDURE PROCEDURE_FORMAGGIRECENSITI()
BEGIN 
	TRUNCATE TABLE MV_FORMAGGIRECENSITI;
	INSERT INTO MV_FORMAGGIRECENSITI
    WITH FormaggiRecensiti AS(
		SELECT R.Formaggio,
			   (AVG(Conservazione) + AVG(Qualita) + AVG(Gusto) + AVG(Gradimento))/4 AS MediaRecensioni
		FROM Recensione R
		GROUP BY R.Formaggio
	)
	SELECT *
	FROM FormaggiRecensiti
	WHERE MediaRecensioni < 5;
END $$
/* Creo una procedura che in base ad un parametro preso in ingresso 
stamperà i formaggi più resi o peggio recensiti con le informazioni 
relative alla qualità del processo produttivo */
CREATE PROCEDURE RESOCONTO_TRACCIABILITA(IN _parametro VARCHAR(100))
BEGIN 
	IF _parametro = 'Resi' THEN
		SELECT *
        FROM MV_FORMAGGIRESI MVF
			 NATURAL JOIN MV_QUALITAPROCESSO MVQ;
    END IF;
    IF _parametro = 'Recensiti' THEN
		SELECT *
        FROM MV_FORMAGGIRECENSITI MVF
			 NATURAL JOIN MV_QUALITAPROCESSO MVQ;
    END IF;
END $$
DELIMITER ;