DROP TABLE IF EXISTS MV_VENDITE;
DROP EVENT IF EXISTS EVENT_VENDITE;
DROP PROCEDURE IF EXISTS PROCEDURE_VENDITE;
DROP PROCEDURE IF EXISTS RESOCONTO_VENDITE;
/* Creo la Materialized View */
CREATE TABLE MV_VENDITE(
	Formaggio VARCHAR(100),
    NumeroVendite INTEGER ,
    Percentuale DOUBLE,
    PRIMARY KEY(Formaggio)
);
DELIMITER $$
/* Inserisco per la prima volta i valori nella Materialized View */
TRUNCATE TABLE MV_VENDITE;
INSERT INTO MV_VENDITE
SELECT A.Formaggio,
	   SUM(A.Quantita),
       (SUM(A.Quantita)/(
				SELECT SUM(A1.Quantita)
                FROM Acquisto A1
								   ))*100
FROM Acquisto A
GROUP BY A.Formaggio;

/* Creo l'Event che aggiornerà la Materialized View */
CREATE EVENT EVENT_VENDITE
ON SCHEDULE EVERY 1 MONTH
STARTS '2030-01-29 23:27:00'
DO
BEGIN 
	CALL PROCEDURE_VENDITE();
END $$
/* Creo la Procedura per l'aggiornamento effettivo */
CREATE PROCEDURE PROCEDURE_VENDITE()
BEGIN 
	TRUNCATE TABLE MV_VENDITE;
	INSERT INTO MV_VENDITE
	SELECT A.Formaggio,
		   SUM(A.Quantita),
		   (SUM(A.Quantita)/(
				SELECT SUM(A1.Quantita)
                FROM Acquisto A1
							))*100
	FROM Acquisto A
	GROUP BY A.Formaggio;
END $$
/* Creo la procedura che stamperà a video i formaggi presenti nella materialized view 
con la loro posizione in classifica in base alla percentuale di vendite */
CREATE PROCEDURE RESOCONTO_VENDITE()
BEGIN 
	SELECT DENSE_RANK() OVER(
				ORDER BY Percentuale DESC
						    ) AS Posizione,
		   Formaggio,
           Percentuale,
           NumeroVendite
    FROM MV_VENDITE;
END $$
DELIMITER ;