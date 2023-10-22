--------------------------------------------------------
--  Fichier créé - lundi-juillet-31-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table RENTAL
--------------------------------------------------------

  CREATE TABLE "SCOTT"."RENTAL" 
   (	"BOOK_DATE" DATE DEFAULT SYSDATE, 
	"COPY_ID" NUMBER(10,0), 
	"MEMBER_ID" NUMBER(10,0), 
	"TITLE_ID" NUMBER(10,0), 
	"ACT_RET_DATE" DATE, 
	"EXP_RET_DATE" DATE DEFAULT SYSDATE+2
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.RENTAL
SET DEFINE OFF;
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-31','RR-MM-DD'),'1','104','96',to_date('23-07-31','RR-MM-DD'),to_date('23-08-02','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-29','RR-MM-DD'),'2','108','95',to_date('23-07-20','RR-MM-DD'),to_date('23-07-27','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-29','RR-MM-DD'),'2','105','93',to_date('23-07-29','RR-MM-DD'),to_date('23-07-20','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-29','RR-MM-DD'),'1','105','92',to_date('23-07-29','RR-MM-DD'),to_date('23-07-31','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-30','RR-MM-DD'),'2','102','98',to_date('23-07-30','RR-MM-DD'),to_date('23-08-01','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-30','RR-MM-DD'),'3','108','95',to_date('23-07-24','RR-MM-DD'),to_date('23-07-29','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-30','RR-MM-DD'),'1','102','97',to_date('23-07-30','RR-MM-DD'),to_date('23-08-01','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-30','RR-MM-DD'),'1','106','94',to_date('23-07-30','RR-MM-DD'),to_date('23-08-01','RR-MM-DD'));
Insert into SCOTT.RENTAL (BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID,ACT_RET_DATE,EXP_RET_DATE) values (to_date('23-07-30','RR-MM-DD'),'1','106','95',to_date('23-07-30','RR-MM-DD'),to_date('23-08-01','RR-MM-DD'));
--------------------------------------------------------
--  DDL for Index RENTAL_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."RENTAL_ID_PK" ON "SCOTT"."RENTAL" ("BOOK_DATE", "COPY_ID", "TITLE_ID", "MEMBER_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table RENTAL
--------------------------------------------------------

  ALTER TABLE "SCOTT"."RENTAL" ADD CONSTRAINT "RENTAL_ID_PK" PRIMARY KEY ("BOOK_DATE", "COPY_ID", "TITLE_ID", "MEMBER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RENTAL
--------------------------------------------------------

  ALTER TABLE "SCOTT"."RENTAL" ADD CONSTRAINT "RENTAL_COPY_TITLE_ID_FK" FOREIGN KEY ("COPY_ID", "TITLE_ID")
	  REFERENCES "SCOTT"."TITLE_COPY" ("COPY_ID", "TITLE_ID") ENABLE;
 
  ALTER TABLE "SCOTT"."RENTAL" ADD CONSTRAINT "RENTAL_MBR_ID_FK" FOREIGN KEY ("MEMBER_ID")
	  REFERENCES "SCOTT"."MEMBER" ("MEMBER_ID") ENABLE;
--------------------------------------------------------
--  DDL for Trigger CTRL_DATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."CTRL_DATE" 
BEFORE INSERT OR UPDATE ON RENTAL
FOR EACH ROW
DECLARE 
  
BEGIN
  IF TO_DATE(:new.EXP_RET_DATE, 'yy-mm-dd') < TO_DATE(:new.ACT_RET_DATE, 'yy-mm-dd') THEN
    RAISE_APPLICATION_ERROR(-20100, 'La date de retour doit être supérieure à la date de prêt.');
  END IF;
END;
/
ALTER TRIGGER "SCOTT"."CTRL_DATE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIGGER1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."TRIGGER1" 
BEFORE INSERT OR UPDATE OF BOOK_DATE,COPY_ID,MEMBER_ID,TITLE_ID ON RENTAL 
BEGIN
  NULL;
END;
/
ALTER TRIGGER "SCOTT"."TRIGGER1" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_RENTAL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."TRIG_RENTAL" 
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
/
ALTER TRIGGER "SCOTT"."TRIG_RENTAL" ENABLE;

--------------------------------------------------------
--  Fichier créé - mardi-août-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table RESERVATION
--------------------------------------------------------

  CREATE TABLE "SCOTT"."RESERVATION" 
   (	"RES_DATE" DATE, 
	"MEMBER_ID" NUMBER(10,0), 
	"TITLE_ID" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.RESERVATION
SET DEFINE OFF;
Insert into SCOTT.RESERVATION (RES_DATE,MEMBER_ID,TITLE_ID) values (to_date('23-07-01','RR-MM-DD'),'103','95');
Insert into SCOTT.RESERVATION (RES_DATE,MEMBER_ID,TITLE_ID) values (to_date('23-07-29','RR-MM-DD'),'102','94');
Insert into SCOTT.RESERVATION (RES_DATE,MEMBER_ID,TITLE_ID) values (to_date('23-07-30','RR-MM-DD'),'107','96');
--------------------------------------------------------
--  DDL for Index RES_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."RES_ID_PK" ON "SCOTT"."RESERVATION" ("RES_DATE", "MEMBER_ID", "TITLE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table RESERVATION
--------------------------------------------------------

  ALTER TABLE "SCOTT"."RESERVATION" ADD CONSTRAINT "RES_ID_PK" PRIMARY KEY ("RES_DATE", "MEMBER_ID", "TITLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;

--------------------------------------------------------
--  Fichier créé - mardi-août-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TITLE_COPY
--------------------------------------------------------

  CREATE TABLE "SCOTT"."TITLE_COPY" 
   (	"COPY_ID" NUMBER(10,0), 
	"TITLE_ID" NUMBER(10,0), 
	"STATUS" VARCHAR2(15 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.TITLE_COPY
SET DEFINE OFF;
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','92','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('2','93','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','94','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','95','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('2','95','AVAILABLE');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('3','95','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','96','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','97','RENTED');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('1','98','AVAILABLE');
Insert into SCOTT.TITLE_COPY (COPY_ID,TITLE_ID,STATUS) values ('2','98','RENTED');
--------------------------------------------------------
--  DDL for Index COPY_TITLE_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."COPY_TITLE_ID_PK" ON "SCOTT"."TITLE_COPY" ("COPY_ID", "TITLE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table TITLE_COPY
--------------------------------------------------------

  ALTER TABLE "SCOTT"."TITLE_COPY" ADD CONSTRAINT "COPY_STATUS_CK" CHECK (status IN ('AVAILABLE', 'DESTROYED', 
						 'RENTED', 'RESERVED')) ENABLE;
 
  ALTER TABLE "SCOTT"."TITLE_COPY" MODIFY ("STATUS" CONSTRAINT "COPY_STATUS_NN" NOT NULL ENABLE);
 
  ALTER TABLE "SCOTT"."TITLE_COPY" ADD CONSTRAINT "COPY_TITLE_ID_PK" PRIMARY KEY ("COPY_ID", "TITLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TITLE_COPY
--------------------------------------------------------

  ALTER TABLE "SCOTT"."TITLE_COPY" ADD CONSTRAINT "COPY_TITLE_ID_FK" FOREIGN KEY ("TITLE_ID")
	  REFERENCES "SCOTT"."TITLE" ("TITLE_ID") ENABLE;

--------------------------------------------------------
--  Fichier créé - mardi-août-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TITLE
--------------------------------------------------------

  CREATE TABLE "SCOTT"."TITLE" 
   (	"TITLE_ID" NUMBER(10,0), 
	"TITLE" VARCHAR2(60 BYTE), 
	"DESCRIPTION" VARCHAR2(400 BYTE), 
	"RATING" VARCHAR2(4 BYTE), 
	"CATEGORY" VARCHAR2(20 BYTE) DEFAULT 'DRAMA', 
	"RELEASE_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.TITLE
SET DEFINE OFF;
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('92','Willie and Christmas Too','All of Willie''s friends made a Christmas list for Santa, but Willie has yet to create his own wish list.','G','CHILD',to_date('90-10-05','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('93','Alien Again','Another installment of science fiction history. Can the heroine save the planet from the alien life form?','R','SCIFI',to_date('95-05-19','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('94','The Glob','A meteor crashes near a small American town and unleashes carivorous goo in this classic.','NR','SCIFI',to_date('95-08-12','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('95','My Day Off','With a little luck and a lot of ingenuity, a teenager skips school for a day in New York.','PG','COMEDY',to_date('95-07-12','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('96','Miracles on Ice','A six-year-old has doubts about Santa Claus. But she discovers that miracles really do exist.','PG','DRAMA',to_date('95-09-12','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('97','Soda Gang','After discovering a cached of drugs, a young couple find themselves pitted against a vicious gang.','NR','ACTION',to_date('95-06-01','RR-MM-DD'));
Insert into SCOTT.TITLE (TITLE_ID,TITLE,DESCRIPTION,RATING,CATEGORY,RELEASE_DATE) values ('98','Interstellar Wars','Futuristic interstellar action movie. Can the rebels save the humans from the evil Empire?','PG','SCIFI',to_date('95-07-07','RR-MM-DD'));
--------------------------------------------------------
--  DDL for Index TITLE_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."TITLE_ID_PK" ON "SCOTT"."TITLE" ("TITLE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table TITLE
--------------------------------------------------------

  ALTER TABLE "SCOTT"."TITLE" ADD CONSTRAINT "TITLE_CATEG_CK" CHECK (category IN ('DRAMA','COMEDY','ACTION','CHILD','SCIFI','DOCUMENTARY')) ENABLE;
 
  ALTER TABLE "SCOTT"."TITLE" MODIFY ("DESCRIPTION" CONSTRAINT "TITLE_DESC_NN" NOT NULL ENABLE);
 
  ALTER TABLE "SCOTT"."TITLE" ADD CONSTRAINT "TITLE_ID_PK" PRIMARY KEY ("TITLE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "SCOTT"."TITLE" MODIFY ("TITLE" CONSTRAINT "TITLE_NN" NOT NULL ENABLE);
 
  ALTER TABLE "SCOTT"."TITLE" ADD CONSTRAINT "TITLE_RATING_CK" CHECK (rating IN ('G','PG','R','NC17','NR')) ENABLE;

--------------------------------------------------------
--  Fichier créé - mardi-août-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MEMBER
--------------------------------------------------------

  CREATE TABLE "SCOTT"."MEMBER" 
   (	"MEMBER_ID" NUMBER(10,0), 
	"LAST_NAME" VARCHAR2(25 BYTE), 
	"FIRST_NAME" VARCHAR2(25 BYTE), 
	"ADDRESS" VARCHAR2(100 BYTE), 
	"CITY" VARCHAR2(30 BYTE), 
	"PHONE" VARCHAR2(25 BYTE), 
	"JOIN_DATE" DATE DEFAULT SYSDATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.MEMBER
SET DEFINE OFF;
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('101','Velasquez','Carmen','283 King Street','Seattle','587-99-6666',to_date('90-03-03','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('102','Ngao','LaDoris','5 Modrany','Bratislava','586-355-8882',to_date('90-03-08','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('103','Nagayama','Midori','68 Via Centrale','Sao Paolo','254-852-5764',to_date('90-06-17','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('104','Quick-To-See','Mark','6921 King Way','Lagos','63-559-777',to_date('90-04-07','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('105','Ropeburn','Audry','86 Chu Street','Hong Kong','41-559-87',to_date('90-03-04','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('106','Urguhart','Molly','3035 Laurier Blvd.','Quebec','418-542-9988',to_date('91-01-18','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('107','Menchu','Roberta','Boulevard de Waterloo 41','Brussels','322-504-2228',to_date('90-05-14','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('108','Biri','Ben','398 High St.','Columbus','614-455-9863',to_date('90-04-07','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('122','Idir','Lyazid','283 King Street','Montreal','587-99-6666',to_date('23-07-29','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('109','Catchpole','Antoinette','88 Alfred St.','Brisbane','616-399-1411',to_date('90-02-09','RR-MM-DD'));
Insert into SCOTT.MEMBER (MEMBER_ID,LAST_NAME,FIRST_NAME,ADDRESS,CITY,PHONE,JOIN_DATE) values ('110','Carmen','Velasquez','283 King Street','Seattle','587-99-6666',to_date('23-07-15','RR-MM-DD'));
--------------------------------------------------------
--  DDL for Index MEMBER_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."MEMBER_ID_PK" ON "SCOTT"."MEMBER" ("MEMBER_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table MEMBER
--------------------------------------------------------

  ALTER TABLE "SCOTT"."MEMBER" MODIFY ("JOIN_DATE" CONSTRAINT "JOIN_DATE_NN" NOT NULL ENABLE);
 
  ALTER TABLE "SCOTT"."MEMBER" ADD CONSTRAINT "MEMBER_ID_PK" PRIMARY KEY ("MEMBER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "SCOTT"."MEMBER" MODIFY ("LAST_NAME" CONSTRAINT "MEMBER_LAST_NN" NOT NULL ENABLE);

--------------------------------------------------------
--  DDL for Trigger VERIF_DOUBLE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."VERIF_DOUBLE" 
BEFORE INSERT ON MEMBER 
FOR EACH ROW 
declare
v_last_name member.last_name%type;
v_first_name member.first_name%type;
BEGIN
  select last_name, first_name into v_last_name, v_first_name from member where last_name = :new.last_name and first_name = :new.first_name;
       
  if sql%found then 
      raise_application_error(-20201, 'Le nouveau nouveau membre existe déja!!');
  --else
     --dbms_output.put_line('Erreur  ' ||sqlerrm);
  end if;
END;
/
ALTER TRIGGER "SCOTT"."VERIF_DOUBLE" DISABLE;
--------------------------------------------------------
--  DDL for Trigger AUDIT_MEMBER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCOTT"."AUDIT_MEMBER" 
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
/
ALTER TRIGGER "SCOTT"."AUDIT_MEMBER" ENABLE;

--------------------------------------------------------
--  Fichier créé - mardi-août-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table JOURNAL
--------------------------------------------------------

  CREATE TABLE "SCOTT"."JOURNAL" 
   (	"UTILISATEUR" VARCHAR2(30 BYTE), 
	"OPERATION" VARCHAR2(255 BYTE), 
	"DATEOP" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into SCOTT.JOURNAL
SET DEFINE OFF;
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','31-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','31-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','31-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','31-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','31-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','28-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','07-28-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','28-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Suppression effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','29-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Mise a jour effectuée.','30-07-2023');
Insert into SCOTT.JOURNAL (UTILISATEUR,OPERATION,DATEOP) values ('SCOTT','Insertion effectuée.','30-07-2023');


