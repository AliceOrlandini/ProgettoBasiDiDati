DROP PROCEDURE IF EXISTS PROCEDURE_MUNGITURA;
DROP PROCEDURE IF EXISTS PROCEDURE_PASTO;
DROP PROCEDURE IF EXISTS PROCEDURE_ORDINE;
DROP PROCEDURE IF EXISTS PROCEDURE_FARMACI;
DROP PROCEDURE IF EXISTS PROCEDURE_VETERINARIO;
DROP PROCEDURE IF EXISTS PROCEDURE_PAGAMENTO;
DROP TRIGGER IF EXISTS costo_stanza;
DROP TRIGGER IF EXISTS costo_servizi;
DROP TRIGGER IF EXISTS costo_escursioni;
DROP PROCEDURE IF EXISTS PROCEDURE_POSIZIONI_ANIMALE;
DROP PROCEDURE IF EXISTS PROCEDURE_STALLA;
DROP PROCEDURE IF EXISTS PROCEDURE_VISITA;
DELIMITER $$

/* Operazione 1 */
CREATE PROCEDURE PROCEDURE_MUNGITURA(IN _codice_animale CHAR(5),
									 IN _codice_mungitrice CHAR(5),
                                     IN _litri DOUBLE,
                                     IN _codice_silo CHAR(5),
                                     IN _sostanza1 VARCHAR(100),
                                     IN _sostanza2 VARCHAR(100),
                                     IN _sostanza3 VARCHAR(100),
                                     IN _sostanza4 VARCHAR(100),
                                     IN _sostanza5 VARCHAR(100),
                                     IN _quantita1 DOUBLE,
                                     IN _quantita2 DOUBLE,
                                     IN _quantita3 DOUBLE,
                                     IN _quantita4 DOUBLE,
                                     IN _quantita5 DOUBLE
                                     )
BEGIN 
	-- Inserisco i valori in Latte
	INSERT INTO Latte
    VALUES(_codice_animale,CURRENT_TIMESTAMP(),_litri,_codice_mungitrice,_codice_silo);
    
    -- Inserisco i valori in Composizione
    INSERT INTO Composizione
    VALUES(_codice_animale,CURRENT_TIMESTAMP(),_sostanza1,_quantita1),
		  (_codice_animale,CURRENT_TIMESTAMP(),_sostanza2,_quantita2),
          (_codice_animale,CURRENT_TIMESTAMP(),_sostanza3,_quantita3),
          (_codice_animale,CURRENT_TIMESTAMP(),_sostanza4,_quantita4),
          (_codice_animale,CURRENT_TIMESTAMP(),_sostanza5,_quantita5);
END $$

/* Operazione 2 */
CREATE PROCEDURE PROCEDURE_PASTO(IN _locale CHAR(5),
								 IN _quantita DOUBLE,
                                 IN _foraggio VARCHAR(100))
BEGIN 
	-- Inserisco i valori in Pasto
	INSERT INTO Pasto
    -- Trovo le mangiatoie in cui devo inserire i pasti
    WITH Mangiatoie AS(
		SELECT M.CodiceMangiatoia
		FROM Mangiatoia M
		WHERE M.Locale = _locale
    )
    SELECT CURRENT_TIMESTAMP(),
		   M.CodiceMangiatoia,
           _quantita,
           _foraggio
	FROM Mangiatoie M;
END $$

/* Operazione 3 */
CREATE PROCEDURE PROCEDURE_ORDINE(IN _codice_ordine CHAR(5),
								  IN _codice_cliente CHAR(5),
	                              IN _nome_formaggio VARCHAR(100),
                                  IN _quantita DOUBLE)
BEGIN 
	-- Inserisco i dati in ordine
	INSERT INTO Ordine
    VALUES(_codice_ordine,CURRENT_TIMESTAMP(),NULL,_codice_cliente);
    
    -- Inserisco i dati in acquisto 
    INSERT INTO Acquisto
    VALUES(_codice_ordine,_nome_formaggio,_quantita);
END $$

/* Operazione 4 */
CREATE PROCEDURE PROCEDURE_FARMACI(IN _codice_animale CHAR(5))
BEGIN 
	-- Seleziono i farmaci con rispettiva la posologia
    -- ed orario di somministrazione 
	SELECT S.Farmaco,S.Posologia,S.Orario
    FROM Terapia T
		 INNER JOIN Somministrazione S
         ON T.CodiceTerapia = S.Terapia
    WHERE T.Animale = _codice_animale
		  AND T.DataInizio + INTERVAL T.Durata DAY > CURRENT_DATE;
END $$

