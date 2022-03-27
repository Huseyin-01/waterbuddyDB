-- Waterbuddy DCL 

-- gebruikersaccount beheerder wordt aangemaakt met ww en rechten

CREATE USER beheerder IDENTIFIED BY 'beheerderww';
GRANT ALL ON *.* TO beheerder WITH GRANT OPTION;


-- gebruikersaccount medewerker wordt aangemaakt met ww en rechten

CREATE USER medewerker IDENTIFIED BY 'medewerkerww';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON waterbuddy_store.* TO medewerker;


-- gebruikersaccount klant wordt aangemaakt met ww en rechten

CREATE USER klant IDENTIFIED BY 'klantww';
GRANT 
	SELECT,
    UPDATE (
		voornaam, achternaam, geboorte_datum,
        telefoon, email, adres, plaats, wachtwoord)
ON waterbuddy_store.klanten
TO klant;

-- hiermee kunnen klanten hun facturen en bestellingen
-- inzien maar niet wijzigen

GRANT SELECT ON waterbuddy_store.facturen TO klant;
GRANT SELECT ON waterbuddy_store.bestellingen TO klant;




        
        
        
        
        
