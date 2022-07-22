--Different types of operation

SELECT DISTINCT(department) AS DISTINCT_DEPARTMENT 
FROM DOCTOR;

SELECT department AS department_Like_Hemato 
FROM DOCTOR 
WHERE department LIKE '%Hemato%';

SELECT department AS department_Like_Hemato
FROM DOCTOR 
WHERE department LIKE '%Phych%';

SELECT doctorId,name,department 
FROM DOCTOR 
ORDER BY doctorId ASC;

SELECT doctorId,name,department 
FROM DOCTOR 
ORDER BY doctorId DESC;

SELECT patientId,name,age 
FROM PATIENT 
ORDER BY age ASC;

SELECT patientId,name,age 
FROM PATIENT 
ORDER BY age DESC;

--The patient whose total bill is between 5000 and 7000

SELECT patientId,name 
FROM PATIENT 
WHERE patientId IN(SELECT patientId 
				   FROM BILL 
				   WHERE (roomCharge+doctorCharge) BETWEEN 5000 AND 7000);

--The patient whose total bill is not between 5000 and 7000

SELECT patientId,name FROM PATIENT 
WHERE patientId IN(SELECT patientId 
				   FROM BILL 
				   WHERE (roomCharge+doctorCharge) NOT BETWEEN 5000 AND 7000);

--The patient whose total bill is not between 5000 and 7000 using aliasing

SELECT p.patientId,p.name 
FROM PATIENT p 
WHERE p.patientId IN(SELECT b.patientId 
					 FROM BILL b 
					 WHERE (b.roomCharge+b.doctorCharge)<5000 OR (b.roomCharge+b.doctorCharge)>7000);

--SELECT doctorId,name,department FROM DOCTOR GROUP BY department HAVING doctorId>1207001;

SELECT type 
FROM ROOM 
GROUP BY type 
HAVING type='Single Bed, AC';

--Use of different aggregate function

SELECT COUNT(*),COUNT(doctorCharge),SUM(doctorCharge),AVG(doctorCharge),AVG(NVL(doctorCharge,0)),MAX(doctorCharge),MIN(roomCharge),SUM(roomCharge) 
FROM BILL;

--All the doctor's and patient's name,address,phoneNo,gender information  using UNION ALL

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
UNION ALL 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


--All the doctor's and patient's name,address,phoneNo,gender information  using and UNION

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
UNION 
SELECT name,address,phoneNo,gender 
FROM PATIENT;


--All the doctor's name,address,phoneNo,gender information whose is not in patient's using INTERSECT

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
INTERSECT 
SELECT name,address,phoneNo,gender 
FROM PATIENT;

--All the doctor's name,address,phoneNo,gender information whose is not in patient's using MINUS

SELECT name,address,phoneNo,gender 
FROM DOCTOR 
MINUS 
SELECT name,address,phoneNo,gender 
FROM PATIENT;

--------------------All Appointment date of each Patient under the doctor name-------------

SELECT p.name,d.name,a.appointmentDate AS AppDate 
FROM DOCTOR d,PATIENT p,APPOINTMENT a 
WHERE d.doctorId=a.doctorId AND a.patientId=p.patientId;


--Bill description of each patient by JOIN

SELECT p.patientId,b.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
JOIN 
BILL b 
ON p.patientId=b.patientId;

--------------------Bill description of each patient by JOIN and USING------------------

SELECT patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
JOIN 
BILL b 
USING (patientId);

--Bill description of each patient by NATURAL JOIN

SELECT patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
NATURAL JOIN 
BILL b;


--CROSS JOIN between patient and bill table
SELECT p.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p
CROSS JOIN 
BILL b;


--Bill description of each patient by INNER JOIN same as JOIN

SELECT p.patientId,b.patientId,p.name,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
INNER JOIN 
BILL b 
ON p.patientId=b.patientId;


--Bill description of each patient by LEFT OUTER JOIN

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
LEFT OUTER JOIN 
BILL b 
ON p.patientId=b.patientId;


--Bill description of each patient by RIGHT OUTER JOIN

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
RIGHT OUTER JOIN 
BILL b 
ON p.patientId=b.patientId;


--Bill description of each patient by FULL OUTER JOIN

SELECT p.patientId,b.patientId,b.billNo,b.doctorCharge,b.roomCharge 
FROM PATIENT p 
FULL OUTER JOIN 
BILL b 
ON p.patientId=b.patientId;


