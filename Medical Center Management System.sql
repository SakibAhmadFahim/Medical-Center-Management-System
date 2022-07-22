------------------------Database Project on Medical Center Management System by Sakib Ahmed (Roll-1807096)----------------------------

-- Delete the following table if they exist in the 
-- database priviously

DROP TABLE ROOM;
DROP TABLE BILL;
DROP TABLE APPOINTMENT;
DROP TABLE PATIENT;
DROP TABLE DOCTOR;

-- creation of the TABLE DOCTOR
CREATE TABLE DOCTOR(
	doctorId		number(7) NOT NULL,
	name			varchar(30) NOT NULL,
	designation		varchar(25),
	address			varchar(35),
	phoneNo			varchar(20),
	gender			varchar(6),
	birthDate		date,

	dept		varchar(30)
);

ALTER TABLE DOCTOR RENAME COLUMN dept TO department;
ALTER TABLE DOCTOR DROP COLUMN department;
ALTER TABLE DOCTOR ADD department varchar(30);
--Adding CONSTRAINT into TABLE DOCTOR
ALTER TABLE DOCTOR ADD  CONSTRAINT DOCTOR_PK PRIMARY KEY(doctorId);


-- creation of the TABLE PATIENT
CREATE TABLE PATIENT(
	patientId		number(5) NOT NULL,
	name			varchar(30) NOT NULL,
	address			varchar(35),
	age				number(3),
	phoneNo			varchar(20) UNIQUE,
	gender			varchar(6),
	CONSTRAINT PATIENT_PK PRIMARY KEY(patientId)
);

--Modification using alter
ALTER TABLE PATIENT MODIFY patientId number(5) check(patientId>10000);


--Dropping and Adding CONSTRAINT into TABLE PATIENT
ALTER TABLE PATIENT DROP CONSTRAINT PATIENT_PK;
ALTER TABLE PATIENT ADD  CONSTRAINT PATIENT_PK PRIMARY KEY(patientId);



-- creation of the TABLE APPOINTMENT
CREATE TABLE APPOINTMENT(
	doctorId		number(7) NOT NULL,
	patientId		number(5) NOT NULL,
	appointmentDate date
	
);

--Adding CONSTRAINT into TABLE APPOINTMENT

ALTER TABLE APPOINTMENT ADD CONSTRAINT APPOINTMENT_PK 
	PRIMARY KEY(doctorId,patientId);

ALTER TABLE APPOINTMENT ADD CONSTRAINT APPOINTMENT_FK1 
	FOREIGN KEY(doctorId) references DOCTOR(doctorId) ON DELETE CASCADE;

ALTER TABLE APPOINTMENT ADD CONSTRAINT APPOINTMENT_FK2 
	FOREIGN KEY(patientId) references PATIENT(patientId) ON DELETE CASCADE;



-- creation of the TABLE ROOM
CREATE TABLE ROOM(
	roomId			number(4) NOT NULL,
	patientId		number(5) NOT NULL,
	type			varchar(20),
	varietyWard		varchar(20)
	
);

--Adding CONSTRAINT into TABLE ROOM

ALTER TABLE ROOM ADD CONSTRAINT ROOM_PK PRIMARY KEY(roomId);

ALTER TABLE ROOM ADD CONSTRAINT ROOM_FK FOREIGN KEY(patientId)
	 references PATIENT(patientId) ON DELETE CASCADE;



-- creation of the TABLE BILL
CREATE TABLE BILL(
	billNo			varchar(5) NOT NULL,
	patientId		number(5) NOT NULL,
	doctorCharge	number(8,2),
	roomCharge		number(8,2)
);

--Adding CONSTRAINT into TABLE BILL

ALTER TABLE BILL ADD CONSTRAINT BILL_PK PRIMARY KEY(billNo);

ALTER TABLE BILL ADD CONSTRAINT BILL_FK FOREIGN KEY(patientId)
	 references PATIENT(patientId) ON DELETE CASCADE;

--Use of Disable and enable of constraint

ALTER TABLE BILL DISABLE CONSTRAINT BILL_PK;

