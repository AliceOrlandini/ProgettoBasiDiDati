DROP TRIGGER IF EXISTS tigger_unica_specie_insert;
DROP TRIGGER IF EXISTS tigger_unica_specie_update;
DROP TRIGGER IF EXISTS trigger_numero_massimo_locale_insert;
DROP TRIGGER IF EXISTS trigger_numero_massimo_locale_update;
DROP TRIGGER IF EXISTS trigger_livello_sporcizia;
DROP TRIGGER IF EXISTS trigger_produzione_formaggio;
DROP PROCEDURE IF EXISTS animali_riproduzione;
DROP TRIGGER IF EXISTS trigger_composizione_latte_insert;
DROP TRIGGER IF EXISTS trigger_composizione_latte_update;
DROP TRIGGER IF EXISTS trigger_prenotazione;
DROP TRIGGER IF EXISTS trigger_letto_insert;
DROP TRIGGER IF EXISTS trigger_letto_update;
DROP TRIGGER IF EXISTS trigger_prenotazione_servizi;
DROP TRIGGER IF EXISTS trigger_ordine;
DROP TRIGGER IF EXISTS trigger_reso;
DROP TRIGGER IF EXISTS trigger_acquisto;
DELIMITER $$
/* RV1 INSERT */
CREATE TRIGGER tigger_unica_specie_insert
BEFORE INSERT ON Animale
FOR EACH ROW
BEGIN
	DECLARE specie VARCHAR(100) DEFAULT NULL;
    DECLARE specie_animale VARCHAR(100) DEFAULT NULL;
    
    -- Trovo la specie all'interno del locale
	SELECT DISTINCT S.NomeSpecie INTO specie
    FROM Animale A
         INNER JOIN Specie S
         ON A.Razza = S.Razza
	WHERE A.Locale = NEW.Locale;
    
	-- Trovo la specie del mio animale 
    SELECT S.NomeSpecie INTO specie_animale
    FROM Specie S
    WHERE S.Razza = NEW.Razza;
    
    -- Controllo che la specie sia conforme
	IF specie <> specie_animale THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La specie non è conforme';
	END IF;
END $$

/* RV1 UPDATE */
CREATE TRIGGER tigger_unica_specie_update
BEFORE UPDATE ON Animale
FOR EACH ROW
BEGIN
	DECLARE specie VARCHAR(100) DEFAULT NULL;
    DECLARE specie_animale VARCHAR(100) DEFAULT NULL;
    
    -- Trovo la specie all'interno del locale
	SELECT DISTINCT S.NomeSpecie INTO specie
    FROM Animale A
         INNER JOIN Specie S
         ON A.Razza = S.Razza
	WHERE L.CodiceLocale = NEW.Locale;
    
	-- Trovo la specie del mio animale 
    SELECT S.NomeSpecie INTO specie_animale
    FROM Specie S
    WHERE S.Razza = NEW.Razza;
    
    -- Controllo che la specie sia conforme
	IF specie <> specie_animale THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La specie non è conforme';
	END IF;
END $$

/* RV2 INSERT */
CREATE TRIGGER trigger_numero_massimo_locale_insert
BEFORE INSERT ON Animale
FOR EACH ROW
BEGIN 
	DECLARE dimensioni DOUBLE DEFAULT 0;
    DECLARE densita DOUBLE DEFAULT 0;
    DECLARE numero_animali INTEGER DEFAULT 0;
    
    -- Trovo le dimensioni del locale
	SELECT (L.Lunghezza*L.Larghezza) INTO dimensioni
    FROM Locale L
    WHERE L.CodiceLocale = NEW.Locale;
	
    -- Trovo la densita della specie del mio animale
	SELECT DISTINCT S.Densita INTO densita
    FROM Specie S
    WHERE S.Razza = NEW.Razza;
    
    -- Trovo il numero di animali attualmente contenuti nel locale
    SELECT COUNT(*) INTO numero_animali
    FROM Animale A
    WHERE A.Locale = NEW.Locale;
    
    -- Controllo se il locale ha raggiunto il numero massimo di animali che può contenere
    IF dimensioni * densita = numero_animali THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il locale ha raggiunto il numero massimo di animali';
	END IF;
END $$

