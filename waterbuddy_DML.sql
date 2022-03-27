-- Waterbuddy DML 

-- VIEW voor Aflossingen
USE waterbuddy_store;

CREATE OR REPLACE VIEW Aflossingen AS
SELECT 
    k.klant_id,
    k.voornaam,
    f.factuur_bedrag,
    f.betaald_bedrag,
    SUM(factuur_bedrag - betaald_bedrag) AS totaal_openstaand
FROM klanten k
INNER JOIN facturen f USING(klant_id)
GROUP BY k.klant_id, k.voornaam, f.factuur_bedrag, f.betaald_bedrag;


-- VIEW voor lijst van onze top klanten
CREATE OR REPLACE VIEW topklanten AS 
SELECT 
    klant_id,
    voornaam,
    'Brons' AS Type
FROM klanten
WHERE punten < 2000
UNION
SELECT 
    klant_id,
    voornaam,
    'Zilver' AS Type
FROM klanten
WHERE punten BETWEEN 2000 AND 3000
UNION
SELECT 
    klant_id,
    voornaam,
    'Goud' AS Type
FROM klanten
WHERE punten > 3000
ORDER BY voornaam;


-- VIEW voor Medewerker genereert rapport totale omzet van 2021

CREATE OR REPLACE VIEW Jaaromzet_2021 AS
SELECT 
    'eerste 6 maanden van 2021' AS datum_lengte,
    SUM(factuur_bedrag) AS totaal_verkopen,
    SUM(betaald_bedrag) AS totaal_betaald,
    SUM(factuur_bedrag - betaald_bedrag) AS verwachting
FROM facturen
WHERE factuur_datum BETWEEN '2021-01-01' AND '2021-06-30'
UNION
SELECT 
    'tweede 6 maanden van 2021' AS datum_lengte,
    SUM(factuur_bedrag) AS totaal_verkopen,
    SUM(betaald_bedrag) AS totaal_betaald,
    SUM(factuur_bedrag - betaald_bedrag) AS verwachting
FROM facturen
WHERE factuur_datum BETWEEN '2021-07-01' AND '2021-12-31'
UNION
SELECT 
    'totaal' AS datum_lengte,
    SUM(factuur_bedrag) AS totaal_verkopen,
    SUM(betaald_bedrag) AS totaal_betaald,
    SUM(factuur_bedrag - betaald_bedrag) AS verwachting
FROM facturen
WHERE factuur_datum BETWEEN '2021-01-01' AND '2021-12-31';


-- STORED PROCEDURE waarbij klant een betaling doet en deze 
-- wordt geregistreerd in het systeem.

DROP PROCEDURE IF EXISTS betaal_transactie;

DELIMITER $$
CREATE PROCEDURE betaal_transactie(factuur_id INT, totaal_bedrag DECIMAL(9,2), betaal_datum DATE)
BEGIN
    UPDATE facturen f
    SET 
        f.betaald_bedrag = totaal_bedrag,
        f.betaal_datum = betaal_datum
    WHERE f.factuur_id = factuur_id;
END$$

DELIMITER ;


-- STORED_PROCEDURE get_betalingen met 2 parameter inputs

DROP PROCEDURE IF EXISTS get_betalingen;

DELIMITER $$
CREATE PROCEDURE get_betalingen(klant_id INT, betaal_methode VARCHAR(50))
BEGIN
    SELECT *
    FROM betalingen b
    WHERE b.klant_id = IFNULL(klant_id, b.klant_id) 
        AND b.betaal_methode = IFNULL(betaal_methode, b.betaal_methode); 
END$$

DELIMITER ;




-- functie voor berekenen van het btw bedrag
-- van het totale factuurbedrag van een klant

USE waterbuddy_store;

DROP FUNCTION IF EXISTS btw;