ALTER TABLE BILL ENABLE CONSTRAINT BILL_PK;


--Triggering for Insertion and Update for Bill TABLE


CREATE OR REPLACE TRIGGER BillChecking BEFORE INSERT OR UPDATE ON BILL
FOR EACH ROW
DECLARE
	minRoomCharge BILL.roomCharge%type := 500;
	
BEGIN
	IF :new.roomCharge<minRoomCharge THEN
	 	RAISE_APPLICATION_ERROR(-20000,'Room Charge is too small');
	END IF;
END;
/

-------------describe Tables-----------------

describe doctor;
describe patient;
describe appointment;
describe room;
describe bill;

--SET SERVEROUTPUT ON

SET SERVEROUTPUT ON
BEGIN


-- Value Insertion into table DOCTOR
INSERT INTO DOCTOR VALUES(1207001,'Professor Dr. A. B. M. Yunus','Professor','25/3, Green Road, Dhaka - 1205','+880-2-8610313','Male','11-NOV-94','Hematology');
INSERT INTO DOCTOR VALUES(1207012,'Professor Dr. A.A. Quoreshi','Professor','Dhaka - 1212, Bangladesh','+880 2 9896165','Male','12-JUL-90','Psychiatry');
INSERT INTO DOCTOR VALUES(1207005,'Professor Dr. Sirajul Haque','Professor','Dhanmondi, Dhaka','+880-2- 9131207','Male','12-JUL-90','Hematology');
INSERT INTO DOCTOR VALUES(1207023,'Professor Dr. A. B. M. Yunus','Professor','25/3, Green Road, Dhaka - 1205','+880-2-8610313','Male','11-NOV-94','Hematology');



-- Value Insertion into table Patient
INSERT INTO PATIENT VALUES(10001,'A F M Anowar Hossain','Dhaka - 1205, Bangladesh',23,'+880-2-9660015-18','Male');
INSERT INTO PATIENT VALUES(10003,'A H M Rowshon','Khulna - 1206, Bangladesh',32,'+880-2-9669480','Female');
INSERT INTO PATIENT VALUES(10002,'A H M Shahidul Islam','Dhaka - 1205, Bangladesh',43,'+880-2-9660015-19','Male');
INSERT INTO PATIENT VALUES(10004,'Professor Dr. A. B. M. Yunus','25/3, Green Road, Dhaka - 1205',43,'+880-2-8610313','Male');



-- Value Insertion into table APPOINTMENT
INSERT INTO APPOINTMENT VALUES(1207001,10003,'25-AUG-15');
INSERT INTO APPOINTMENT VALUES(1207005,10002,'18-MAR-15');
INSERT INTO APPOINTMENT VALUES(1207012,10001,'15-NOV-94');
INSERT INTO APPOINTMENT VALUES(1207001,10002,'03-JAN-15');



-- Value Insertion into table Room
INSERT INTO ROOM VALUES(1001,10001,'Single Bed, Non AC','General Ward');
INSERT INTO ROOM VALUES(3023,10003,'Double Bed, AC','ICU Ward');
INSERT INTO ROOM VALUES(7011,10002,'Single Bed, AC','Emergency Ward');
INSERT INTO ROOM VALUES(5011,10004,'Single Bed, AC','General Ward');



-- Value Insertion into table BILL
INSERT INTO BILL VALUES('A-212',10001,5000.50,2000);
INSERT INTO BILL VALUES('H-567',10001,2300.50,4000);
INSERT INTO BILL VALUES('D-897',10003,4500,1000);
INSERT INTO BILL VALUES('E-566',10004,NULL,NULL);


DBMS_OUTPUT.PUT_LINE('Data Inserted in each table');

END;
/


------------Select operation of the tables------------------

SELECT * FROM DOCTOR;
SELECT * FROM PATIENT;
SELECT * FROM APPOINTMENT;
SELECT * FROM ROOM;
SELECT * FROM BILL;

-----------------Use of View-----------------

