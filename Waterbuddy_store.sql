-- maak database WATERBUDDY_STORE 
DROP DATABASE IF EXISTS `waterbuddy_store`;
CREATE DATABASE `waterbuddy_store`;
USE `waterbuddy_store`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;


-- maak tabel `klanten`
CREATE TABLE `klanten` (
	`klant_id` int(10) NOT NULL AUTO_INCREMENT,
    `voornaam` varchar(50) NOT NULL,
    `achternaam` varchar(50) NOT NULL,
    `geboorte_datum` date NOT NULL,
    `telefoon` varchar(50) NULL,
    `email` varchar(50) NOT NULL,
    `adres` varchar(50) NOT NULL,
    `plaats` varchar(50) NOT NULL,
    `punten` int(11) NOT NULL DEFAULT '0',
    `wachtwoord` varchar(50) NULL,
    PRIMARY KEY (`klant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11;
INSERT INTO `klanten` VALUES (1,'Hans','Koffie','1986-03-22','06-42-9754','h.koffie@avans.nl','koffiestraat 1','Breda',2273,'hk001');
INSERT INTO `klanten` VALUES (2,'Koen','Verstappen','1990-03-21','06-27-9456','k.verstappen@avans.nl','Heiligeweg 32','Rotterdam',947,'kv002');
INSERT INTO `klanten` VALUES (3,'Fred','Brug','1985-02-07','06-72-7869','f.brug@avans.nl','Haarlemmerweg 20','Amsterdam',2967,'fb003');
INSERT INTO `klanten` VALUES (4,'Jaap','Huisman','1974-04-14','06-23-8017','j.huisman@avans.nl','Schoonstraat 13','Eindhoven',457,'jp004');
INSERT INTO `klanten` VALUES (5,'Roos','Schuur','1973-11-07',NULL,'r.schuur@avans.nl','Balistraat 64','Alkmaar',3675,'rs005');
INSERT INTO `klanten` VALUES (6,'Els','Boom','1991-09-04','06-12-8498','e.boom@avans.nl','Konijnenweg 11','Vlissingen',3073,'eb006');
INSERT INTO `klanten` VALUES (7,'Irene','De Boer','1964-08-30','06-41-4759','i.deboer@avans.nl','Parelweg 99','Ijmuiden',1672,'ib007');
INSERT INTO `klanten` VALUES (8,'Mark','Groot','1993-07-17','06-88-3977','m.groot@avans.nl','Schipholweg','Schiphol',205,'mg008');
INSERT INTO `klanten` VALUES (9,'Leroy','Klein','1992-05-23','06-59-3744','l.klein@avans.nl','Overtoom','Amsterdam',1486,'lk009');
INSERT INTO `klanten` VALUES (10,'Maria','Vlinder','1969-10-13','06-18-3370','m.vlinder@avans.nl','Leidseplein','Haarlem',796,'mv0010');

-- maak tabel `vervoerders`
CREATE TABLE `vervoerders` (
	`vervoerder_id` smallint(6) NOT NULL AUTO_INCREMENT,
    `naam` varchar(50) NOT NULL,
    PRIMARY KEY (`vervoerder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5;
INSERT INTO `vervoerders` VALUES (1,'PostNL');
INSERT INTO `vervoerders` VALUES (2,'DHL');
INSERT INTO `vervoerders` VALUES (3,'UPS');
INSERT INTO `vervoerders` VALUES (4,'FEDEX');

-- maak tabel `medewerkers`
CREATE TABLE `medewerkers` (
	`medewerker_id` int(10) NOT NULL AUTO_INCREMENT,
    `voornaam` varchar(50) NOT NULL,
    `achternaam` varchar(50) NOT NULL,
    `functie` varchar(50) NOT NULL,
    `email` varchar(50) NOT NULL,
    `toetredings_datum` Date NOT NULL,
    `salaris` int(10) NOT NULL,
    `rapporteert_aan` int(10) NULL,
    `wachtwoord` varchar(50) NULL,
    PRIMARY KEY (`medewerker_id`),
    KEY `fk_medewerkers_medewerkers_idx` (`rapporteert_aan`),
    CONSTRAINT `fk_medewerkers_managers` FOREIGN KEY (`rapporteert_aan`) 
			REFERENCES `medewerkers` (`medewerker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6;
INSERT INTO `medewerkers` VALUES (1,'Huseyin','Tufekci','CEO','h.tufekci@waterbuddy.nl','2021-12-01',110150,NULL,'ht10');
INSERT INTO `medewerkers` VALUES (2,'Lieke','Span','Commercieel directeur','l.span@waterbuddy.nl','2021-09-20',62871,1,'ls20');
INSERT INTO `medewerkers` VALUES (3,'Milan','Toen','Financieel directeur','m.toen@waterbuddy.nl','2021-11-01',98926,1,'mt30');
INSERT INTO `medewerkers` VALUES (4,'Ekko','Oosterhout','Operationeel directeur','e.oosterhout@waterbuddy.nl','2021-02-13',94860,2,'eo40');
INSERT INTO `medewerkers` VALUES (5,'Maria','Baas','Marketing medewerker','m.baas@waterbuddy.nl','2021-01-28',63996,3,'mb50');

-- maak tabel `bestellingen`
CREATE TABLE `bestellingen` (
	`bestel_id` int(10) NOT NULL AUTO_INCREMENT,
    `klant_id` int(10) NOT NULL,
    `bestel_datum` date NOT NULL,
    `status` varchar(50) NOT NULL DEFAULT 'verwerkt',
    `verzend_datum` date NULL,
    `vervoerder_id` smallint(6) NULL,
    `medewerker_id` int(10) NOT NULL,
    PRIMARY KEY (`bestel_id`),
    KEY `fk_bestellingen_klanten_idx` (`klant_id`),
    KEY `fk_bestellingen_vervoerders_idx` (`vervoerder_id`),
    KEY `fk_bestellingen_medewerkers_idx` (`medewerker_id`),
    CONSTRAINT `fk_bestellingen_klanten` FOREIGN KEY (`klant_id`) REFERENCES `klanten` (`klant_id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_bestellingen_vervoerders` FOREIGN KEY (`vervoerder_id`) REFERENCES `vervoerders` (`vervoerder_id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_bestellingen_medewerkers` FOREIGN KEY (`medewerker_id`) REFERENCES `medewerkers` (`medewerker_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11;
INSERT INTO `bestellingen` VALUES (1,6,'2022-01-30',DEFAULT,NULL,1,1);
INSERT INTO `bestellingen` VALUES (2,7,'2021-08-02','verzonden','2021-09-10',4,3);
INSERT INTO `bestellingen` VALUES (3,8,'2020-12-01',DEFAULT,NULL,2,2);
INSERT INTO `bestellingen` VALUES (4,2,'2020-01-22',DEFAULT,NULL,3,4);
INSERT INTO `bestellingen` VALUES (5,5,'2020-08-25','geleverd','2020-09-15',3,5);
INSERT INTO `bestellingen` VALUES (6,10,'2021-11-18',DEFAULT,NULL,4,3);
INSERT INTO `bestellingen` VALUES (7,2,'2021-09-22','verzonden','2021-10-05',4,1);
INSERT INTO `bestellingen` VALUES (8,5,'2021-06-08',DEFAULT,NULL,2,2);
INSERT INTO `bestellingen` VALUES (9,10,'2020-07-05','geleverd','2020-07-28',1,5);
INSERT INTO `bestellingen` VALUES (10,6,'2022-02-22','verzonden','2022-03-10',1,4);

-- maak tabel `producten`
CREATE TABLE `producten` (
	`product_id` int(10) NOT NULL AUTO_INCREMENT,
    `naam` varchar(50) NOT NULL,
    `voorraad` int(10) NOT NULL,
    `prijs` decimal(5,2) NOT NULL,
    PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11;
INSERT INTO `producten` VALUES (1,'Waterbuddy basic model, A',160,9.95);
INSERT INTO `producten` VALUES (2,'Waterbuddy basic model, B',145,19.95);
INSERT INTO `producten` VALUES (3,'Waterbuddy basic model, C',120,29.35);
INSERT INTO `producten` VALUES (4,'Waterbuddy basic model, D',115,49.53);
INSERT INTO `producten` VALUES (5,'Waterbuddy basic model, E',107,55.63);
INSERT INTO `producten` VALUES (6,'Waterbuddy advanced model, AD1',85,69.96);
INSERT INTO `producten` VALUES (7,'Waterbuddy advanced model, AD2',70,144.80);
INSERT INTO `producten` VALUES (8,'Waterbuddy advanced model, AD3',57,176.90);
INSERT INTO `producten` VALUES (9,'Waterbuddy advanced model, AD4',18,199.95);
INSERT INTO `producten` VALUES (10,'Waterbuddy advanced model, AD5',4,255.17);

-- maak tabel `bestelregels`
CREATE TABLE `bestelregels` (
	`bestel_id` int(10) NOT NULL AUTO_INCREMENT,
    `product_id` int(10) NOT NULL,
    `aantal` int(10) NOT NULL,
    `prijs` decimal(6,2) NOT NULL,
    `korting` decimal(7,2) NULL DEFAULT '0',
    PRIMARY KEY (`bestel_id`, `product_id`),
    KEY `fk_bestelregels_producten_idx` (`product_id`),
    CONSTRAINT `fk_bestelregels_bestellingen` FOREIGN KEY (`bestel_id`) REFERENCES `bestellingen` (`bestel_id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_bestelregels_producten` FOREIGN KEY (`product_id`) REFERENCES `producten` (`product_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11;
INSERT INTO `bestelregels` VALUES (1,4,4,198.12,NULL);
INSERT INTO `bestelregels` VALUES (2,1,2,19.90,NULL);
INSERT INTO `bestelregels` VALUES (2,4,4,198.12,NULL);
INSERT INTO `bestelregels` VALUES (2,6,2,139.92,NULL);
INSERT INTO `bestelregels` VALUES (3,3,10,293.50,NULL);
INSERT INTO `bestelregels` VALUES (4,3,7,205.45,NULL);
INSERT INTO `bestelregels` VALUES (4,10,7,346.71,NULL);
INSERT INTO `bestelregels` VALUES (5,2,3,59.85,NULL);
INSERT INTO `bestelregels` VALUES (6,1,4,39.80,NULL);
INSERT INTO `bestelregels` VALUES (6,2,4,79.80,NULL);
INSERT INTO `bestelregels` VALUES (6,3,4,118.12,NULL);
INSERT INTO `bestelregels` VALUES (6,5,1,199.95,NULL);
INSERT INTO `bestelregels` VALUES (7,3,7,206.71,NULL);
INSERT INTO `bestelregels` VALUES (8,5,2,111.26,NULL);
INSERT INTO `bestelregels` VALUES (8,8,2,353.80,NULL);
INSERT INTO `bestelregels` VALUES (9,6,5,349.80,NULL);
INSERT INTO `bestelregels` VALUES (10,1,10,99.95,NULL);
INSERT INTO `bestelregels` VALUES (10,9,9,1799.55,NULL);

-- maak tabel `facturen`
CREATE TABLE `facturen` (
	`factuur_id` int(10) NOT NULL AUTO_INCREMENT,
    `klant_id` int(10) NOT NULL,
    `factuur_bedrag` decimal(9,2) NOT NULL,
    `betaald_bedrag` decimal(9,2) NOT NULL DEFAULT '0.00',
    `factuur_datum` date NOT NULL,
    `opleverings_datum` date NOT NULL,
    `betaal_datum` date NULL,
    PRIMARY KEY (`factuur_id`),
    KEY `fk_klant_id` (`klant_id`),
    CONSTRAINT `fk_klant_id` FOREIGN KEY (`klant_id`) REFERENCES `klanten` (`klant_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `facturen` VALUES (1,2,99.95,DEFAULT,'2022-03-09','2022-03-29',NULL);
INSERT INTO `facturen` VALUES (2,5,175.80,75.80,'2022-02-02','2022-02-20','2022-02-08');
INSERT INTO `facturen` VALUES (3,5,147.99,DEFAULT,'2022-03-10','2022-03-29',NULL);
INSERT INTO `facturen` VALUES (4,3,152.21,50.00,'2021-10-08','2021-10-28',NULL);
INSERT INTO `facturen` VALUES (5,5,169.36,100.00,'2021-07-18','2021-08-01',NULL);
INSERT INTO `facturen` VALUES (6,1,157.78,DEFAULT,'2021-09-29','2021-10-18','2021-10-09');
INSERT INTO `facturen` VALUES (7,3,133.87,DEFAULT,'2021-11-04','2021-11-28',NULL);
INSERT INTO `facturen` VALUES (8,10,189.12,DEFAULT,'2021-07-20','2021-08-10',NULL);
INSERT INTO `facturen` VALUES (9,8,172.17,DEFAULT,'2021-12-09','2022-01-01',NULL);
INSERT INTO `facturen` VALUES (10,1,159.50,85.00,'2021-06-30','2021-07-15','2021-07-10');

-- maak tabel `betalingen`
CREATE TABLE `betalingen` (
	`betaal_id` int(10) NOT NULL AUTO_INCREMENT,
    `klant_id` int(10) NOT NULL,
    `factuur_id` int(10) NOT NULL,
    `betaal_datum` date NOT NULL,
    `bedrag` decimal(9,2) NOT NULL,
    `betaal_methode` varchar(50) NOT NULL,
    PRIMARY KEY (`betaal_id`),
    KEY `fk_betalingen_klanten_idx` (`klant_id`),
    KEY `fk_betalingen_facturen_idx` (`factuur_id`),
    CONSTRAINT `fk_betaling_klant` FOREIGN KEY (`klant_id`) REFERENCES `klanten` (`klant_id`) ON UPDATE CASCADE,
	CONSTRAINT `fk_betaling_factuur` FOREIGN KEY (`factuur_id`) REFERENCES `facturen` (`factuur_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7;
INSERT INTO `betalingen` VALUES (1,5,2,'2021-02-12',120.50,'Creditcard');
INSERT INTO `betalingen` VALUES (2,1,6,'2022-01-03',149.89,'Cash');
INSERT INTO `betalingen` VALUES (3,3,5,'2021-01-11',229.50,'Paypal');
INSERT INTO `betalingen` VALUES (4,5,3,'2020-12-27',87.95,'Ideal');
INSERT INTO `betalingen` VALUES (5,3,4,'2021-01-15',110.88,'Creditcard');
INSERT INTO `betalingen` VALUES (6,4,1,'2021-05-15',45.90,'Paypal');

