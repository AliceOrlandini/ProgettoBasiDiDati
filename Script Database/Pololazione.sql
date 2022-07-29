/* AREA ALLEVAMENTO */
INSERT INTO Fornitore
VALUES('for01','Mario srl','Azienda','Via Palermo 22'),
	  ('for02','Luigi srl','Privato','Via Padova 10'),
      ('for03','Daysi srl','Ditta','Via Lucca 13'),
      ('for04','Yoshi srl','Azienda','Via Roma 59');
      
INSERT INTO Specie
VALUES('Mucca marrone','Mucca','Muccus',1),
	  ('Mucca selvatica','Mucca','Muccus',1),
      ('Toro cornuto','Toro','Torus',1),
      ('Gallina rossa','Gallina','Gallinus',2),
      ('Capra con la barba','Capra','Caprus',1);
      
INSERT INTO Agriturismo
VALUES('Il susino'),
	  ('La mucca'),
      ('Il formaggio');
      
INSERT INTO Stalla
VALUES('sta01','Il susino'),
	  ('sta02','La mucca'),
      ('sta03','La mucca'),
      ('sta04','Il formaggio'),
      ('sta05','Il formaggio');
      
INSERT INTO Locale
VALUES('loc01',2,3,4,'E','Terra',35,56,'sta01'),
	  ('loc02',5,7,4,'N','Terra',45,77,'sta01'),
      ('loc03',10,10,4,'E','Terra',54,39,'sta02'),
      ('loc04',5,8,4,'S','Parquet',40,32,'sta03'),
      ('loc05',5,8,4,'S','Moquette',40,56,'sta03');
      
INSERT INTO Animale 
VALUES('ani01','2010-01-29','F',120,90,'2014-05-10','2014-05-15','for01','Mucca selvatica',NULL,NULL,'loc03'),
	  ('ani02','2010-02-21','M',120,90,'2014-05-10','2014-05-15','for01','Mucca selvatica',NULL,NULL,'loc03'),
      ('ani03','2015-06-29','F',100,80,NULL,NULL,NULL,'Mucca marrone','ani01','ani02','loc03'),
      ('ani04','2007-06-24','M',74,85,'2008-04-02','2008-04-10','for03','Capra con la barba',NULL,NULL,'loc02'),
      ('ani05','2008-01-17','F',98,85,'2009-04-05','2009-04-15','for03','Capra con la barba',NULL,NULL,'loc02'),
      ('ani06','2016-03-27','F',90,85,NULL,NULL,NULL,'Capra con la barba','ani05','ani04','loc02'),
      ('ani07','2010-02-16','M',22,30,'2011-11-11','2011-12-25','for04','Gallina rossa',NULL,NULL,'loc01'),
      ('ani08','2014-04-17','F',13,30,'2014-04-18','2014-04-20','for04','Gallina rossa',NULL,NULL,'loc01'),
      ('ani09','2018-07-13','F',20,30,NULL,NULL,NULL,'Gallina rossa','ani08','ani07','loc01');
      
INSERT INTO GPS
VALUES(CURRENT_TIMESTAMP(),'ani01',10,11),
	  (CURRENT_TIMESTAMP(),'ani02',10,11),
      (CURRENT_TIMESTAMP(),'ani03',13,22),
      (CURRENT_TIMESTAMP(),'ani04',14,21),
      (CURRENT_TIMESTAMP(),'ani05',32,33),
      (CURRENT_TIMESTAMP(),'ani06',14,21),
	  (CURRENT_TIMESTAMP(),'ani07',31,29),
      (CURRENT_TIMESTAMP(),'ani08',8,35),
      (CURRENT_TIMESTAMP(),'ani09',7,9);

INSERT INTO Igiene 
VALUES('loc01',CURRENT_TIMESTAMP(),30,'no',4,10,12,26),
	  ('loc02',CURRENT_TIMESTAMP(),40,'no',5,1,4,23),
      ('loc03',CURRENT_TIMESTAMP(),50,'no',2,4,5,22),
      ('loc04',CURRENT_TIMESTAMP(),10,'no',0,5,13,25),
      ('loc05',CURRENT_TIMESTAMP(),55,'no',8,3,22,25);
      
INSERT INTO Abbeveratoio 
VALUES('abb01','Basso','loc01'),
	  ('abb02','Medio','loc02'),
      ('abb03','Alto','loc03'),
      ('abb04','Alto','loc03'),
      ('abb05','Alto','loc04');
      