DROP VIEW Patient_VIEW;
CREATE VIEW PATIENT_VIEW AS
SELECT patientId,name, age
FROM  PATIENT;

select * from patient_view;

DROP VIEW Doctor_VIEW;
CREATE VIEW Doctor_VIEW AS
SELECT doctorId,name, address
FROM doctor;

select * from Doctor_view;


--Different types of operation

-----------Use of DISTINCT----------------

SELECT DISTINCT(department) AS DISTINCT_DEPARTMENT 
FROM DOCTOR;

SELECT DISTINCT(gender) AS DISTINCT_DEPARTMENT 
FROM DOCTOR;


-----------Use of Like---------------

SELECT department AS department_Like_Hemato 
FROM DOCTOR 
WHERE department LIKE '%Hemato%';

SELECT department AS department_LIKE_Psy 
FROM DOCTOR 
WHERE department LIKE '%Psy%';

-------------Use of ORDER BY------------

SELECT doctorId,name,department 
FROM DOCTOR 
ORDER BY doctorId ASC;

SELECT doctorId,name,department 
FROM DOCTOR 
ORDER BY doctorId DESC;


---------The patient whose total bill is between 5000 and 7000-------------
SELECT patientId,name 
FROM PATIENT 
WHERE patientId IN(SELECT patientId FROM BILL WHERE (roomCharge+doctorCharge) BETWEEN 5000 AND 7000);


----------The patient whose total bill is not between 5000 and 7000--------------
SELECT patientId,name 
FROM PATIENT 
WHERE patientId IN(SELECT patientId FROM BILL WHERE (roomCharge+doctorCharge) NOT BETWEEN 5000 AND 7000);


-------------The patient whose total bill is not between 5000 and 7000 using aliasing--------------

SELECT p.patientId,p.name 
FROM PATIENT p 
WHERE p.patientId IN(SELECT b.patientId FROM BILL b WHERE (b.roomCharge+b.doctorCharge)<5000 OR (b.roomCharge+b.doctorCharge)>7000);


-----The patient whose total bill is not between 6000 and 8000 using aliasing-----------------

SELECT p.patientId,p.name 
FROM PATIENT p 
WHERE p.patientId IN(SELECT b.patientId FROM BILL b WHERE (b.roomCharge+b.doctorCharge)<6000 OR (b.roomCharge+b.doctorCharge)>8000);

-------------------------Use of Having--------------------------

SELECT type,count(type) 
FROM ROOM 
GROUP BY type 
HAVING type='Single Bed, AC';


--------------------Use of different aggregate function----------------------

SELECT COUNT(*),COUNT(doctorCharge),SUM(doctorCharge),AVG(doctorCharge),AVG(NVL(doctorCharge,0)),MAX(doctorCharge),MIN(roomCharge),SUM(roomCharge) 
FROM BILL;

------------Second Highest roomCharge FROM BILL-----------------

SELECT MAX(roomCharge) 
FROM BILL 
WHERE roomCharge NOT IN(SELECT MAX(roomCharge) FROM BILL);

------------All the doctor's and patient's name,address,phoneNo,gender information using UNION ALL---------------

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
UNION ALL 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


-----------All the doctor's and patient's name,address,phoneNo,gender information  using and UNION----------

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
UNION 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


-----------All the doctor's name,address,phoneNo,gender information whose is not in patient's using INTERSECT------------
SELECT name,address,phoneNo,gender 
FROM DOCTOR 
INTERSECT 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


----------All the doctor's name,address,phoneNo,gender information whose is not in patient's using MINUS-----------
SELECT name,address,phoneNo,gender 
FROM DOCTOR 
MINUS 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


--------------------All Appointment date of each Patient under the doctor name-------------
SELECT p.name,d.name,a.appointmentDate AS AppDate 
FROM DOCTOR d,PATIENT p,APPOINTMENT a 
WHERE d.doctorId=a.doctorId AND a.patientId=p.patientId;


--------Bill description of each patient by JOIN--------------

SELECT p.patientId,b.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p JOIN BILL b 
ON p.patientId=b.patientId;