/* RV2 UPDATE */
CREATE TRIGGER trigger_numero_massimo_locale_update
BEFORE UPDATE ON Animale
FOR EACH ROW
BEGIN 
	DECLARE dimensioni DOUBLE DEFAULT 0;
    DECLARE densita DOUBLE DEFAULT 0;
    DECLARE numero_animali INTEGER DEFAULT 0;
    
    -- Trovo le dimensioni del locale
	SELECT (L.Lunghezza*L.Larghezza) INTO dimensioni
    FROM Locale L
    WHERE L.CodiceLocale = NEW.Locale;
    
	-- Trovo la densita della specie del mio animale
	SELECT DISTINCT S.Densita INTO densita
    FROM Specie S
    WHERE S.Razza = NEW.Razza;
    
   -- Trovo il numero di animali attualmente contenuti nel locale
    SELECT COUNT(*) INTO numero_animali
    FROM Animale A
    WHERE A.Locale = NEW.Locale;
    
    -- Controllo se il locale ha raggiunto il numero massimo di animali che può contenere
    IF dimensioni * densita = numero_animali THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il locale ha raggiunto il numero massimo di animali';
	END IF;
END $$

/* RV4 */
CREATE TRIGGER trigger_livello_sporcizia
BEFORE INSERT ON Igiene
FOR EACH ROW
BEGIN 
	-- Se il livello di sporcizia supera il 75% imposto
    -- l'attributo Richiesta a 'si'
	IF NEW.LivelloSporcizia > 75 THEN
		SET NEW.Richiesta = 'si';
    END IF;
END $$

/* STORE PROCEDURE */
CREATE PROCEDURE animali_riproduzione()
BEGIN 
	-- Seleziono gli animali che hanno fatto meno di 3 terapie
    -- e che quindi sono i più sani per una riproduzione
	SELECT A.CodiceAnimale
    FROM Animale A
    WHERE A.CodiceAnimale NOT IN(
			SELECT T2.Animale
            FROM Terapia T2
            GROUP BY T2.Animale
			HAVING COUNT(*) > 2
						  );
END $$

/* RV5 INSERT */
CREATE TRIGGER trigger_composizione_latte_insert
AFTER INSERT ON Composizione
FOR EACH ROW
BEGIN 
	DECLARE quantita_silos DOUBLE DEFAULT 0;
    
    -- Trovo la quantita della sostanza nel silos
	SELECT C.Quantita INTO quantita_silos
    FROM Contenimento C
    WHERE C.Sostanza = NEW.Sostanza
		  AND C.Silos = (
				SELECT L.Silos
                FROM Latte L
                WHERE L.Time_Stamp = NEW.Time_Stamp
					  AND L.Animale = NEW.Animale
							  );
                              
	-- Se la quantità della sostanza del latte non è simile a quella della 
    -- sostanza presente nel silo imposto il silo del latte a NULL e
    -- stampo un messaggio di avvertimento
    IF NEW.Quantita > 1.20*quantita_silos OR NEW.Quantita < 0.80*quantita_silos THEN
		UPDATE Latte 
        SET Silos = NULL 
        WHERE Time_Stamp = NEW.Time_Stamp 
			  AND Animale = NEW.Animale;
		SIGNAL SQLSTATE '01000' -- Signal di Warning
		SET MESSAGE_TEXT =  'Composizione chimico-fisica del latte non simile a quella del silo scelto';
    END IF;
END $$

/* RV5 UPDATE */
CREATE TRIGGER trigger_composizione_latte_update
BEFORE UPDATE ON Latte 
FOR EACH ROW
BEGIN
	DECLARE finito INTEGER DEFAULT 0;
    DECLARE sostanza_cur VARCHAR(100) DEFAULT '';
    DECLARE quantita_cur DOUBLE DEFAULT 0;
    DECLARE quantita_silos DOUBLE DEFAULT 0;
    
    -- Creo un cursore contenente tutte le sostanze del latte
    -- con la relativa quantita
    DECLARE cursore_composizione CURSOR FOR
		SELECT C.Sostanza,C.Quantita 
        FROM Composizione C
        WHERE C.Time_Stamp = NEW.Time_Stamp
			  AND C.Animale = NEW.Animale;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito = 1;
    
    OPEN cursore_composizione;
    scan: LOOP
		FETCH cursore_composizione INTO sostanza_cur,quantita_cur;
        
        IF finito = 1 THEN
			LEAVE scan;
		END IF;
        
        -- Trovo la quantita della sostanza del silos 
        -- in cui si vuole inserire il latte
        SELECT C.Quantita INTO quantita_silos
		FROM Contenimento C
		WHERE C.Sostanza = sostanza_cur
			  AND C.Silos = NEW.Silos;
		
        -- Se la quantità della sostanza del latte non è simile
		-- a quella della sostanza presente nel silo blocco l'update
        IF quantita > 1.20*quantita_silos OR quantita < 0.80*quantita_silos THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Composizione chimico-fisica del latte non simile a quella del silo scelto';
		END IF;
    END LOOP scan;
    CLOSE cursore_composizione;
