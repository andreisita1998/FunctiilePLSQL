create database testt;

create table utilizatori
(iduser int primary key auto_increment,
 prenume varchar(255),
 nume varchar(255),
 datanasterii date,
 loculnasterii varchar(255),
 email varchar(255),
 numeutilizator varchar(255),
 CV text,
 photo blob 
 );
 
 create table postari
 (id int primary key auto_increment,
  iduser int,
  titlu varchar(255),
  continut text,
  data date,
  foreign key (iduser) references utilizatori(iduser)
  );
  
  
  insert into utilizatori values(null, 'Sita', 'Andrei', '1998-09-15', 'Constanta', 'sita.andrei@yahoo.com', 'andsit1998', 'Am absolvit universitatea Ovidius', 'Capture.PNG');
  insert into utilizatori values(null, 'Bogdan', 'Maria', '1997-10-14', 'Bucuresti', 'bogdan.maria@yahoo.com', 'bogdanmaria1234', 'Am absolvit UNIBUC', 'Capture3.PNG');
  
  insert into postari values(null, 1, 'Cum am petrecut sfarsitul anului', 'La bunici cu petrecere', '2021-01-02');
  insert into postari values(null, 1, 'Cum a fost la meci', 'Foarte bine, chiar daca echipa a pierdut', '2023-02-28');
  
  insert into postari values(null, 2, 'Ce s-a intamplat aseara ?', 'A plouat torential', '2022-08-16');
  insert into postari values(null, 2, 'Cum a fost la film', 'Exceptional, ca niciodata in atatia ani', '2018-11-17');

  select* from utilizatori;
  select* from postari;

 insert into utilizatori values(null, 'Popa', 'Bogddan', '1999-04-16', 'Iasi', 'popabogdan@gmail.com', 'popabogdan2000', 'Am finalizat studiile Politehnicii', 'Capture4.PNG');

 create table prietenii
  (id int primary key auto_increment,
   user_1_id int,
   user_2_id int,
   prietenie enum('waiting', 'accepted', 'rejected'), 
   dataprieteniei date,
   foreign key (user_1_id) references utilizatori(iduser),
   foreign key (user_2_id) references utilizatori(iduser)
   );

 insert into prietenii values(null, 1,3,'accepted', '2023-01-01');
   insert into prietenii values(null, 1,2,'accepted', '2022-12-31');

select* from prietenii;

ALTER TABLE `testt`.`utilizatori` 
ADD INDEX `idx_name` (`nume` ASC, `prenume` ASC)
;

   ALTER TABLE `testt`.`utilizatori` 
ADD FULLTEXT INDEX `idx_cv` (`CV`)
;

   ALTER TABLE `testt`.`postari` 
ADD FULLTEXT INDEX `idx_postari` (`continut`) 
;

create view my_view as 
select nume, prenume, datanasterii, loculnasterii from utilizatori;

select* from my_view;

DELIMITER //
CREATE PROCEDURE InsertUser 
   (IN prenume VARCHAR(50), 
   IN nume VARCHAR(50), 
   IN datanasterii DATE, 
   IN loculnasterii VARCHAR(50), 
   IN email VARCHAR(50), 
   IN numeutilizator VARCHAR(50), 
   IN CV TEXT, 
   IN photo BLOB)
BEGIN
   INSERT INTO utilizatori (prenume, nume, datanasterii, loculnasterii, email, numeutilizator, CV, photo) 
   VALUES (prenume, nume, datanasterii, loculnasterii, email, numeutilizator, CV, photo);
END //
DELIMITER ;

CALL InsertUser('John', 'Doe', '1990-01-01', 'New York', 'john.doe@example.com', 'johndoe', 'Lorem ipsum dolor sit amet', 'Capture6.PNG');

DELIMITER //
CREATE PROCEDURE sp_Actualizeaza_Utilizator (
  IN p_iduser int,
  IN p_prenume varchar(50),
  IN p_nume varchar(50),
  IN p_datanasterii date,
  IN p_loculnasterii varchar(50),
  IN p_email varchar(50),
  IN p_numeutilizator varchar(50),
  IN p_CV text,
  IN p_photo blob
)
BEGIN
    UPDATE utilizatori
    SET prenume = p_prenume,
        nume = p_nume,
        datanasterii = p_datanasterii,
        loculnasterii = p_loculnasterii,
        email = p_email,
        numeutilizator = p_numeutilizator,
        CV = p_CV,
        photo = p_photo
    WHERE iduser = p_iduser;
END //
DELIMITER ;
CALL sp_Actualizeaza_Utilizator(4, 'John', 'Doe', '1990-01-01', 'New York', 'john.doe@yahoo.com', 'johndoe', 'New CV', 'Capture6.PNG');

DELIMITER //
CREATE PROCEDURE sp_Sterge_Utilizator (
  IN p_iduser int
)
BEGIN
  DELETE FROM utilizatori WHERE iduser = p_iduser;
END //
DELIMITER ;
CALL sp_Sterge_Utilizator(4);

DELIMITER //
CREATE FUNCTION f_Numar_Prieteni (
  id_user INT
) RETURNS INT
BEGIN
    DECLARE numar_prieteni INT;
    SELECT COUNT(*) INTO numar_prieteni FROM prietenii WHERE (user_1_id = id_user OR user_2_id = id_user) AND prietenie = 'accepted';
    RETURN numar_prieteni;
END //
DELIMITER ;
SELECT f_Numar_Prieteni(1);