--------------------Bill description of each patient by JOIN and USING------------------

SELECT patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p JOIN BILL b 
USING (patientId);


---------------Bill description of each patient by NATURAL JOIN-----------------

SELECT patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p NATURAL JOIN BILL b;


-------------CROSS JOIN between patient and bill table-----------------

SELECT p.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p CROSS JOIN BILL b;


---------------Bill description of each patient by INNER JOIN same as JOIN--------------

SELECT p.patientId,b.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p INNER JOIN BILL b 
ON p.patientId=b.patientId;


----------------Bill description of each patient by LEFT OUTER JOIN------------------

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p LEFT OUTER JOIN BILL b 
ON p.patientId=b.patientId;


------------Bill description of each patient by RIGHT OUTER JOIN------------------

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p RIGHT OUTER JOIN BILL b 
ON p.patientId=b.patientId;


--------------Bill description of each patient by FULL OUTER JOIN-----------------

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p FULL OUTER JOIN BILL b 
ON p.patientId=b.patientId;


---------------The Room charge in  Bill using SELF JOIN---------------
SELECT b1.roomCharge,b2.roomCharge 
FROM BILL b1 JOIN BILL b2 
ON b1.roomCharge=b2.roomCharge;


---------------Showing maximum bill including their disCountCharge using PL/SQL----------------

SET SERVEROUTPUT ON
DECLARE
	--Type OwnType is number(9,2);
	totalCharge BILL.roomCharge%type;
	maxBillNo   BILL.billNo%type;
	maxBillPatientId BILL.patientId%type;
	disCountCharge number(8,2);
BEGIN
	SELECT MAX(doctorCharge+roomCharge) INTO totalCharge FROM BILL;
	SELECT billNo,patientId INTO maxBillNo,maxBillPatientId FROM BILL WHERE (doctorCharge+roomCharge) IN(totalCharge);
	DBMS_OUTPUT.PUT_LINE('The maximum charge of a patient is : '||totalCharge||' with Patient billNo : '||maxBillNo||' and ID No : '||maxBillPatientId);
	IF totalCharge<=3000 THEN
		disCountCharge := totalCharge - totalCharge*0.10;
	ELSIF totalCharge<=10000 THEN
		disCountCharge := totalCharge - totalCharge*0.15;
	ELSIF totalCharge<=50000 THEN
		disCountCharge := totalCharge - totalCharge*0.20;
	ELSIF totalCharge<=100000 THEN
		disCountCharge := totalCharge - totalCharge*0.25;
	ELSE
		disCountCharge := totalCharge - totalCharge*0.30;
	END IF;
	DBMS_OUTPUT.PUT_LINE('The disCountCharge charge of a patient is : '||disCountCharge);
END;
/



-----------------Showing room description of the patient whose room type is 'Single Bed, AC' using CURSOR--------------

SET SERVEROUTPUT ON
DECLARE
	CURSOR roomCursor IS SELECT roomId,patientId,type,varietyWard FROM ROOM WHERE type='Single Bed, AC';
	accessVar	roomCursor%ROWTYPE;
	rowCounting int;
BEGIN
	OPEN roomCursor;
	SELECT COUNT(*) INTO rowCounting FROM  ROOM WHERE type='Single Bed, AC';
	DBMS_OUTPUT.PUT_LINE('roomId  patientId       type            varietyWard');
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------');
	LOOP

		FETCH roomCursor INTO accessVar;
		DBMS_OUTPUT.PUT_LINE(accessVar.roomId || '      ' || accessVar.patientId || '    ' || accessVar.type || '      ' || accessVar.varietyWard);
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------');
EXIT WHEN roomCursor%ROWCOUNT>rowCounting-1;
	END LOOP;
	CLOSE roomCursor;
END;
/

-------------Insertion into APPOINTMENT table using PROCEDURE---------------

CREATE OR REPLACE PROCEDURE InsertIntoAppointment(docId DOCTOR.doctorId%type,patId PATIENT.patientId%type,appoinDate APPOINTMENT.appointmentDate%type) IS
BEGIN
	INSERT INTO APPOINTMENT VALUES(docId,patId,appoinDate);
	commit;
