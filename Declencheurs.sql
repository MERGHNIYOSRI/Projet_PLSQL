/*------------------------------------Déclencheur pour auditer la table MEMBER ----------------------------*/

CREATE OR REPLACE TRIGGER AUDIT_MEMBER 
AFTER INSERT OR DELETE OR UPDATE ON MEMBER 

declare msg varchar2(50);
BEGIN
 if inserting then
    DBMS_OUTPUT.PUT_LINE('Insertion effectuée.');
    msg := 'Insertion effectuée.';
 elsif updating then
    DBMS_OUTPUT.PUT_LINE('Mise a jour effectuée.');
     msg := 'Mise a jour effectuée.';
  else
    DBMS_OUTPUT.PUT_LINE('Suppression effectuée.');
    msg := 'Suppression effectuée.';
  end if;
  
  insert into journal(utilisateur, operation, dateop) values (user, msg, to_char(sysdate, 'dd-mm-yyyy') ); 
END;

/*---------------Test----------------*/

Suppression: 

begin

gestion_pret.del_member(111);

 EXCEPTION
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'calcul_retard');
end;

111	Test	Velasquez	283 King Street	Seattle	587-99-6666	23-07-15

Suppression effectuée.

/*------------------------Contrôle des dates dans la table RENTAL: ------------------------------------------*/ 

CREATE OR REPLACE TRIGGER ctrl_date 
BEFORE INSERT OR UPDATE ON RENTAL
FOR EACH ROW
DECLARE 
  
BEGIN
  IF TO_DATE(:new.EXP_RET_DATE, 'yy-mm-dd') < TO_DATE(:new.ACT_RET_DATE, 'yy-mm-dd') THEN
    RAISE_APPLICATION_ERROR(-20100, 'La date de retour doit être supérieure à la date de prêt.');
  END IF;
END;

/*---------------Test----------------*/

begin
update rental set EXP_RET_DATE = to_date('23-07-20', 'yy-mm-dd') where member_id = 105 and title_id = 93 and copy_id = 2;
EXCEPTION
    	WHEN gestion_exception.invalid_date THEN
		  DBMS_OUTPUT.PUT_LINE('La date de retour doit être supérieure à la date de prêt.!');     
end;

---Résultat : La date de retour doit être supérieure à la date de prêt.!


/*--------------------------------Auditer la table RENTAL:: ------------------------------------------*/ 

create or replace
TRIGGER TRIG_RENTAL 
AFTER INSERT OR DELETE OR UPDATE ON RENTAL 
FOR EACH ROW 
declare msg varchar2(50);
BEGIN
 if inserting then
    DBMS_OUTPUT.PUT_LINE('Insertion effectuée.');
    msg := 'Insertion effectuée.';
 elsif updating then
    DBMS_OUTPUT.PUT_LINE('Mise a jour effectuée.');
     msg := 'Mise a jour effectuée.';
  else
    DBMS_OUTPUT.PUT_LINE('Suppression effectuée.');
    msg := 'Suppression effectuée.';
  end if;
  
  insert into journal(utilisateur, operation, dateop) values (user, msg, to_char(sysdate, 'dd-mm-yyyy') ); 
END;


/*---------------Test----------------*/

Insertion effectuée.
23-08-02
Le prêt a été enregistré, la date de retour est le : 23-08-02

Table journal: SCOTT	Insertion effectuée.	30-07-2023