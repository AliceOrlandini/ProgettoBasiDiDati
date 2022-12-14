/* AREA ALLEVAMENTO */
CREATE TABLE IF NOT EXISTS FORNITORE(
	PartitaIVA CHAR(5),
    Nome VARCHAR(100),
    RagioneSociale VARCHAR(100),
    Indirizzo VARCHAR(100),
    PRIMARY KEY(PartitaIVA)
);

CREATE TABLE IF NOT EXISTS SPECIE(
	Razza VARCHAR(100),
    NomeSpecie VARCHAR(100),
    Famiglia VARCHAR(100),
    Densita DOUBLE,
    PRIMARY KEY(Razza)
);

CREATE TABLE IF NOT EXISTS AGRITURISMO(
	NomeAgriturismo VARCHAR(100),
	PRIMARY KEY(NomeAgriturismo)
);

CREATE TABLE IF NOT EXISTS STALLA(
	CodiceStalla CHAR(5),
    Agriturismo VARCHAR(100),
	PRIMARY KEY(CodiceStalla),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LOCALE(
	CodiceLocale CHAR(5),
    Lunghezza DOUBLE,
    Larghezza DOUBLE,
    Altezza DOUBLE,
    Finestra CHAR(1) CHECK(Finestra IN('N','S','E','O')),
    Pavimento VARCHAR(100),
    Latitudine INTEGER,
    Longitudine INTEGER,
    Stalla CHAR(5),
	PRIMARY KEY(CodiceLocale),
    FOREIGN KEY(Stalla) REFERENCES STALLA(CodiceStalla)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ANIMALE(
	CodiceAnimale CHAR(5),
    DataNascita DATE,
    Sesso CHAR(1) CHECK(Sesso IN('F','M')),
    Altezza DOUBLE,
    Peso DOUBLE,
    DataAcquisto DATE,
    DataArrivo DATE,
    Fornitore CHAR(5),
    Razza VARCHAR(100),
    Madre CHAR(5),
    Padre CHAR(5),
    Locale CHAR(5),
    PRIMARY KEY(CodiceAnimale),
    FOREIGN KEY(Fornitore) REFERENCES FORNITORE(PartitaIVA) 
		ON UPDATE CASCADE 
		ON DELETE SET NULL,
    FOREIGN KEY(Razza) REFERENCES SPECIE(Razza) 
		ON UPDATE CASCADE 
		ON DELETE SET NULL,
	FOREIGN KEY(Madre) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	FOREIGN KEY(Padre) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
	FOREIGN KEY(Locale) REFERENCES LOCALE(CodiceLocale)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS GPS(
	Time_Stamp TIMESTAMP,
    Animale CHAR(5),
    Latitudine INTEGER,
    Longitudine INTEGER,
    PRIMARY KEY(Time_Stamp,Animale),
    FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IGIENE(
    Locale CHAR(5),
    Time_Stamp TIMESTAMP,
    LivelloSporcizia INTEGER CHECK(LivelloSporcizia BETWEEN 0 AND 100),
    Richiesta CHAR(2) DEFAULT 'no',
    Metano INTEGER,
    Azoto INTEGER,
    Umidita INTEGER,
    Temperatura DOUBLE,
	PRIMARY KEY(Locale,Time_Stamp),
    FOREIGN KEY(Locale) REFERENCES LOCALE(CodiceLocale)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ABBEVERATOIO(
	CodiceAbbeveratoio CHAR(5),
    TipoAbbeveratoio VARCHAR(100),
    Locale CHAR(5),
	PRIMARY KEY(CodiceAbbeveratoio),
    FOREIGN KEY(Locale) REFERENCES LOCALE(CodiceLocale)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SENSOREABBEVERATOIO(
	Time_Stamp TIMESTAMP,
    Abbeveratoio CHAR(5),
    QuantitaAcqua DOUBLE,
    SaliMinerali INTEGER,
    Vitamine INTEGER,
	PRIMARY KEY(Time_Stamp,Abbeveratoio),
    FOREIGN KEY(Abbeveratoio) REFERENCES ABBEVERATOIO(CodiceAbbeveratoio)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MANGIATOIA(
	CodiceMangiatoia CHAR(5),
    TipoMangiatoia VARCHAR(100),
    Locale CHAR(5),
	PRIMARY KEY(CodiceMangiatoia),
    FOREIGN KEY(Locale) REFERENCES LOCALE(CodiceLocale)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FORAGGIO(
	TipoForaggio VARCHAR(100),
    Piante INTEGER CHECK(Piante BETWEEN 0 AND 100),
    Cereali INTEGER CHECK(Cereali BETWEEN 0 AND 100),
    Frutta INTEGER CHECK(Frutta BETWEEN 0 AND 100),
    Fibre INTEGER CHECK(Fibre BETWEEN 0 AND 100),
    Proteine INTEGER CHECK(Proteine BETWEEN 0 AND 100),
    Glucidi INTEGER CHECK(Glucidi BETWEEN 0 AND 100),
    kcal DOUBLE,
    TipoConservazione VARCHAR(100) CHECK(TipoConservazione IN('Fresco','Conservato')),
	PRIMARY KEY(TipoForaggio)
);

CREATE TABLE IF NOT EXISTS SENSOREMANGIATOIA(
	Time_Stamp TIMESTAMP,
    Mangiatoia CHAR(5),
    QuantitaForaggio DOUBLE,
    Foraggio VARCHAR(100),
	PRIMARY KEY(Time_Stamp,Mangiatoia),
    FOREIGN KEY(Mangiatoia) REFERENCES MANGIATOIA(CodiceMangiatoia)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Foraggio) REFERENCES FORAGGIO(TipoForaggio)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PASTO(
	Time_Stamp TIMESTAMP,
    Mangiatoia CHAR(5),
    Quantita DOUBLE,
    Foraggio VARCHAR(100),
	PRIMARY KEY(Time_Stamp,Mangiatoia),
    FOREIGN KEY(Mangiatoia) REFERENCES MANGIATOIA(CodiceMangiatoia)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Foraggio) REFERENCES FORAGGIO(TipoForaggio)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS RECINZIONE(
	CodiceRecinzione CHAR(5),
    Latitudine INTEGER,
    Longitudine INTEGER,
    Lunghezza INTEGER,
	PRIMARY KEY(CodiceRecinzione)
);

CREATE TABLE IF NOT EXISTS PASCOLO(
	Codice CHAR(5),
    OraInizio TIME,
    OraFine TIME,
    Locale CHAR(5),
    Recinzione CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Locale) REFERENCES LOCALE(CodiceLocale)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Recinzione) REFERENCES RECINZIONE(CodiceRecinzione)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ZONA(
	CodiceZona CHAR(5),
    Nome VARCHAR(100),
    Latitudine INTEGER,
    Longitudine INTEGER,
    Lunghezza INTEGER,
    Agriturismo VARCHAR(100),
	PRIMARY KEY(CodiceZona),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS VETERINARIO(
	Codice CHAR(5),
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
	PRIMARY KEY(Codice)
);

CREATE TABLE IF NOT EXISTS RIPRODUZIONE(
	CodiceRiproduzione CHAR(5),
    Stato VARCHAR(100) CHECK(Stato IN('Successo','Insuccesso')),
    Time_Stamp TIMESTAMP,
    Veterinario CHAR(5),
    Maschio CHAR(5),
    Femmina CHAR(5),
	PRIMARY KEY(CodiceRiproduzione),
    FOREIGN KEY(Veterinario) REFERENCES VETERINARIO(Codice)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
    FOREIGN KEY(Maschio) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
    FOREIGN KEY(Femmina) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS GRAVIDANZA(
	CodiceGravidanza CHAR(5),
    Riproduzione CHAR(5),
    Esito TINYINT,
    Complicanza TINYINT,
    DataControllo DATE,
    Veterinario CHAR(5),
	PRIMARY KEY(CodiceGravidanza),
    FOREIGN KEY(Riproduzione) REFERENCES RIPRODUZIONE(CodiceRiproduzione)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
    FOREIGN KEY(Veterinario) REFERENCES VETERINARIO(Codice)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

/* AREA HEALTCARE */

CREATE TABLE IF NOT EXISTS PATOLOGIA(
	Nome VARCHAR(100),
	PRIMARY KEY(Nome)
);

CREATE TABLE IF NOT EXISTS VISITA(
	CodiceVisita CHAR(5),
    Esito TINYINT,
    Data DATE,
    MassaMagra DOUBLE,
    MassaGrassa DOUBLE,
    TipoVisita VARCHAR(100),
    Gravidanza CHAR(5),
    Animale CHAR(5),
    Veterinario CHAR(5),
	PRIMARY KEY(CodiceVisita),
    FOREIGN KEY(Gravidanza) REFERENCES GRAVIDANZA(CodiceGravidanza)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
	FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
	FOREIGN KEY(Veterinario) REFERENCES VETERINARIO(Codice)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS INDICATORESOGGETTIVO(
	Codice CHAR(5),
    Respirazione TEXT,
    Idratazione TEXT,
    Deambulazione TEXT,
    Vigilanza TEXT,
    Pelo INTEGER,
    Visita CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Visita) REFERENCES VISITA(CodiceVisita)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS INDICATOREOGGETTIVO(
	Codice CHAR(5),
    Cuore TEXT,
    Oculo TEXT,
    Fegato TEXT,
    Pancreas TEXT,
    Zoccolo TEXT,
    Emocromo TEXT,
    Visita CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Visita) REFERENCES VISITA(CodiceVisita)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RILEVAMENTOPATOLOGIA(
	Visita CHAR(5),
    Patologia VARCHAR(100),
	PRIMARY KEY(Visita,Patologia),
    FOREIGN KEY(Visita) REFERENCES VISITA(CodiceVisita)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Patologia) REFERENCES PATOLOGIA(Nome)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DISTURBO(
	NomeDisturbo VARCHAR(100),
	PRIMARY KEY(NomeDisturbo)
);

CREATE TABLE IF NOT EXISTS ACCERTAMENTO(
	Soggettivo CHAR(5),
    Disturbo VARCHAR(100),
    Entita INTEGER,
	PRIMARY KEY(Soggettivo,Disturbo),
    FOREIGN KEY(Soggettivo) REFERENCES INDICATORESOGGETTIVO(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Disturbo) REFERENCES DISTURBO(NomeDisturbo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LESIONE(
	Codice CHAR(5),
    Tipologia VARCHAR(100),
    ParteCorpo VARCHAR(100),
	PRIMARY KEY(Codice)
);

CREATE TABLE IF NOT EXISTS VERIFICA(
    Soggettivo CHAR(5),
    Lesione CHAR(5),
    Entita INTEGER,
	PRIMARY KEY(Soggettivo,Lesione),
    FOREIGN KEY(Soggettivo) REFERENCES INDICATORESOGGETTIVO(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Lesione) REFERENCES LESIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ESAME(
	CodiceEsame CHAR(5),
    Nome VARCHAR(100),
    Macchinario VARCHAR(100),
    Procedura TEXT,
    Data DATE,
    Visita Char(5),
	PRIMARY KEY(CodiceEsame),
    FOREIGN KEY(Visita) REFERENCES VISITA(CodiceVisita)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS TERAPIA(
	CodiceTerapia CHAR(5),
    DataInizio DATE,
    Durata INTEGER,
    Animale CHAR(5),
    Visita CHAR(5),
	PRIMARY KEY(CodiceTerapia),
    FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY(Visita) REFERENCES VISITA(CodiceVisita)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FARMACO(
	Nome VARCHAR(100),
	PRIMARY KEY(Nome)
);

CREATE TABLE IF NOT EXISTS SOMMINISTRAZIONE(
    Terapia CHAR(5),
    Farmaco VARCHAR(100),
    Orario INTEGER,
    Posologia INTEGER,
	PRIMARY KEY(Terapia,Farmaco),
    FOREIGN KEY(Terapia) REFERENCES TERAPIA(CodiceTerapia)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Farmaco) REFERENCES FARMACO(Nome)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS QUARANTENA(
    Animale CHAR(5),
    DataInizio DATE,
    DataFine DATE,
	PRIMARY KEY(Animale,DataInizio),
    FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

/* AREA PRODUZIONE */
CREATE TABLE IF NOT EXISTS SILOS(
	CodiceSilos CHAR(5),
    Livello INTEGER CHECK(Livello BETWEEN 0 AND 100),
    Capacita INTEGER,
	PRIMARY KEY(CodiceSilos)
);

CREATE TABLE IF NOT EXISTS LATTE(
	Animale CHAR(5),
    Time_Stamp TIMESTAMP,
    Litri DOUBLE,
    Mungitrice CHAR(5),
    Silos CHAR(5),
	PRIMARY KEY(Animale,Time_Stamp),
    FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Silos) REFERENCES SILOS(CodiceSilos)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS MUNGITRICE(
	CodiceMungitrice CHAR(5),
    Modello VARCHAR(100),
    Marca VARCHAR(100),
    Latitudine INTEGER,
    Longitudine INTEGER,
	PRIMARY KEY(CodiceMungitrice)
);

CREATE TABLE IF NOT EXISTS SOSTANZA(
	Nome VARCHAR(100),
	PRIMARY KEY(Nome)
);

CREATE TABLE IF NOT EXISTS COMPOSIZIONE(
    Animale CHAR(5),
    Time_Stamp TIMESTAMP,
    Sostanza VARCHAR(100),
    Quantita INTEGER,
	PRIMARY KEY(Animale,Time_Stamp,Sostanza),
    FOREIGN KEY(Animale) REFERENCES ANIMALE(CodiceAnimale)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Sostanza) REFERENCES SOSTANZA(Nome)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CONTENIMENTO(
	Silos CHAR(5),
    Sostanza VARCHAR(100),
    Quantita DOUBLE,
	PRIMARY KEY(Silos,Sostanza),
    FOREIGN KEY(Silos) REFERENCES SILOS(CodiceSilos)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Sostanza) REFERENCES SOSTANZA(Nome)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FORMAGGIO(
	NomeFormaggio VARCHAR(100),
    Zona VARCHAR(100),
    TipoPasta VARCHAR(100),
    Ricetta TEXT,
    Deperibilita TINYINT,
    Costo INTEGER,
	PRIMARY KEY(NomeFormaggio)
);

CREATE TABLE IF NOT EXISTS MAGAZZINO(
	CodiceMagazzino CHAR(5),
    Agriturismo VARCHAR(100),
	PRIMARY KEY(CodiceMagazzino),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SCAFFALATURAMAGAZZINO(
	CodiceScaffale CHAR(5),
    Magazzino CHAR(5),
	PRIMARY KEY(CodiceScaffale),
    FOREIGN KEY(Magazzino) REFERENCES MAGAZZINO(CodiceMagazzino)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CANTINA(
	CodiceCantina CHAR(5),
    Agriturismo VARCHAR(100),
	PRIMARY KEY(CodiceCantina),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SCAFFALATURACANTINA(
	CodiceScaffale CHAR(5),
    Cantina CHAR(5),
	PRIMARY KEY(CodiceScaffale),
    FOREIGN KEY(Cantina) REFERENCES CANTINA(CodiceCantina)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LOTTO(
	CodiceLotto CHAR(5),
    DurataTotaleProcesso INTEGER,
    CodiceLaboratorio CHAR(5),
    TipoLotto VARCHAR(100),
    Data DATE,
    Scadenza DATE,
	PRIMARY KEY(CodiceLotto)
);

CREATE TABLE IF NOT EXISTS UNITA(
	Codice CHAR(5),
    Peso DOUBLE,
    Formaggio VARCHAR(100),
    Lotto CHAR(5),
    ScaffalaturaCantina CHAR(5),
    ScaffalaturaMagazzino CHAR(5),
    DataInizio DATE,
	PRIMARY KEY(Codice),
    FOREIGN KEY(Formaggio) REFERENCES FORMAGGIO(NomeFormaggio)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Lotto) REFERENCES LOTTO(CodiceLotto)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
	FOREIGN KEY(ScaffalaturaCantina) REFERENCES SCAFFALATURACANTINA(CodiceScaffale)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
	FOREIGN KEY(ScaffalaturaMagazzino) REFERENCES SCAFFALATURAMAGAZZINO(CodiceScaffale)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS PRODUZIONE(
	Silos CHAR(5),
    Unita CHAR(5),
	PRIMARY KEY(Silos,Unita),
    FOREIGN KEY(Silos) REFERENCES SILOS(CodiceSilos)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Unita) REFERENCES UNITA(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FASE(
	Formaggio VARCHAR(100),
    NomeFase VARCHAR(100),
    Durata DOUBLE,
    Temperatura DOUBLE,
    Riposo DOUBLE,
	PRIMARY KEY(Formaggio,NomeFase),
    FOREIGN KEY(Formaggio) REFERENCES FORMAGGIO(NomeFormaggio)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS POSSIEDE(
	Unita CHAR(5),
    Formaggio VARCHAR(100),
    Fase VARCHAR(100),
	Durata DOUBLE,
    Temperatura DOUBLE,
    Riposo DOUBLE,
    PRIMARY KEY(Unita,Formaggio,Fase),
    FOREIGN KEY(Unita) REFERENCES UNITA(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Formaggio,Fase) REFERENCES FASE(Formaggio,NomeFase)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IMPIEGATO(
	Dipendente CHAR(5),
    Lotto CHAR(5),
	PRIMARY KEY(Dipendente,Lotto),
    FOREIGN KEY(Lotto) REFERENCES Lotto(CodiceLotto)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DIPENDENTE(
	Codice CHAR(5),
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    Agriturismo VARCHAR(100),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SENSORICANTINA(
	Time_Stamp TIMESTAMP,
    Cantina CHAR(5),
    Umidita INTEGER,
    Temperatura INTEGER,
    Ventilazione INTEGER,
	PRIMARY KEY(Time_Stamp,Cantina),
    FOREIGN KEY(Cantina) REFERENCES CANTINA(CodiceCantina)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

/* AREA SOGGIORNO */
CREATE TABLE IF NOT EXISTS SITOWEB(
	Indirizzo VARCHAR(100),
    Agriturismo VARCHAR(100),
	PRIMARY KEY(Indirizzo),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CLIENTE(
	CodiceCliente CHAR(5),
    TipoUtente VARCHAR(100) CHECK(TipoUtente IN('Registrato','NonRegistrato')),
    NomeUtente VARCHAR(100),
    Domanda TEXT,
    Risposta VARCHAR(100),
    Password VARCHAR(100),
    CodiceCartaPayPal CHAR(4),
    SitoWeb VARCHAR(100),
	PRIMARY KEY(CodiceCliente),
    FOREIGN KEY(SitoWeb) REFERENCES SITOWEB(Indirizzo)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS PAGAMENTO(
	Codice CHAR(5),
    Tipo VARCHAR(100),
    Time_Stamp TIMESTAMP,
    Cliente CHAR(5),
    Costo INTEGER,
	PRIMARY KEY(Codice),
    FOREIGN KEY(Cliente) REFERENCES CLIENTE(CodiceCliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PRENOTAZIONE(
	Codice CHAR(5),
    DataPrenotazione DATE,
    DataArrivo DATE,
    DataPartenza DATE,
    NumeroPersone INTEGER,
    Cliente CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Cliente) REFERENCES CLIENTE(CodiceCliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS STANZA(
	Numero INTEGER,
    Agriturismo VARCHAR(100),
    Capienza INTEGER,
    Costo INTEGER,
    TipoStanza VARCHAR(100) CHECK(TipoStanza IN('Semplice','Suite')),
	PRIMARY KEY(Numero,Agriturismo),
    FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PRENOTAZIONESTANZA(
    Prenotazione CHAR(5),
    Stanza INTEGER,
    Agriturismo VARCHAR(100),
	PRIMARY KEY(Prenotazione,Stanza,Agriturismo),
    FOREIGN KEY(Prenotazione) REFERENCES PRENOTAZIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Stanza) REFERENCES STANZA(Numero)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LETTO(
	CodiceLetto CHAR(5),
    Tipo VARCHAR(100) CHECK(Tipo IN('Singolo','Matrimoniale')),
    Stanza INTEGER,
    Agriturismo VARCHAR(100),
	PRIMARY KEY(CodiceLetto),
    FOREIGN KEY(Stanza) REFERENCES STANZA(Numero)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
	FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SERVIZIO(
	Codice CHAR(5),
    NomeServizio VARCHAR(100),
    Costo INTEGER,
	PRIMARY KEY(Codice)
);

CREATE TABLE IF NOT EXISTS PRENOTAZIONESERVIZI(
	Prenotazione CHAR(5),
    Servizio CHAR(5),
    Giorni INTEGER,
	PRIMARY KEY(Prenotazione,Servizio),
    FOREIGN KEY(Prenotazione) REFERENCES PRENOTAZIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Servizio) REFERENCES SERVIZIO(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS GUIDA(
	Codice CHAR(5),
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
	PRIMARY KEY(Codice)
);

CREATE TABLE IF NOT EXISTS ESCURSIONE(
	Codice CHAR(5),
    Data DATE,
    Ora INTEGER,
    Costo INTEGER,
    Guida CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Guida) REFERENCES GUIDA(Codice)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS PRENOTAZIONEESCURSIONE(
    Prenotazione CHAR(5),
    Escursione CHAR(5),
	PRIMARY KEY(Prenotazione,Escursione),
    FOREIGN KEY(Prenotazione) REFERENCES PRENOTAZIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Escursione) REFERENCES ESCURSIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ITINERARIO(
    Escursione CHAR(5),
    Zona CHAR(5),
    Agriturismo VARCHAR(100),
    DurataSosta INTEGER,
	PRIMARY KEY(Escursione,Zona),
    FOREIGN KEY(Escursione) REFERENCES ESCURSIONE(Codice)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Zona) REFERENCES Zona(CodiceZona)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Agriturismo) REFERENCES AGRITURISMO(NomeAgriturismo)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

/* AREA STORE */
CREATE TABLE IF NOT EXISTS ANAGRAFICA(
	CodFiscale CHAR(16),
    CodiceDocumento CHAR(6),
    Nome VARCHAR(100),
    Cognome VARCHAR(100),
    Indirizzo VARCHAR(100),
    ScadenzaDocumento DATE,
    Ente VARCHAR(100),
    TipoDocumento VARCHAR(100),
    Telefono INTEGER,
    DataIscrizione DATE,
    Cliente CHAR(5),
	PRIMARY KEY(CodFiscale),
    FOREIGN KEY(Cliente) REFERENCES CLIENTE(CodiceCliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ORDINE(
	CodiceOrdine CHAR(5),
    Time_Stamp TIMESTAMP,
    Stato VARCHAR(100) CHECK(Stato IN('pendente','in processazione','in preparazione','spedito','evaso')),
    Cliente CHAR(5),
	PRIMARY KEY(CodiceOrdine),
    FOREIGN KEY(Cliente) REFERENCES CLIENTE(CodiceCliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ACQUISTO(
    Ordine CHAR(5),
    Formaggio VARCHAR(100),
    Quantita INTEGER,
	PRIMARY KEY(Ordine,Formaggio),
    FOREIGN KEY(Ordine) REFERENCES ORDINE(CodiceOrdine)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Formaggio) REFERENCES FORMAGGIO(NomeFormaggio)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS SPEDIZIONE(
	Codice CHAR(5),
    DataConsegna DATE,
    Stato VARCHAR(100),
    Posizione VARCHAR(100),
    Ordine CHAR(5),
	PRIMARY KEY(Codice),
	FOREIGN KEY(Ordine) REFERENCES ORDINE(CodiceOrdine)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RESO(
	Codice CHAR(5),
    Analisi TEXT,
    Ordine CHAR(5),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Ordine) REFERENCES ORDINE(CodiceOrdine)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TIPO(
	Reso CHAR(5),
    Formaggio VARCHAR(100),
    Quantita INTEGER,
	PRIMARY KEY(Reso,Formaggio),
    FOREIGN KEY(Formaggio) REFERENCES FORMAGGIO(NomeFormaggio)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RECENSIONE(
	Codice CHAR(5),
    Conservazione INTEGER CHECK(Conservazione BETWEEN 1 AND 10),
    CampoTestuale TEXT,
    Qualita INTEGER CHECK(Qualita BETWEEN 1 AND 10),
    Gusto INTEGER CHECK(Gusto BETWEEN 1 AND 10),
    Gradimento INTEGER CHECK(Gradimento BETWEEN 1 AND 10),
    Ordine CHAR(5),
    Formaggio VARCHAR(100),
	PRIMARY KEY(Codice),
    FOREIGN KEY(Ordine) REFERENCES ORDINE(CodiceOrdine)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Formaggio) REFERENCES FORMAGGIO(NomeFormaggio) 
		ON UPDATE CASCADE
        ON DELETE CASCADE
);