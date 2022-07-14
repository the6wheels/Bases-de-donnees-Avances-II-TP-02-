CREATE OR REPLACE TYPE Tel AS VARRAY(3) OF VARCHAR2(25);
/

CREATE OR REPLACE TYPE Ville_t AS OBJECT(Nom VARCHAR(20), 
										 CP NUMBER(6));
/


CREATE OR REPLACE TYPE Adresse_t AS OBJECT(Numero NUMBER(6),
										   Rue varchar(50),
							   			   Ville Ville_t);
/
	

CREATE OR REPLACE TYPE Fonction_t AS OBJECT(Fnom VARCHAR(20));
/
						  
							   
CREATE OR REPLACE TYPE Enfants_t AS OBJECT (
                                           Nom    VARCHAR(30),
                                           Prenom VARCHAR(20),
                                           Age    NUMBER);
/


CREATE TYPE Enfants_tab IS TABLE OF Enfants_t;
/						
		
					  
CREATE OR REPLACE TYPE PERSONNE_t AS OBJECT(ID NUMBER,
										   Nom VARCHAR(20),
										   Prenom VARCHAR(20),
										   Adresse Adresse_t,
										   Telephone Tel,
                                           Enfants Enfants_tab,
                                           Fonction Fonction_t)
										   NOT FINAL;
/
							   
							  

CREATE TABLE Enfants OF Enfants_t;


CREATE TABLE Ville OF Ville_t;


CREATE TABLE Fonction OF Fonction_t;


CREATE TABLE Adresse OF Adresse_t;


CREATE TABLE PERSONNE OF PERSONNE_t(PRIMARY KEY (ID))
NESTED TABLE Enfants STORE AS People_Enfants;





DESC Ville;
DESC Adresse;
DESC Fonction;
DESC Enfants;
DESC PERSONNE;

SELECT * FROM user_types;




INSERT INTO PERSONNE(ID, Nom, Prenom, Adresse, Telephone, Fonction, Enfants) 
VALUES ( 215712, 'AMMAR', 'Ahmed', Adresse_t(15, 'rue Khemisti', Ville_t('Oran', 31000)), Tel('077673516233', '099673516355'), Fonction_t('comptable'), Enfants_tab(
              Enfants_t('AMMAR', 'Amel', 10),
              Enfants_t('AMMAR', 'Reda', 15),
              Enfants_t('AMMAR', 'Amina', 20)
            )
);


select * from PERSONNE;


update table(select p.ENFANTS from PERSONNE p) e
set e.age = 99 where e.prenom = 'Amel';


UPDATE TABLE (
      SELECT ENFANTS FROM PERSONNE WHERE id = 215712
    ) e
    SET
      VALUE(e) = Enfants_t(
        'AMMAR', 'Ali', 19
      )
    WHERE
      VALUE(e) = Enfants_t(
       'AMMAR', 'Amel', 10
     );



SELECT p.nom, p.prenom, MIN(e.age) 
FROM PERSONNE p , table(p.ENFANTS) e 
WHERE p.ID = 215712 GROUP BY p.nom, p.PRENOM ;



select p.ID , p.NOM , p.PRENOM, ENFANTS_count
from   PERSONNE p outer apply (select count(*) 
as ENFANTS_count from table(p.ENFANTS)) n;