INSERT INTO SensoreAbbeveratoio 
VALUES(CURRENT_TIMESTAMP(),'abb01',40,62,43),
	  (CURRENT_TIMESTAMP(),'abb02',50,63,13),
      (CURRENT_TIMESTAMP(),'abb03',100,35,63),
      (CURRENT_TIMESTAMP(),'abb04',100,53,61),
      (CURRENT_TIMESTAMP(),'abb05',45,45,16);
      
INSERT INTO Mangiatoia
VALUES('man01','Bassa','loc01'),
	  ('man02','Media','loc02'),
      ('man03','Alta','loc03'),
      ('man04','Alta','loc03'),
      ('man05','Alta','loc04');
      
INSERT INTO Foraggio 
VALUES('Tipo1',12,1,11,14,3,6,536,'Fresco'),
	  ('Tipo2',24,5,2,6,21,5,314,'Fresco'),
      ('Tipo3',12,5,2,5,11,5,550,'Conservato');
      
INSERT INTO SensoreMangiatoia 
VALUES(CURRENT_TIMESTAMP(),'man01',10,'Tipo1'),
	  (CURRENT_TIMESTAMP(),'man02',23,'Tipo2'),
      (CURRENT_TIMESTAMP(),'man03',12,'Tipo1'),
      (CURRENT_TIMESTAMP(),'man04',11,'Tipo3'),
      (CURRENT_TIMESTAMP(),'man05',22,'Tipo2');
      
INSERT INTO Pasto 
VALUES(CURRENT_TIMESTAMP(),'man01',100,'Tipo1'),
	  (CURRENT_TIMESTAMP(),'man02',131,'Tipo2'),
      (CURRENT_TIMESTAMP(),'man03',124,'Tipo1'),
      (CURRENT_TIMESTAMP(),'man04',133,'Tipo3'),
      (CURRENT_TIMESTAMP(),'man05',120,'Tipo2');
      
INSERT INTO Recinzione 
VALUES('rec01',42,35,30),
	  ('rec02',53,36,13),
      ('rec03',63,62,77),
      ('rec04',10,27,66),
      ('rec05',23,62,88);
      
INSERT INTO Pascolo 
VALUES('pas01','1:00','16:00','loc03','rec01'),
	  ('pas02','1:00','16:00','loc02','rec02'),
      ('pas03','2:00','16:00','loc03','rec03');
      
INSERT INTO Zona 
VALUES('zon01','Prato',32,52,66,'Il formaggio'),
	  ('zon02','Giochi',22,62,12,'Il formaggio'),
      ('zon03','Stanze',46,11,55,'La mucca'),
      ('zon04','Animali',75,63,50,'Il susino'),
      ('zon05','Produzione',12,68,43,'Il susino');
      
INSERT INTO Veterinario
VALUES('vet01','Francesco','Pistolesi'),
	  ('vet02','Placido','Longo'),
      ('vet03','Gigliola','Vaglini'),
      ('vet04','Gianluca','Dini'),
      ('vet05','Nicoletta','De Francesco');
      
INSERT INTO Riproduzione 
VALUES('rip01','Insuccesso','2015-06-01','vet05','ani04','ani05'),
	  ('rip02','Insuccesso','2014-09-10','vet02','ani02','ani01'),
      ('rip03','Successo','2015-06-13','vet05','ani04','ani05'),
      ('rip04','Successo','2014-09-21','vet01','ani02','ani01'),
      ('rip05','Successo','2017-11-12','vet03','ani07','ani08');
      
INSERT INTO Gravidanza 
VALUES('gra01','rip03',1,0,'2015-06-23','vet05'),
	  ('gra02','rip04',1,0,'2014-10-31','vet02'),
      ('gra03','rip05',1,0,'2017-11-13','vet01');

/* AREA HEALTCARE*/
INSERT INTO Patologia 
VALUES('Scompenso Cardiaco'),
	  ('Polmonite'),
      ('Diarrea'),
      ('Emicrania'),
      ('Vomito');
      
