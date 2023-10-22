create or replace
PACKAGE GESTION_EXCEPTION AS 

insert_except EXCEPTION; 
PRAGMA EXCEPTION_INIT (insert_except,-01400);

insert_doublon EXCEPTION; 
PRAGMA EXCEPTION_INIT (insert_doublon,-20201);

invalid_reservation EXCEPTION; 
PRAGMA EXCEPTION_INIT (invalid_reservation,-20001);

invalid_rental EXCEPTION; 
PRAGMA EXCEPTION_INIT (invalid_reservation,-20002);
 
END GESTION_EXCEPTION;