DELIMITER $$
CREATE FUNCTION btw(klant_id INT)
RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE btw_bedrag decimal(9,2);
    DECLARE totaalBedrag decimal(9,2);
    
    SELECT SUM(factuur_bedrag)
    INTO totaalBedrag
    FROM facturen f
    WHERE f.klant_id = klant_id;
    
    SET btw_bedrag = (totaalBedrag / 100) * 21;

    RETURN btw_bedrag;
END$$

DELIMITER ;




-- TRIGGER voor verwerken van betaling door klant

DROP TRIGGER IF EXISTS betaal_verwerking

DELIMITER $$
CREATE TRIGGER betaal_verwerking AFTER INSERT ON betalingen FOR EACH ROW
BEGIN
    UPDATE facturen
    SET betaald_bedrag = betaald_bedrag + NEW.bedrag
    WHERE factuur_id = NEW.factuur_id;
END$$

DELIMITER ;



-- TRIGGER voor verwijderen uit betalingen tabel.

DELIMITER $$
CREATE TRIGGER betaal_verwerking_verwijderen AFTER DELETE ON betalingen FOR EACH ROW
BEGIN
    UPDATE facturen
    SET betaald_bedrag = betaald_bedrag - OLD.bedrag
    WHERE factuur_id = OLD.factuur_id;
END$$

DELIMITER ;



-- Klant met ID 1 kan zijn persoonlijke gegevens wijzigen.
-- de wijziging wordt opgeslagen door middel van de volgende query:

UPDATE klanten
SET
	voornaam = 'Huseyin',
    achternaam = 'Tufekci',
    geboorte_datum = '1989-12-05',
    telefoon = '0644189912',
    email = 'h.tufekci@avans.nl',
    adres = 'heiligeweg 9',
    plaats = 'Amsterdam',
    wachtwoord = 'hu123'
WHERE klant_id = 1;

-- de klant kan de gewijzigde gegevens inzien door op de knop profiel te klikken.
-- vervolgens wordt de volgende query uitgevoerd:

SELECT *
FROM klanten
WHERE klant_id = 1;





-- Medewerkers kunnen een rapport genereren vanuit de facturentabel.
SELECT 
	klant_id, 
    voornaam,
    (SELECT SUM(factuur_bedrag) 
     FROM facturen WHERE klant_id = k.klant_id) AS totaal_verkoop, 
     (SELECT AVG(factuur_bedrag) FROM facturen) AS gemiddelde,
      (SELECT totaal_verkoop - gemiddelde) AS verschil
FROM klanten k;



-- Geef 20% korting aan gold klanten die meer dan 3000 punten hebben
SELECT
    k.klant_id,
    b.bestel_id,
    k.voornaam,
    k.achternaam,
    br.prijs,
    (br.prijs * 0.2) AS korting
FROM klanten k
INNER JOIN bestellingen b USING(klant_id)
INNER JOIN bestelregels br USING(bestel_id)
WHERE k.punten > 3000
GROUP BY k.klant_id, b.bestel_id, k.voornaam, k.achternaam, br.prijs;



-- implementatie klant plaatst bestelling
USE waterbuddy_store;

INSERT INTO bestellingen
VALUES 	(DEFAULT, 4, '2022-03-20', 'verwerkt', NULL, 1, 5),
		(DEFAULT, 5, '2022-02-27', 'verzonden', NULL, 1, 4);



-- beheerder verwijdert klantaccount uit de database

DELETE FROM klanten
WHERE klant_id = (
        SELECT klant_id
        FROM klanten
        WHERE voornaam = 'roos'    -- (check 'roos' klant of medewerker?)
);



-- zoek medewerkers aan wie zij rapporteren en de rij 
-- voor de manager zelf die aan niemand rapporteert bijv: de CEO

SELECT 
    m.medewerker_id,
    m.voornaam,
    l.voornaam AS Manager
FROM medewerkers m
LEFT JOIN medewerkers l 
    ON m.rapporteert_aan = l.medewerker_id