INSERT INTO Visita 
VALUES('vis01',0,'2015-06-23',53,66,'Controllo Gravidanza','gra01','ani05','vet02'),
	  ('vis02',0,'2014-10-31',22,31,'Controllo Gravidanza','gra02','ani01','vet01'),
      ('vis03',0,'2018-03-25',74,62,'Controllo',NULL,'ani09','vet05'),
      ('vis04',0,'2010-05-06',63,12,'Controllo',NULL,'ani02','vet04'),
      ('vis05',0,'2019-02-10',53,42,'Controllo',NULL,'ani03','vet02');
      
INSERT INTO IndicatoreSoggettivo 
VALUES('sog01','Regolare','Leggermente disidratato','Buona','Buona',1,'vis01'),
	  ('sog02','A fatica','Buona','A fatica','Media',2,'vis04'),
      ('sog03','Regolare','Molto disidratato','Buona','Non buona',5,'vis05');
      
INSERT INTO IndicatoreOggettivo
VALUES('ogg01','Regolare','Dilatato','Affaticato','Regolare','Buono','Globuli bianchi 4, Piastrine 3','vis01'),
	  ('ogg02','Tachicardia','Dilatato','Regolare','Regolare','Rovinato','Globuli bianchi 1, Piastrine 3','vis02'),
      ('ogg03','Bradicardia','Regolare','Gonfio','Regolare','Rovinato','Globuli bianchi 6, Piastrine 5','vis05');
      
INSERT INTO RilevamentoPatologia 
VALUES('vis01','Vomito'),
	  ('vis02','Emicrania'),
      ('vis03','Diarrea'),
      ('vis04','Polmonite'),
      ('vis05','Scompenso Cardiaco');
      
INSERT INTO Disturbo 
VALUES('Spasmi'),
	  ('Irrequieto'),
      ('Tranquillo');
      
INSERT INTO Accertamento 
VALUES('sog01','Irrequieto',5),
	  ('sog02','Spasmi',6),
      ('sog03','Spasmi',10);
      
INSERT INTO Lesione 
VALUES('les01','Ferita','Zampa'),
	  ('les02','Morso','Coscia'),
      ('les03','Graffio','Viso');
      
INSERT INTO Verifica 
VALUES('sog01','les01',7),
	  ('sog02','les03',2),
      ('sog03','les02',5);
      
INSERT INTO Esame 
VALUES('esa01','Analisi del sangue',NULL,'Si toglie il sangue da una vena del braccio','2015-06-30','vis01'),
	  ('esa02','Analisi del sangue',NULL,'Si toglie il sangue da una vena del braccio','2014-11-03','vis02'),
      ('esa03','Tac','mac01','Si inserisce il soggetto nel macchinario e si attendono i risultati','2019-02-15','vis05'),
      ('esa04','Pet','mac02','Si inserisce il soggetto nel macchinario e si attendono i risultati','2019-02-15','vis05'),
      ('esa05','Risonanza magnetica','mac03','Si inserisce il soggetto nel macchinario e si attendono i risultati','2019-02-15','vis05');
      
INSERT INTO Terapia 
VALUES('ter01','2018-03-26',10,'ani09','vis03'),
	  ('ter02','2010-05-07',21,'ani02','vis04'),
      ('ter03','2019-02-11',7,'ani03','vis05');
      
INSERT INTO Farmaco 
VALUES('Oki'),
	  ('Buscofen'),
      ('Malox'),
      ('Tachipirina'),
      ('NP-Completezza');
      
INSERT INTO Somministrazione 
VALUES('ter01','Buscofen',3,2),
	  ('ter01','Malox',5,2),
      ('ter02','Tachipirina',NULL,1),
      ('ter03','Oki',4,3),
      ('ter03','Tachipirina',5,2);
      
INSERT INTO Quarantena 
VALUES('ani03','2018-04-01','2018-04-24'),
	  ('ani05','2019-02-19',CURRENT_DATE());

/* AREA PRODUZIONE */
INSERT INTO Silos
VALUES('sil01','50','1000'),
	  ('sil02','60','1000'),
      ('sil03','70','1000'),
      ('sil04','30','1000'),
      ('sil05','40','1000');

INSERT INTO Latte
VALUES('ani01',CURRENT_TIMESTAMP,'1','mun01', 'sil01'),
	  ('ani02',CURRENT_TIMESTAMP,'2','mun02', 'sil02'),
      ('ani03',CURRENT_TIMESTAMP,'3','mun03', 'sil03'),
      ('ani04',CURRENT_TIMESTAMP,'2','mun04', 'sil04'),
      ('ani05',CURRENT_TIMESTAMP,'1','mun05', 'sil05');
      