/* Operazione 5 */
CREATE PROCEDURE PROCEDURE_VETERINARIO(IN _codice_veterinario CHAR(5),
									   OUT numero_visite_ INTEGER,
                                       OUT numero_terapie_ INTEGER,
                                       OUT numero_esami_ INTEGER)
BEGIN 
	-- Trovo il numero di visite effettuate 
    -- dal veterinario negli ultimi 7 giorni
	SELECT COUNT(*) INTO numero_visite_
    FROM Visita V
    WHERE V.Veterinario = _codice_veterinario
		  AND CURRENT_DATE - INTERVAL 7 DAY < V.Data;
	
    -- Trovo il numero di terapie effettuate 
    -- dal veterinario negli ultimi 7 giorni
    SELECT COUNT(*) INTO numero_terapie_
    FROM Terapia T
		 INNER JOIN Visita V
         ON T.Visita = V.CodiceVisita
    WHERE V.Veterinario = _codice_veterinario
		  AND CURRENT_DATE - INTERVAL 7 DAY < V.Data;
	
    -- Trovo il numero di esami effettuate 
    -- dal veterinario negli ultimi 7 giorni
	SELECT COUNT(*) INTO numero_esami_
    FROM Esame E
		 INNER JOIN Visita V
         ON E.Visita = V.CodiceVisita
    WHERE V.Veterinario = _codice_veterinario
		  AND CURRENT_DATE - INTERVAL 7 DAY < V.Data;
END $$

/* Operazione 6 */
CREATE PROCEDURE PROCEDURE_PAGAMENTO(IN _codice_cliente CHAR(5))
BEGIN 
	SELECT P.Costo
    FROM Pagamento P
    WHERE P.Cliente = _codice_cliente
	ORDER BY P.Time_Stamp DESC
    LIMIT 1;
END $$

/* Aggiornamento della ridondanza quando viene prenotata una stanza */
CREATE TRIGGER costo_stanza
AFTER INSERT ON PrenotazioneStanza
FOR EACH ROW
BEGIN 
	DECLARE costo_stanza INTEGER DEFAULT 0;
    DECLARE giorni INTEGER DEFAULT 0;
    DECLARE ultimo_pagamento TIMESTAMP DEFAULT NULL;
    DECLARE cliente CHAR(5) DEFAULT '';
    
    -- Trovo quanto costa la stanza prenotata
    SELECT S.Costo INTO costo_stanza
    FROM Stanza S
    WHERE S.Numero = NEW.Stanza
		  AND S.Agriturismo = NEW.Agriturismo;
	
    -- Trovo quanti giorni sono stati prenotati
    SELECT DATEDIFF(P.DataPartenza,P.DataArrivo) INTO giorni
    FROM Prenotazione P
    WHERE P.Codice = NEW.Prenotazione;
	
    -- Trovo l'ultimo pagamento per quel cliente
    SELECT P.Time_Stamp,P.Cliente INTO ultimo_pagamento,cliente
    FROM Pagamento P
    WHERE P.Cliente = (
			SELECT P1.Cliente
            FROM Prenotazione P1
			WHERE P1.Codice = NEW.Prenotazione
					  );
    
    -- Aggiorno il costo 
    UPDATE Pagamento P
    SET P.Costo = P.Costo + (costo_stanza * giorni)
    WHERE P.Cliente = cliente
		  AND P.Time_Stamp = ultimo_pagamento;
END $$

/* Aggiornamento della ridondanza quando viene prenotato un servizio */
CREATE TRIGGER costo_servizi
AFTER INSERT ON PrenotazioneServizi
FOR EACH ROW
BEGIN 
	DECLARE costo_servizio INTEGER DEFAULT 0;
    DECLARE ultimo_pagamento TIMESTAMP DEFAULT NULL;
    DECLARE cliente CHAR(5) DEFAULT '';
    
    -- Trovo quanto costa il servizio prenotato
    SELECT S.Costo INTO costo_servizio
    FROM Servizio S
    WHERE S.NomeServizio = NEW.Servizio;
    
    -- Trovo l'ultimo pagamento per quel cliente
    SELECT P.Time_Stamp,P.Cliente INTO ultimo_pagamento,cliente
    FROM Pagamento P
    WHERE P.Cliente = (
			SELECT P1.Cliente
            FROM Prenotazione P1
			WHERE P1.Codice = NEW.Prenotazione
					  );
	
    -- Aggiorno il costo 
    UPDATE Pagamento P
    SET P.Costo = P.Costo + (costo_servizio * NEW.Giorni)
    WHERE P.Cliente = cliente
		  AND P.Time_Stamp = ultimo_pagamento;
END $$

