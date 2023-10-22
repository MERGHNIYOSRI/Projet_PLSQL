create or replace
PACKAGE BODY GESTION_PRET AS

/*-------------Procédure new_member publique qui ajoute un nouveau membre à la table membres -------------------*/
PROCEDURE new_member(
    p_last_name member.last_name%type,
    p_first_name member.first_name%type,
    p_address member.address%type,
    p_city member.city%type,
    p_phone member.phone%type
) AS
    v_member_id number;
    v_last_name member.last_name%type;
    v_first_name member.first_name%type;
    cursor doub is select member_id into v_member_id from member where last_name = p_last_name and first_name = p_first_name;
  
BEGIN
    
    -- Vérification de duplication d'un member
    open doub;  
    fetch doub into v_member_id;
    if v_member_id is not null then 
      raise_application_error(-20201, 'Le nouveau nouveau membre existe déja!!');
    else
    -- Utiliser la séquence MEMBER_ID_SEQ pour générer un nouvel ID de membre
    select MEMBER_ID_SEQ.NEXTVAL into v_member_id from DUAL;
    
    -- Insérer une nouvelle ligne dans la table MEMBER
    insert into member (member_id, last_name, first_name, address, city, phone, join_date)
    values (v_member_id, p_last_name, p_first_name, p_address, p_city, p_phone, SYSDATE);

    DBMS_OUTPUT.PUT_LINE('Nouveau membre ajouté avec succès. ID du membre : ' || v_member_id);
    commit;
    end if;

END;


/*-----------------Fonction publique surchargée pour enregistrer une nouvelle location -----------------------*/

FUNCTION NEW_RENTAL 
(
  P_TITLE_ID  RENTAL.TITLE_ID%type  
, P_MEMBER_ID  RENTAL.MEMBER_ID%type  
, DATE_RETOUR out RENTAL.EXP_RET_DATE%type  
) return date AS 

  v_title_id RENTAL.TITLE_ID%type;  
  v_member_id RENTAL.MEMBER_ID%type;
  v_status title_copy.status%type;
  v_copy_id title_copy.copy_id%type;
  trouve boolean := false;

BEGIN
  
  select title_id into v_title_id from title where title_id =  P_TITLE_ID;
  select member_id into v_member_id from member where member_id =  P_MEMBER_ID;
  
  -- Utilisation d'une boucle FOR pour traiter plusieurs lignes renvoyées par la requête
  for c in (select copy_id, status from title_copy where title_id = v_title_id) loop
    v_copy_id := c.copy_id;
    v_status := c.status;
    
    if (v_status = 'AVAILABLE' and not trouve) then
      insert into RENTAL
      (
        TITLE_ID ,
        COPY_ID ,
        EXP_RET_DATE ,
        BOOK_DATE ,
        ACT_RET_DATE ,
        MEMBER_ID
      )
      values
      (
        v_title_id ,
        v_copy_id ,
        sysdate+2,
        sysdate ,
        sysdate ,
        v_member_id
      );
      
      update TITLE_COPY set STATUS = 'RENTED' 
      where COPY_ID = v_copy_id and TITLE_ID = v_title_id;
      commit;
      DATE_RETOUR := sysdate+2; 
      
      trouve := true; -- Sortir de la boucle une fois qu'une copie touvée
    end if;
  end loop;
   if not trouve then
       DATE_RETOUR := null;
    end if;
 
  return DATE_RETOUR;  

END NEW_RENTAL;

/*-----------------Procédure qui met a jour le statut d'un titre dans la table title_copy -----------------------*/

PROCEDURE RETURN_TITLE(p_title_id title_copy.title_id%TYPE, p_copy_id title_copy.copy_id%TYPE, p_status title_copy.status%TYPE) AS 

nb_reserve number;
v_title_id reservation.title_id%type;

BEGIN
  --Calculer le nombre de reservation pour un titre donnée p_title_id
  select title_id into v_title_id 
  from reservation
  where title_id = p_title_id;
  
  select count(*) into nb_reserve 
  from reservation
  where title_id = p_title_id;
  
  if nb_reserve > 0 then
      DBMS_OUTPUT.PUT_LINE('Ce titre est déjà reservé!');
     --mise à jour de la table rental
  else 
    update rental 
    set act_ret_date = sysdate 
    where title_id = p_title_id and copy_id = p_copy_id; 

    -- mise à jour du statut dans la table title_copy
    update title_copy 
    set status = p_status
    where title_id = p_title_id and copy_id = p_copy_id;

    DBMS_OUTPUT.PUT_LINE('Le Statut de la copie à été mis jour à : ' || p_status);
    end if;

