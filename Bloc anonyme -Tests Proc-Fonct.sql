/*------------------------------Test de la procédure NEW_MEMBER : -----------------------------*/
--Insertion :

begin

gestion_pret.new_member ('Idir', 'Lyazid', '283 King Street', 'Montreal', '587-99-6666');
EXCEPTION
    	WHEN gestion_exception.insert_except THEN
		  DBMS_OUTPUT.PUT_LINE('Valeur null Interdite!');     
      WHEN gestion_exception.insert_doublon THEN
		  DBMS_OUTPUT.PUT_LINE('Doublon interdit!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'new_member');
end;

---Résultat:
Insertion effectuée.
Nouveau membre ajouté avec succès. ID du membre : 122

--Insertion avec last_name = null: 
begin

gestion_pret.new_member (null, 'Lyazid', '283 King Street', 'Montreal', '587-99-6666');
EXCEPTION
    	WHEN gestion_exception.insert_except THEN
		  DBMS_OUTPUT.PUT_LINE('Valeur null Interdite!');     
      WHEN gestion_exception.insert_doublon THEN
		  DBMS_OUTPUT.PUT_LINE('Doublon interdit!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'new_member');
end;

--Résultat: Valeur null Interdite!

--Insertion d'un doublon last_name et first_name existent:

begin

gestion_pret.new_member ('Idir', 'Lyazid', '283 King Street', 'Montreal', '587-99-6666');
EXCEPTION
    	WHEN gestion_exception.insert_except THEN
		  DBMS_OUTPUT.PUT_LINE('Valeur null Interdite!');     
      WHEN gestion_exception.insert_doublon THEN
		  DBMS_OUTPUT.PUT_LINE('Doublon interdit!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'new_member');
end;

----Résultat: Doublon interdit!

/*------------------------------Test de la procédure NEW_RENTAL : -----------------------------*/

---Insertion de New_rental

declare 
  v_title_id RENTAL.TITLE_ID%type;  
  v_member_id RENTAL.MEMBER_ID%type;
  v_date_retour date; --RENTAL.EXP_RET_DATE%type;
  p_date RENTAL.EXP_RET_DATE%type;
  
begin 
  v_title_id := 92;
  v_member_id := 105;  

  select title_id into v_title_id from title where title_id =  v_title_id;
  select member_id into v_member_id from member where member_id =  v_member_id;
  
  v_date_retour := gestion_pret.new_rental( v_title_id, v_member_id, v_date_retour);
  DBMS_OUTPUT.PUT_LINE(v_date_retour);
  if v_date_retour <> sysdate then
    DBMS_OUTPUT.PUT_LINE('Le prêt a été enregistré, la date de retour est le : '|| v_date_retour);
  else
      DBMS_OUTPUT.PUT_LINE('Le titre est indisponible');
  end if;  
exception 
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Numéro de titre ou de membre introuvable!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'new_rental');
end;


---Résultat: 
Insertion effectuée.
23-07-31
Le prêt a été enregistré, la date de retour est le : 23-07-31

---Insertion avec un numéro de titre ou de membre inéxistant :

--Résultat : 
Numéro de titre ou de membre introuvable!

--Insertion du même prêt données 92, 105:
---Résultat :
Le titre est indisponible


/*------------------------------Test de la procédure RETURN_TITLE : -----------------------------*/


begin

gestion_pret.return_title(96, 1, 'RENTED');
exception 
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('La copie n''existe pas!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'return_title');
        
end; 

--Test de mise a jour d'une copie qui n'existe pas:

begin

gestion_pret.return_title(96, 5, 'RENTED');
exception 
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('La copie n''existe pas!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'return_title');
        
end; 

--Résulat: La copie n'existe pas!



/*------------------------------Test de la procédure RESERVE_TITLE: -----------------------------*/

begin

gestion_pret.reserver_title(108, 97);

exception 
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Membre ou titre introuvable!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'reserver_title');

end;

--Résultat : Impossible de réserver le titre. Toutes les copies ne sont pas en statut "RENTED".

begin
 gestion_pret.reserver_title(123, 67);

end;

--Member_id et/ou title_id inéxistant
--Résultat: Aucune copie n'est trouvée pour le titre spécifié!. Impossible de réserver!

---Réservation avec succés:
begin
 gestion_pret.reserver_title(107, 96);

end;

Résultat: Titre réservé avec succès. Date de retour prévue : 01-AOÛT -2023

/*----------------------Test fonction calcul du nombre des retards pour un membre : -----------------------------*/

begin
--Calculer le nombre de retards pour un membre

dbms_output.put_line('Nombre des retards pour ce Membre est :' ||gestion_pret.calcul_retard(108)||' fois');
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Le membre n''existe pas!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'calcul_retard');
end;

Nombre des retards pour ce Membre est :2 fois


begin
--Calculer le nombre de retards pour un membre

dbms_output.put_line('Nombre des retards pour ce Membre est :' ||gestion_pret.calcul_retard(129)||' fois');
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Le membre n''existe pas!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'calcul_retard');
end;

--Résultat : Le membre n'existe pas!


/*----------------------Test de la procédure de recherches des n premier titres les plus louées : ---------------------*/

begin
--Afficher les n premier titres les plus loués.
gestion_pret.titres_plus_loues(3);
end;

--Résultat:
Titre: 95 - Nombre d'emprunts pour ce titre : 4
Titre: 94 - Nombre d'emprunts pour ce titre : 2
Titre: 93 - Nombre d'emprunts pour ce titre : 1

---Suppression d'un membre: 

begin
--Suppression d'un membre, ses emprunts et ses reservation
gestion_pret.del_member(111);
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Le membre n''existe pas!');
	WHEN OTHERS THEN
    	exception_handler(SQLCODE, 'del_member');
      
end;

Résultat : Suppression effectuée.