END InsertIntoAppointment;
/


----------Calling the PROCEDURE for Inserting into APPOINTMENT-----------

SET SERVEROUTPUT ON
BEGIN
	InsertIntoAppointment(1207001,10001,'25-APR-15');
END;
/


SELECT * FROM APPOINTMENT;



-----------Update into PATIENT table using PROCEDURE------------

CREATE OR REPLACE PROCEDURE UpdateIntoPatient(pId PATIENT.patientId%type,newAdd PATIENT.address%type,newPhone PATIENT.phoneNo%type,newAge PATIENT.age%type) IS
BEGIN
	UPDATE PATIENT SET address=newAdd,phoneNo=newPhone,age=newAge WHERE patientId=pId;
	commit;
END UpdateIntoPatient;
/


----------Calling the PROCEDURE for Updating into PATIENT-----------

SET SERVEROUTPUT ON
BEGIN
	UpdateIntoPatient(10001,'K/C Road, Khulna','+8801734754585',65);
END;
/


SELECT * FROM PATIENT ;



---------Deleting from PATIENT table using PROCEDURE------------

CREATE OR REPLACE PROCEDURE DelatingPatient(dId NUMBER) IS
BEGIN
	DELETE FROM PATIENT WHERE patientId=dId;
	commit;
END DelatingPatient;
/


----------Calling the PROCEDURE for Deleting from PATIENT------------

SET SERVEROUTPUT ON
BEGIN
	DelatingPatient(10002);
END;
/


SELECT * FROM PATIENT;



----------Finding totalCharge for a PATIENT using FUNCTION----------

CREATE OR REPLACE FUNCTION TreatMentCharge(bNo BILL.billNo%type) RETURN NUMBER IS
	totCharge BILL.roomCharge%type;
BEGIN
	SELECT (doctorCharge+roomCharge) INTO totCharge FROM BILL WHERE billNo=bNo;
	RETURN totCharge;
END TreatMentCharge;
/


-------Calling the FUNCTION for Calculating totalCharge for PATIENT------------

--id :='&billNo';
SET SERVEROUTPUT ON
DECLARE
	id BILL.billNo%type;
BEGIN
	DBMS_OUTPUT.PUT_LINE('The total for Patient ID ' ||'A-212' ||' is : '||TreatMentCharge('A-212'));
END;
/



-------------Transaction Management(Rollback)--------------------

SELECT * FROM ROOM;
DELETE FROM ROOM;
SELECT * FROM ROOM;
ROLLBACK;
SELECT * FROM ROOM;
INSERT INTO ROOM VALUES(4008,10004,'Single bed, AC','General');
SAVEPOINT INSERT1;
INSERT INTO ROOM VALUES(6002,10001,'Double bed, AC','ICU');
SAVEPOINT INSERT2;
ROLLBACK TO INSERT1;

SELECT * FROM ROOM;


---------------Use of Date-------------------------


--Calculating age of a doctor

SELECT sysdate,birthDate,((SELECT sysdate from dual)-TO_DATE(birthDate))/365 AS ageOfDoctor 
FROM DOCTOR 
WHERE doctorId=1207001;

--Other operations

SELECT ADD_MONTHS (appointmentdate,6) Extention_1
FROM Appointment
WHERE patientId = 10001;

SELECT ADD_MONTHS (appointmentdate,8) Extention_2
FROM Appointment
WHERE patientId = 10003;

SELECT LEAST (TO_DATE ('22-JAN-2015'),TO_DATE ('12-DEC-2015')) as Least
FROM dual;

SELECT GREATEST (TO_DATE ('22-JAN-2015'),TO_DATE ('12-DEC-2015')) as Greatest
FROM dual;

SELECT patientId, EXTRACT(Year FROM appointmentDate) AS Year
FROM appointment;


SELECT patientId, EXTRACT(Month FROM appointmentDate) AS Month
FROM appointment;

-------------------------------END of the Project-------------------------------------