END $$

/* RV6 */
CREATE TRIGGER trigger_produzione_formaggio
BEFORE INSERT ON Produzione 
FOR EACH ROW
BEGIN 
	-- Dichiaro le variabili del cursore
    DECLARE sostanza_cur VARCHAR(100) DEFAULT '';
    DECLARE quantita_cur DOUBLE DEFAULT NULL;
    DECLARE finito INTEGER DEFAULT 0;
    
    DECLARE controllo_quantita DOUBLE DEFAULT NULL;
    
    -- Dichiaro il cursore che conterrà le sostanze
    -- di ogni silo con cui è prodotto l'unità
	DECLARE cursore_sostanze CURSOR FOR
    SELECT C.Sostanza,C.Quantita
    FROM Produzione P
         NATURAL JOIN Contenimento C
	WHERE P.Unita = NEW.Unita;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito = 1;
	
	-- Controllo se il silo è il secondo ad essere inserito 
    -- per la produzione di quella unità
    IF EXISTS(
		SELECT *
        FROM Produzione P
        WHERE P.Unita = NEW.Unita
			 )
	THEN 
		-- Inserisco in una temporary table le 
		-- sostanze del mio silo
        DROP TEMPORARY TABLE IF EXISTS sostanze;
        CREATE TEMPORARY TABLE sostanze(
			Sostanza VARCHAR(100),
            Quantita DOUBLE,
            PRIMARY KEY(Sostanza)
        );
        INSERT INTO sostanze
        SELECT C.Sostanza,C.Quantita
        FROM Contenimento C
        WHERE C.Silos = NEW.Silos;
        
        -- Confronto tutte le sostanze 
        OPEN cursore_sostanze;
        scan: LOOP 
			FETCH cursore_sostanze INTO sostanza_cur,quantita_cur;
			IF finito = 1 THEN 
				LEAVE scan;
			END IF;
            
            -- Estaggo dalla temporary table la quantità della
            -- sostanza del cursore
            SELECT S.Quantita INTO controllo_quantita
            FROM sostanze S
            WHERE S.Sostanza = sostanza_cur;
            
            -- Se la quantità è diversa impedisco l'inserimento
            IF controllo_quantita <> quantita_cur THEN 
				SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Silo non compatibile';
			END IF;
        END LOOP scan;
        CLOSE cursore_sostanze;
    END IF;
END $$

/* RV7 */
CREATE TRIGGER trigger_prenotazione
BEFORE INSERT ON Prenotazione 
FOR EACH ROW
BEGIN 
	DECLARE tipo_utente VARCHAR(100) DEFAULT '';
    DECLARE carta INTEGER DEFAULT 0;
	-- Trovo se il cliente è registrato o no
    SELECT C.TipoUtente,CodiceCartaPayPal INTO tipo_utente,carta
    FROM Cliente C
    WHERE C.CodiceCliente = NEW.Cliente;
    
	IF tipo_utente = 'NonRegistrato' AND carta IS NULL THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il cliente non può prenotare se non inserisce una carta di credito o paypal';
	END IF;
	SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = 'Prenotazione avvenuta con successo, pagare il 50% del costo del soggiorno';
END $$

/* RV8 INSERT */
CREATE TRIGGER trigger_letto_insert
BEFORE INSERT ON Letto
FOR EACH ROW
BEGIN 
	DECLARE tipo_stanza VARCHAR(100) DEFAULT '';
    DECLARE numero_letti INTEGER DEFAULT 0;
    
	-- Trovo il tipo della stanza in cui sto inserendo il letto 
    SELECT S.TipoStanza INTO tipo_stanza
    FROM Stanza S
    WHERE S.Numero = NEW.Stanza
		  AND S.Agriturismo = NEW.Agriturismo;
    
    -- Contro il numero di letti presenti il tale stanza
    SELECT COUNT(*) INTO numero_letti
    FROM Letto L
    WHERE L.Stanza = NEW.Stanza
		  AND L.Agriturismo = NEW.Agriturismo;
	
    -- Controllo se nella stanza c'è già un letto
	IF tipo_stanza = 'Semplice' AND numero_letti = 1 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire letto, numero massimo raggiunto';
	END IF;