--The Room charge in  Bill using SELF JOIN
SELECT b1.roomCharge,b2.roomCharge 
FROM BILL b1 
JOIN 
BILL b2 
ON b1.roomCharge=b2.roomCharge;


--Showing maximum bill including their disCountCharge using PL/SQL

SET SERVEROUTPUT ON
DECLARE
	--Type OwnType is number(9,2);
	totalCharge BILL.roomCharge%type;
	maxBillNo   BILL.billNo%type;
	maxBillPatientId BILL.patientId%type;
	disCountCharge number(8,2);
BEGIN
	SELECT MAX(doctorCharge+roomCharge) INTO totalCharge 
	FROM BILL;
	SELECT billNo,patientId INTO maxBillNo,maxBillPatientId 
	FROM BILL 
	WHERE (doctorCharge+roomCharge) IN(totalCharge);
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


--showing room description of the patient whose room type is Single Bed, AC using CURSOR

SET SERVEROUTPUT ON
DECLARE
	CURSOR roomCursor IS SELECT roomId,patientId,type,varietyWard FROM ROOM WHERE type='Single Bed, AC';
	accessVar	roomCursor%ROWTYPE;
	rowCounting int;
BEGIN
	OPEN roomCursor;
	SELECT COUNT(*) INTO rowCounting 
	FROM  ROOM 
	WHERE type='Single Bed, AC';
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


--Insertion into APPOINTMENT table using PROCEDURE

CREATE OR REPLACE PROCEDURE InsertIntoAppointment(docId DOCTOR.doctorId%type,patId PATIENT.patientId%type,appoinDate APPOINTMENT.appointmentDate%type) IS
BEGIN
	INSERT INTO APPOINTMENT VALUES(docId,patId,appoinDate);
	commit;
END InsertIntoAppointment;
/


--Calling the PROCEDURE for Inserting into APPOINTMENT

SET SERVEROUTPUT ON
BEGIN
	InsertIntoAppointment(1807009,10001,'25-APR-22');
END;
/

SELECT * FROM APPOINTMENT;

--Update into PATIENT table using PROCEDURE

CREATE OR REPLACE PROCEDURE UpdateIntoPatient(pId PATIENT.patientId%type,newAdd PATIENT.address%type,newPhone PATIENT.phoneNo%type,newAge PATIENT.age%type) IS
BEGIN
	UPDATE PATIENT 
	SET address=newAdd,phoneNo=newPhone,age=newAge 
	WHERE patientId=pId;
	
	commit;

END UpdateIntoPatient;
/


--Calling the PROCEDURE for Updating into PATIENT

SET SERVEROUTPUT ON
BEGIN
	UpdateIntoPatient(10001,'K/C Road, Khulna','+8801734754585',65);
END;
/


SELECT * FROM PATIENT ;


--DelEting from PATIENT table using PROCEDURE

CREATE OR REPLACE PROCEDURE DeletingPatient(dId NUMBER) IS
BEGIN
	DELETE FROM PATIENT 
	WHERE patientId=dId;
	commit;
END DeletingPatient;
/


--Calling the PROCEDURE for DelEting from PATIENT

SET SERVEROUTPUT ON
BEGIN
	DeletingPatient(10002);
END;
/


SELECT * FROM PATIENT;


--Finding totalCharge for a PATIENT  using FUNCTION

CREATE OR REPLACE FUNCTION TreatmentCharge(bNo BILL.billNo%type) RETURN NUMBER IS
	totCharge BILL.roomCharge%type;
BEGIN
	SELECT (doctorCharge+roomCharge) INTO totCharge FROM BILL WHERE billNo=bNo;
	RETURN totCharge;
END TreatmentCharge;
/


--Calling the FUNCTION for Calculating totalCharge for PATIENT
--id :='&billNo';

SET SERVEROUTPUT ON
DECLARE
	id BILL.billNo%type;
BEGIN
	DBMS_OUTPUT.PUT_LINE('The total for Patient ID ' ||'A-212' ||' is : '||TreatMentCharge('A-212'));
END;
/


--Transaction Management(Rollback)

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

--Calculating age of a doctorUse date and 

SELECT sysdate,birthDate,((SELECT sysdate from dual)-TO_DATE(birthDate))/365 AS ageOfDoctor 
FROM DOCTOR 
WHERE doctorId=1207001;

--Second Highest roomCharge FROM BILL

SELECT MAX(roomCharge) 
FROM BILL 
WHERE roomCharge NOT IN(SELECT MAX(roomCharge) 
						FROM BILL);

-------------------------------END of the Project-------------------------------------