END RETURN_TITLE;

/*--------------Procédure pour effectuer une reservation si toutes les copies demandées dans la procédure new_rental ont un statut de RENTED------------------*/

PROCEDURE reserver_title(
    p_member_id reservation.member_id%type,
    p_title_id reservation.title_id%type
) AS
    v_rented_copies number;
    v_member_id member.member_id%type;
    v_title_id title.title_id%type;
BEGIN
    -- Vérifier si toutes les copies du titre sont en statut "RENTED"
    
    select member_id into v_member_id from member where member_id = p_member_id;
    select title_id into v_title_id from title where title_id = p_title_id;
    
    select count(*) into v_rented_copies
    from title_copy 
    where title_id = p_title_id and status <> 'RENTED';

    if v_rented_copies > 0 then
        DBMS_OUTPUT.PUT_LINE('Impossible de réserver le titre. Toutes les copies ne sont pas en statut "RENTED".');
    else
    -- Insérer un nouvel enregistrement dans la table RESERVATION avec la date de réservation
    insert into reservation (res_date, member_id, title_id)
    values (sysdate, p_member_id, p_title_id);

    DBMS_OUTPUT.PUT_LINE('Titre réservé avec succès. Date de retour prévue : ' || TO_CHAR(sysdate + 2, 'DD-MON-YYYY'));
    
    end if;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucune copie n''est trouvée pour le titre spécifié!. Impossible de réserver!');
    WHEN OTHERS THEN
        exception_handler(SQLCODE, 'reserver_title');
END;

/*----------------Fonction qui retourne le nombre de retards par client Member -------------------*/

FUNCTION calcul_retard(
    p_member_id   number
) return number IS
    v_retard number := 0;
    v_member_id member.member_id%type;
begin
    select member_id into v_member_id from member where member_id = p_member_id;
    select  count(*) into v_retard from rental 
    where sysdate > EXP_RET_DATE and member_id = p_member_id;

    return v_retard;
END;

/*---------------Procédure qui calcul le N premier titre ayant plus d'emprunt (N comme parametre) exemple les 5 premier title les plus empruntés :-----------*/

PROCEDURE titres_plus_loues( p_nombre_titres number) AS

BEGIN
    -- Requête pour compter le nombre d'emprunts pour chaque titre  
    for titre_rec in (
       select * from (select title_id, count(*) as nombre_emprunts
        from rental 
        group by title_id
        order by count(*) desc) where rownum < p_nombre_titres
    ) loop
            DBMS_OUTPUT.PUT_LINE('Titre: '||titre_rec.title_id || ' - Nombre d''emprunts pour ce titre : ' || titre_rec.nombre_emprunts);
    end loop;
EXCEPTION
    WHEN OTHERS THEN
    exception_handler(SQLCODE, 'titres_plus_loues');
END;


/*-----------------Procédure qui recherche et retourne le client Member ayant effectué le plus de location :--------------------*/

PROCEDURE rech_member_ayant_plus_emprunt AS
    v_member_id member.member_id%type;
    v_member_name varchar2(60);
     v_rental_count number := 0;
begin
    -- Utiliser une requête pour compter le nombre de titres empruntés par chaque membre
    for member_rentals in (
        select member_id, count(distinct title_id) as rental_count
        from RENTAL
        group by member_id
        order by rental_count desc
    ) loop
        -- Sélectionner le membre avec le plus grand nombre de titres empruntés
        if member_rentals.rental_count > v_rental_count then
            v_member_id := member_rentals.member_id;
            v_rental_count := member_rentals.rental_count;
        end if;
    end loop;

    -- Récupérer le nom du membre
    select first_name || ' ' || last_name into v_member_name
    from member
    where member_id = v_member_id;

    -- Afficher le résultat
    DBMS_OUTPUT.PUT_LINE('Le membre qui a emprunté le plus de titres est : ' || v_member_name);
    DBMS_OUTPUT.PUT_LINE('Nombre de titres empruntés : ' || v_rental_count);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun membre trouvé dans la table RENTAL.');
    WHEN OTHERS THEN
    exception_handler(SQLCODE, 'rech_member_ayant_plus_emprunt');
END;


/*--------------------procédure exeption_handler privée qui sera appelée à partir des procédures publiques :--------------------*/