END $$

/* RV8 UPDATE */
CREATE TRIGGER trigger_letto_update
BEFORE UPDATE ON Letto
FOR EACH ROW
BEGIN 
	DECLARE tipo_stanza VARCHAR(100) DEFAULT '';
    DECLARE numero_letti INTEGER DEFAULT 0;
    
	-- Trovo il tipo della stanza in cui sto inserendo il letto 
    SELECT S.TipoStanza INTO tipo_stanza
    FROM Stanza S
    WHERE S.Numero = NEW.Stanza
		  AND S.Agriturismo = NEW.Agriturismo;
    
    -- Contro il numero di letti presenti il tale stanza
    SELECT COUNT(*) INTO numero_letti
    FROM Letto L
    WHERE L.Stanza = NEW.Stanza
		  AND L.Agriturismo = NEW.Agriturismo;
	
    -- Controllo se nella stanza c'è già un letto
	IF tipo_stanza = 'Semplice' AND numero_letti = 1 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire letto, numero massimo raggiunto';
	END IF;
END $$

/* RV9 */
CREATE TRIGGER trigger_prenotazione_servizi
BEFORE INSERT ON PrenotazioneServizi
FOR EACH ROW
BEGIN 
	DECLARE tipo_cliente VARCHAR(100) DEFAULT '';
    
	-- Trovo se il cliente che sta prenotando il servizio è registrato o no
    SELECT C.TipoUtente INTO tipo_cliente
    FROM Cliente C
    WHERE C.CodiceCliente = (
				SELECT P.Cliente
                FROM Prenotazione P
                WHERE P.Codice = NEW.Prenotazione
							);
	
    IF tipo_cliente = 'NonRegistrato' THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il cliente non può prenotare servizi in quanto non registrato';
	END IF;
END $$

/* RV10 */
CREATE TRIGGER trigger_ordine
BEFORE UPDATE ON Ordine
FOR EACH ROW
BEGIN 
	-- Controllo che l'ordine venga rispettato
    IF OLD.Stato IS NOT NULL THEN 
		IF (OLD.Stato = 'in processazione' OR OLD.Stato = 'pendente') AND NEW.Stato <> 'in preparazione' THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Ordine non rispettato';
		END IF;
		IF OLD.Stato = 'in preparazione' AND NEW.Stato <> 'spedito' THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Ordine non rispettato';
		END IF;
		IF OLD.Stato = 'spedito' AND NEW.Stato <> 'evaso' THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Ordine non rispettato';
		END IF;
    END IF;
END $$

/* RV11 */
CREATE TRIGGER trigger_reso 
BEFORE INSERT ON Reso 
FOR EACH ROW
BEGIN 
	DECLARE data_consegna DATE DEFAULT NULL;
    
	-- Trovo quando è arrivato l'ordine oggetto del reso
    SELECT S.DataConsegna INTO data_consegna
    FROM Spedizione S
    WHERE S.Ordine = NEW.Ordine;
    
    IF  CURRENT_DATE - INTERVAL 2 DAY > data_consegna THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile rendere i prodotti, passate più di 48 ore';
	END IF;
END $$

/* RV12 */
CREATE TRIGGER trigger_acquisto
BEFORE INSERT ON Acquisto
FOR EACH ROW
BEGIN 
    DECLARE trovato integer default 0;
    DECLARE quantita_ integer default 0;
    DECLARE numero_ integer default 0;
        
	SELECT COUNT(*) INTO numero_
    FROM Unita U
    WHERE U.Formaggio = NEW.Formaggio;
        
	IF(numero_ < NEW.Quantita) THEN
		UPDATE Ordine
        SET Stato = 'pendente'
        WHERE CodiceOrdine = NEW.Ordine;
    ELSE
    
		SET quantita_= NEW.Quantita;
		WITH FormaggiDaEliminare AS (
			SELECT U.Codice
			FROM Unita U
				 INNER JOIN Lotto L 
                 ON U.Lotto = L.CodiceLotto
			WHERE U.Formaggio = NEW.Formaggio
			ORDER BY L.Scadenza
			LIMIT quantita_
        )
        DELETE U.*
        FROM Unita U
		NATURAL JOIN FormaggiDaEliminare;
        
        UPDATE Ordine
        SET Stato = 'in processazione'
        WHERE CodiceOrdine = NEW.Ordine;
	END IF;
END $$
DELIMITER ;