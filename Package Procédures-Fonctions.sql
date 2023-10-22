create or replace
PACKAGE GESTION_PRET AS 

/*-------------Procédure new_member publique qui ajoute un nouveau membre à la table membres -------------------*/

PROCEDURE new_member(p_last_name member.last_name%type, p_first_name member.first_name%type, p_address member.address%type, p_city member.city%type, p_phone member.phone%type);

/*-----------------Fonction publique surchargée pour enregistrer une nouvelle location -----------------------*/

FUNCTION NEW_RENTAL(P_TITLE_ID IN RENTAL.TITLE_ID%type, P_MEMBER_ID IN RENTAL.MEMBER_ID%type, DATE_RETOUR OUT RENTAL.EXP_RET_DATE%type) RETURN DATE;

/*-----------------Procédure qui met a jour le statut d'un titre dans la table title_copy -----------------------*/

PROCEDURE RETURN_TITLE(p_title_id title_copy.title_id%type, p_copy_id title_copy.copy_id%TYPE, p_status title_copy.status%TYPE);

/*--------------Procédure pour effectuer une reservation si toutes les copies demandées dans la procédure new_rental ont un statut de RENTED------------------*/

PROCEDURE reserver_title(p_member_id reservation.member_id%type, p_title_id reservation.title_id%type);

/*----------------Fonction qui retourne le nombre de retards par client Member -------------------*/

FUNCTION calcul_retard(p_member_id   number) RETURN NUMBER ;

/*---------------Procédure qui calcul le N premier titre ayant plus d'emprunt (N comme parametre) exemple les 5 premier title les plus empruntés :-----------*/

PROCEDURE titres_plus_loues( p_nombre_titres number);

/*-----------------Procédure qui recherche et retourne le client Member ayant effectué le plus de location :--------------------*/

PROCEDURE rech_member_ayant_plus_emprunt;

/*--------------------procédure exeption_handler privée qui sera appelée à partir des procédures publiques :--------------------*/

PROCEDURE exception_handler( p_sqlcode number, p_ProcFct_name varchar2);

/*-----------------------Proédures gérées automatiquement :--------------------*/
 
PROCEDURE upd_member
  (
    p_PHONE      IN MEMBER.PHONE%type ,
    p_JOIN_DATE  IN MEMBER.JOIN_DATE%type ,
    p_FIRST_NAME IN MEMBER.FIRST_NAME%type ,
    p_ADDRESS    IN MEMBER.ADDRESS%type ,
    p_CITY       IN MEMBER.CITY%type ,
    p_LAST_NAME  IN MEMBER.LAST_NAME%type ,
    p_MEMBER_ID  IN MEMBER.MEMBER_ID%type
  );
  -- delete
  PROCEDURE del_member( p_MEMBER_ID IN MEMBER.MEMBER_ID%type );

--Rental
  -- update
  PROCEDURE upd_rental(
      p_TITLE_ID     IN RENTAL.TITLE_ID%type ,
      p_COPY_ID      IN RENTAL.COPY_ID%type ,
      p_EXP_RET_DATE IN RENTAL.EXP_RET_DATE%type DEFAULT NULL ,
      p_BOOK_DATE    IN RENTAL.BOOK_DATE%type ,
      p_ACT_RET_DATE IN RENTAL.ACT_RET_DATE%type DEFAULT NULL ,
      p_MEMBER_ID    IN RENTAL.MEMBER_ID%type );
  -- delete
  PROCEDURE del_rental(
      p_BOOK_DATE IN RENTAL.BOOK_DATE%type ,
      p_COPY_ID   IN RENTAL.COPY_ID%type ,
      p_TITLE_ID  IN RENTAL.TITLE_ID%type ,
      p_MEMBER_ID IN RENTAL.MEMBER_ID%type );


END GESTION_PRET;