INSERT INTO Mungitrice
VALUES('mun01','medello 01','marca 01','46', '78'),
	  ('mun02','medello 01','marca 01','67', '45'),
      ('mun03','medello 01','marca 01','89', '67'),
      ('mun04','medello 01','marca 01','106', '87'),
      ('mun05','medello 01','marca 01','17', '99');
      
INSERT INTO Sostanza
VALUES('lattosio'),
	  ('fruttosio'),
      ('glucosio'),
      ('saccarosio'),
      ('maltosio');
      
INSERT INTO Composizione
VALUES('ani01',CURRENT_TIMESTAMP,'fruttosio', '30'),
	  ('ani02',CURRENT_TIMESTAMP,'saccarosio', '60'),
      ('ani03',CURRENT_TIMESTAMP,'maltosio', '40'),
      ('ani04',CURRENT_TIMESTAMP,'fruttosio', '50'),
      ('ani05',CURRENT_TIMESTAMP,'glucosio', '10');

INSERT INTO Contenimento
VALUES('sil01','fruttosio', '30'),
	  ('sil02','saccarosio', '60'),
      ('sil03','maltosio', '40'),
      ('sil04','fruttosio', '50'),
      ('sil05','glucosio', '10');

INSERT INTO Formaggio
VALUES('pecorino','sardegna','dura','ricetta', '1', '1'),
	  ('asiago','trentino','dura','ricetta', '5', '5'),
      ('grana','emilia','dura','ricetta', '3', '3'),
      ('parmigiano','emilia','dura','ricetta', '4', '4'),
      ('mozzarella','puglia','morbida','ricetta', '2','5');
      
INSERT INTO Magazzino
VALUES('mag01','Il susino'),
	  ('mag02','La mucca'),
      ('mag03','Il formaggio'),
      ('mag04','Il susino'),
      ('mag05','La mucca');
      
INSERT INTO SCAFFALATURAMAGAZZINO
VALUES('sca01','mag01'),
	  ('sca02','mag02'),
      ('sca03','mag03'),
      ('sca04','mag04'),
      ('sca05','mag05');
      
INSERT INTO Cantina
VALUES('can01','Il susino'),
	  ('can02','La mucca'),
      ('can03','Il formaggio'),
      ('can04','Il susino'),
      ('can05','La mucca');
      
INSERT INTO SCAFFALATURACANTINA
VALUES('scf01','can01'),
	  ('scf02','can02'),
      ('scf03','can03'),
      ('scf04','can04'),
      ('scf05','can05');
      
INSERT INTO Lotto
VALUES('lot01','1','lab01','tipo1',CURRENT_DATE(), '2019-07-27'),
	  ('lot02','1','lab05','tipo1',CURRENT_DATE(), '2019-07-27'),
      ('lot03','1','lab04','tipo1',CURRENT_DATE(), '2019-07-27'),
      ('lot04','1','lab03','tipo2',CURRENT_DATE(), '2019-07-27'),
      ('lot05','1','lab02','tipo3',CURRENT_DATE(), '2019-07-27');
      
INSERT INTO UNITA
VALUES('uni01','1','pecorino', 'lot01', NULL,'sca02', NULL),
	  ('uni02','1.5','grana', 'lot01', 'scf01',NULL,'2019-07-15'),
      ('uni03','1.7','asiago', 'lot01', 'scf01',NULL, '2019-07-15'),
      ('uni04','2.0','mozzarella', 'lot03',NULL,'sca02', NULL),
      ('uni05','2.2','parmigiano', 'lot05',NULL,'sca02', NULL);
  
INSERT INTO Produzione
VALUES('sil02','uni01'),
	  ('sil03','uni02'),
      ('sil05','uni03'),
      ('sil01','uni04'),
      ('sil01','uni05');
      
INSERT INTO Fase
VALUES('pecorino','fase1','1','46', '78'),
	  ('pecorino','fase3','2','67', '45'),
      ('pecorino','fase2','1','89', '67'),
      ('mozzarella','fase2','1','106', '87'),
      ('mozzarella','fase1','1','17', '99'),
	  ('asiago','fase1','2','67', '45'),
      ('parmigiano','fase1','1','89', '67'),
      ('grana','fase1','1','106', '87');