/* Aggiornamento della ridondanza quando viene prenotata un'escursione */
CREATE TRIGGER costo_escursioni
AFTER INSERT ON PrenotazioneEscursione
FOR EACH ROW
BEGIN 
	DECLARE costo_escursione INTEGER DEFAULT 0;
    DECLARE ultimo_pagamento TIMESTAMP DEFAULT NULL;
    DECLARE cliente CHAR(5) DEFAULT '';
    
    -- Trovo quanto costa l'escursione prenotata
    SELECT E.Costo INTO costo_escursione
    FROM Escursione E
    WHERE E.Codice = NEW.Escursione;
    
    -- Trovo l'ultimo pagamento per quel cliente
    SELECT P.Time_Stamp,P.Cliente INTO ultimo_pagamento,cliente
    FROM Pagamento P
    WHERE P.Cliente = (
			SELECT P1.Cliente
            FROM Prenotazione P1
			WHERE P1.Codice = NEW.Prenotazione
					  );
	
    -- Aggiorno il costo 
    UPDATE Pagamento P
    SET P.Costo = P.Costo + costo_escursione
    WHERE P.Cliente = cliente
		  AND P.Time_Stamp = ultimo_pagamento;
END $$

/* Operazione 7 */
CREATE PROCEDURE PROCEDURE_POSIZIONI_ANIMALE(IN _codice_animale CHAR(5))
BEGIN 
	-- Trovo le posizioni dell'animale
	SELECT G.Time_Stamp,G.Latitudine,G.Longitudine
    FROM GPS G
    WHERE G.Animale = _codice_animale
		  AND G.Time_Stamp > CURRENT_DATE - INTERVAL 5 DAY;
END $$

/* Operazione 8 */
CREATE PROCEDURE PROCEDURE_STALLA(IN _codice_stalla CHAR(100))
BEGIN 
	-- Trovo i locali di cui si vuole conoscere le informazioni
	WITH LocaliTarget AS(
		SELECT L.CodiceLocale AS Locale
        FROM Locale L
		WHERE L.Stalla = _codice_stalla
    )
    -- Trovo le informazioni sul contenuto delle mangiatoie e degli abbeveratoi di tali locali
    SELECT LT.Locale,SA.QuantitaAcqua,SA.SaliMinerali,SA.Vitamine,
		   SM.QuantitaForaggio,F.TipoForaggio,F.Piante,F.Cereali,
           F.Frutta,F.Fibre,F.Proteine,F.Glucidi,F.kcal,F.TipoConservazione
    FROM Abbeveratoio A
		 NATURAL JOIN LocaliTarget LT
		 INNER JOIN SensoreAbbeveratoio SA
         ON A.CodiceAbbeveratoio = SA.Abbeveratoio
         NATURAL JOIN Mangiatoia M
		 INNER JOIN SensoreMangiatoia SM
         ON M.CodiceMangiatoia = SM.Mangiatoia
         INNER JOIN Foraggio F
         ON F.TipoForaggio = SM.Foraggio;
END $$

/* Operazione 9 */
CREATE PROCEDURE PROCEDURE_VISITA(IN _codice_animale CHAR(5),
								  IN _codice_visita CHAR(5),
								  IN _esito TINYINT,
								  IN _massa_magra DOUBLE,
                                  IN _massa_grassa DOUBLE,
                                  IN _tipo_visita VARCHAR(100),
                                  IN _codice_soggettivo CHAR(5),
                                  IN _codice_oggettivo CHAR(5),
                                  IN _codice_veterinario CHAR(5),
                                  IN _nome_patologia VARCHAR(100),
                                  IN _vigilanza TEXT,
                                  IN _pelo TEXT,
                                  IN _respirazione TEXT,
                                  IN _idratazione TEXT,
                                  IN _deambulazione TEXT,
                                  IN _oculo TEXT,
                                  IN _emocromo TEXT,
                                  IN _cuore TEXT,
                                  IN _fegato TEXT,
                                  IN _pancreas TEXT,
                                  IN _zoccolo TEXT)
BEGIN 
	-- Inserisco in Visita
	INSERT INTO Visita 
    VALUES(_codice_visita,_esito,CURRENT_DATE,_massa_magra,_massa_grassa,_tipo_visita,NULL,
		   _codice_animale,_codice_veterinario);

	-- Inserisco in Soggettivo 
    INSERT INTO IndicatoreSoggettivo 
    VALUES(_codice_soggettivo,_respirazione,_idratazione,_vigilanza,_pelo,_codice_visita);

    -- Inserisco in Oggettivo
    INSERT INTO IndicatoreOggettivo
    VALUES(_codice_oggettivo,_cuore,_oculo,_fegato,_pancreas,_zoccolo,_emocromo,_codice_visita);

    -- Inserisco in RilevamentoPatologia
    INSERT INTO RilevamentoPatologia 
    VALUES(_codice_visita,_nome_patologia);
END $$
DELIMITER ;