PROCEDURE exception_handler( p_sqlcode number, p_ProcFct_name varchar2) AS
BEGIN
    -- Gérer les erreurs spécifiques
    if p_sqlcode = 100 then -- NO_DATA_FOUND 1403
        -- Traitement NO_DATA_FOUND
        DBMS_OUTPUT.PUT_LINE('Aucune donnée n''est trouvée ' || 'p_ProcFct_name');
    elsif p_sqlcode = -1 then -- DUP_VAL_ON_INDEX enregistrement dupliqué
        -- Traitement DUP_VAL_ON_INDEX
        DBMS_OUTPUT.PUT_LINE('Violation de contrainte d''index unique ' || p_ProcFct_name);
    else
        -- Gérer toutes les autres erreurs non spécifiées
        DBMS_OUTPUT.PUT_LINE('Erreur non spécifique dans la procédure/fonction ' || p_ProcFct_name);
        -- Lever une exception personnalisée avec RAISE_APPLICATION_ERROR
        RAISE_APPLICATION_ERROR(-20001, 'Erreur non spécifique dans la procédure/fonction ' || p_ProcFct_name || ': SQLCODE=' || p_sqlcode);
    end if;
END exception_handler;


/*-------------------------Procédures générées automatiquement à toutes fins utiles :--------------------*/
-- update
PROCEDURE upd_member
  (
    p_PHONE      IN MEMBER.PHONE%type ,
    p_JOIN_DATE  IN MEMBER.JOIN_DATE%type ,
    p_FIRST_NAME IN MEMBER.FIRST_NAME%type ,
    p_ADDRESS    IN MEMBER.ADDRESS%type ,
    p_CITY       IN MEMBER.CITY%type ,
    p_LAST_NAME  IN MEMBER.LAST_NAME%type ,
    p_MEMBER_ID  IN MEMBER.MEMBER_ID%type
  )
IS
BEGIN
  UPDATE MEMBER
  SET PHONE       = p_PHONE ,
    JOIN_DATE     = p_JOIN_DATE ,
    FIRST_NAME    = p_FIRST_NAME ,
    ADDRESS       = p_ADDRESS ,
    CITY          = p_CITY ,
    LAST_NAME     = p_LAST_NAME
  WHERE MEMBER_ID = p_MEMBER_ID;
  
      EXCEPTION
    WHEN OTHERS THEN
        exception_handler(SQLCODE, 'upd_member');
END;
-- del
PROCEDURE del_member(
    p_MEMBER_ID IN MEMBER.MEMBER_ID%type )
IS

v_MEMBER_ID MEMBER.MEMBER_ID%type;
BEGIN
  select MEMBER_ID into v_MEMBER_ID from member WHERE MEMBER_ID = p_MEMBER_ID;
  DELETE FROM reservation WHERE MEMBER_ID = p_MEMBER_ID;
  DELETE FROM rental WHERE MEMBER_ID = p_MEMBER_ID;
  DELETE FROM MEMBER WHERE MEMBER_ID = p_MEMBER_ID;
 
END;

---Rental
-- update
PROCEDURE upd_rental
  (
    p_TITLE_ID     IN RENTAL.TITLE_ID%type ,
    p_COPY_ID      IN RENTAL.COPY_ID%type ,
    p_EXP_RET_DATE IN RENTAL.EXP_RET_DATE%type DEFAULT NULL ,
    p_BOOK_DATE    IN RENTAL.BOOK_DATE%type ,
    p_ACT_RET_DATE IN RENTAL.ACT_RET_DATE%type DEFAULT NULL ,
    p_MEMBER_ID    IN RENTAL.MEMBER_ID%type
  )
IS
BEGIN
  UPDATE RENTAL
  SET EXP_RET_DATE = p_EXP_RET_DATE ,
    ACT_RET_DATE   = p_ACT_RET_DATE
  WHERE BOOK_DATE  = p_BOOK_DATE
  AND COPY_ID      = p_COPY_ID
  AND TITLE_ID     = p_TITLE_ID
  AND MEMBER_ID    = p_MEMBER_ID;
  
  EXCEPTION
  WHEN OTHERS THEN
    exception_handler(SQLCODE, 'upd_rental');
  
END;
-- del
PROCEDURE del_rental(
    p_BOOK_DATE IN RENTAL.BOOK_DATE%type ,
    p_COPY_ID   IN RENTAL.COPY_ID%type ,
    p_TITLE_ID  IN RENTAL.TITLE_ID%type ,
    p_MEMBER_ID IN RENTAL.MEMBER_ID%type )
IS
BEGIN
  DELETE
  FROM RENTAL
  WHERE BOOK_DATE = p_BOOK_DATE
  AND COPY_ID     = p_COPY_ID
  AND TITLE_ID    = p_TITLE_ID
  AND MEMBER_ID   = p_MEMBER_ID;
  
  EXCEPTION
  WHEN OTHERS THEN
        exception_handler(SQLCODE, 'del_rental');
  
END;

END GESTION_PRET;