INSERT INTO Possiede
VALUES('uni01','pecorino','fase1','3', '56', '11'),
	  ('uni01','pecorino','fase2','4', '24', '23'),
      ('uni01','pecorino','fase3','6', '35', '65'),
	  ('uni02','grana','fase1','2', '105', '5'),
      ('uni03','asiago','fase1','1', '89', '3'),
      ('uni04','mozzarella','fase1','5', '178', '4'),
      ('uni04','mozzarella','fase2','5', '128', '6'),
      ('uni05','parmigiano','fase1','9', '100','5');

INSERT INTO Impiegato
VALUES('dip01','lot01'),
	  ('dip02','lot01'),
      ('dip03','lot01'),
      ('dip04','lot03'),
      ('dip05','lot03');

INSERT INTO Dipendente
VALUES('dip01','Antonio','Patimo','Il susino'),
	  ('dip02','Alice','Orlandini','La mucca'),
      ('dip03','Chiara','Bella','Il susino'),
      ('dip04','Fabio','Rossi','Il formaggio'),
      ('dip05','Massi','Romani','Il susino');
      
INSERT INTO SensoriCantina
VALUES(CURRENT_TIMESTAMP,'can01','78','46', '78'),
	  (CURRENT_TIMESTAMP,'can02','67','67', '45'),
      (CURRENT_TIMESTAMP,'can03','89','89', '67'),
      (CURRENT_TIMESTAMP,'can04','56','106', '87'),
      (CURRENT_TIMESTAMP,'can05','45','17', '99');

/* AREA SOGGIORNO */
INSERT INTO SitoWeb
VALUES('sit01','La mucca'),
	  ('sit02','Il formaggio'),
      ('sit03','Il susino');
      
INSERT INTO Cliente
VALUES('cli01','Registrato','Gino','pecorino', 'lot01', '0000','0001', 'sit01'),
	  ('cli02','Registrato','Lino','grana', 'lot01', '0000','0002','sit01'),
      ('cli03','Registrato','Pino','asiago', 'lot01', '0000','0003','sit03'),
      ('cli04','Registrato','Albertino','mozzarella', '0000','0004','0004', 'sit01'),
      ('cli05','NonRegistrato','Pippo','parmigiano', '0000','0005','0005', 'sit02');
      
INSERT INTO Pagamento
VALUES('pag01','fase1',CURRENT_TIMESTAMP,'cli01',0),
	  ('pag02','fase3',CURRENT_TIMESTAMP, 'cli02',0),
      ('pag03','fase2',CURRENT_TIMESTAMP, 'cli03',0),
      ('pag04','fase2',CURRENT_TIMESTAMP, 'cli04',0),
      ('pag05','fase1',CURRENT_TIMESTAMP, 'cli05',0);
      
INSERT INTO Prenotazione
VALUES('pre01','2019-07-15','2019-07-15','2019-07-27', '1', 'cli01'),
	  ('pre02','2019-07-15','2019-07-15','2019-07-27', '1', 'cli02'),
      ('pre03','2019-07-15','2019-07-15','2019-07-27', '1', 'cli03'),
      ('pre04','2019-07-15','2019-07-15','2019-07-27', '1', 'cli04'),
      ('pre05','2019-07-15','2019-07-15','2019-07-27', '1','cli05');

INSERT INTO Stanza
VALUES('01','IL susino','1','46', 'Semplice'),
	  ('02','IL susino','2','67', 'Suite'),
      ('03','IL susino','1','89', 'Suite'),
      ('04','IL susino','1','106', 'Semplice'),
      ('05','La mucca','1','17', 'Semplice');

INSERT INTO PrenotazioneStanza
VALUES('pre01','01', 'Il susino'),
	  ('pre02','02', 'Il susino'),
      ('pre03','03', 'Il susino'),
      ('pre04','04', 'Il susino'),
      ('pre05','05', 'La mucca');

INSERT INTO Letto
VALUES('let01','Singolo','05','La mucca'),
	  ('let02','Singolo','04','Il susino'),
      ('let03','Singolo','01','Il susino'),
      ('let04','Matrimoniale','03','Il susino'),
      ('let05','Matrimoniale','02','Il susino');
      
INSERT INTO Servizio
VALUES('ser01','Piscina', '5'),
	  ('ser02','Piscina', '5'),
      ('ser03','Piscina', '5'),
      ('ser04','Idromassaggio', '5'),
      ('ser05','Idromassaggio', '5');
	
INSERT INTO PrenotazioneServizi
VALUES('pre01','ser01', '1'),
	  ('pre02','ser01', '1'),
      ('pre03','ser01', '1'),
      ('pre04','ser01', '1');
      
INSERT INTO Guida
VALUES('gui01','Mario', 'Bros'),
	  ('gui02','Luigi', 'Bros'),
      ('gui03','Peach', 'Yogoto'),
      ('gui04','Bowser', 'Katsumi'),
      ('gui05','Toad', 'Miamoto');

INSERT INTO Escursione
VALUES('esc01','2019-07-15','14','46', 'gui01'),
	  ('esc02','2019-07-15','14','14', 'gui02'),
      ('esc03','2019-07-15','14','16', 'gui03'),
      ('esc04','2019-07-15','14','17', 'gui04'),
      ('esc05','2019-07-15','14','18', 'gui05');
      
INSERT INTO PrenotazioneEscursione
VALUES('pre01','esc01'),
	  ('pre02','esc02'),
      ('pre03','esc03'),
      ('pre04','esc04'),
      ('pre05','esc05');

INSERT INTO Itinerario
VALUES('esc01','zon01','La mucca','1'),
	  ('esc02','zon02','La mucca','1'),
      ('esc03','zon03','La mucca','1'),
      ('esc04','zon04','La mucca','1'),
      ('esc05','zon05','Il susino','1');

/* AREA STORE */
INSERT INTO Anagrafica
VALUES('cof01','cod01','Gino','Razzo', 'g@gmail', '2030-01-01','Comune', 'CartaIdentita', '3458', '1999-08-01', 'cli01'),
	  ('cof02','cod01','Lino','Pazzo', 'l@gmail', '2030-01-01','Comune','CartaIdentita','3458', '1999-08-01', 'cli02'),
      ('cof03','cod01','Pino','Patimo', 'p@gmail', '2030-01-01','Comune','CartaIdentita', '3836', '1999-08-01', 'cli03'),
      ('cof04','cod01','Albertino','Re', 'a@gmail','2030-01-01','Comune', 'CartaIdentita', '3456', '1999-08-01', 'cli04'),
      ('cof05','cod01','Pippo','Pluto', 'pi@gmail','2030-01-01','Comune', 'CartaIdentita','36', '1999-08-01', 'cli05');

INSERT INTO Ordine
VALUES('ord01',CURRENT_TIMESTAMP,NULL,'cli01'),
	  ('ord02',CURRENT_TIMESTAMP,NULL,'cli02'),
      ('ord03',CURRENT_TIMESTAMP,NULL,'cli03'),
      ('ord04',CURRENT_TIMESTAMP,NULL,'cli04'),
      ('ord05',CURRENT_TIMESTAMP,NULL,'cli05');

INSERT INTO Acquisto
VALUES('ord01','pecorino', '15'),
	  ('ord02','mozzarella', '1'),
      ('ord03','asiago', '2'),
      ('ord04','parmigiano', '5'),
      ('ord05','grana', '9');

INSERT INTO Spedizione
VALUES('spe01','2019-07-26',NULL,'46', 'ord01'),
	  ('spe02','2019-07-26',NULL,'67', 'ord02'),
      ('spe03','2019-07-26',NULL,'89', 'ord03'),
      ('spe04','2019-07-26',NULL,'106', 'ord04'),
      ('spe05','2019-07-26',NULL,'17', 'ord05');
      
INSERT INTO Reso
VALUES('res01','pecorino', 'ord01'),
	  ('res02','mozzarella', 'ord02'),
      ('res03','asiago', 'ord03'),
      ('res04','parmigiano', 'ord04'),
      ('res05','grana', 'ord05');

INSERT INTO Tipo
VALUES('res01','pecorino', '1'),
	  ('res02','mozzarella', '1'),
      ('res03','asiago', '2'),
      ('res04','parmigiano', '3'),
      ('res05','grana', '3');

INSERT INTO Recensione
VALUES('rec01','7','Text','1', '2', '7','ord01', 'pecorino'),
	  ('rec02','7','Text','8', '7', '6','ord02','mozzarella'),
      ('rec03','7','Text','8', '6', '2','ord03','asiago'),
      ('rec04','7','Text','1', '2','7','ord04', 'parmigiano'),
      ('rec05','7','Text','9', '9','9','ord05', 'grana');