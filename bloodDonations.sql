#step 1: Creating the DB, named as bloodDonations
CREATE SCHEMA bloodDonations;
#step 2: Creating DB tables (8 tables)
CREATE TABLE bloodDonations.recipient( 
nationalID INT(20) NOT NULL,
firstName VARCHAR(15),
lastName VARCHAR(15),
birthdate DATE,
email VARCHAR(320),
bloodType VARCHAR(3),
CONSTRAINT recipient_PK PRIMARY KEY (nationalID)
);
CREATE TABLE bloodDonations.bloodBank(
bloodBankName VARCHAR(30) NOT NULL,
email VARCHAR(320) UNIQUE,
phoneNo INT(20) UNIQUE,
street VARCHAR(30),
zipCode INT(7),
CONSTRAINT bloodBank_PK PRIMARY KEY (bloodBankName)
);
CREATE TABLE bloodDonations.medicalStaff(
nationalID INT(20) NOT NULL,
firstName VARCHAR(15),
lastName VARCHAR(15),
phoneNo INT(20),
email VARCHAR(320),
salary DECIMAL(7,2),
bloodBankName VARCHAR(30),
workingHours INT(2),
super_ID INT(20) UNIQUE, #the national ID of supervisor
CONSTRAINT medicalStaff_PK PRIMARY KEY (nationalID),
CONSTRAINT medicalStaff_FK1 FOREIGN KEY (super_ID) REFERENCES medicalStaff(nationalID) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT medicalStaff_FK2 FOREIGN KEY (bloodBankName) REFERENCES bloodbank(bloodBankName) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE bloodDonations.donor(
nationalID INT(20) NOT NULL,
firstName VARCHAR(15),
lastName VARCHAR(15),
birthDate DATE,
email VARCHAR(320),
staffNationalID INT(20),
bloodType VARCHAR(3), # this is a regular attribute in the parent (not PK nor unique)
CONSTRAINT donor_PK PRIMARY KEY (nationalID),
CONSTRAINT donor_FK FOREIGN KEY (staffNationalID) REFERENCES medicalStaff(nationalID) ON DELETE CASCADE ON UPDATE CASCADE
);
 
CREATE TABLE bloodDonations.bloodUnit(
DIN VARCHAR(17) NOT NULL, #DIN is Donation Identification number written as (000-000-000-000-0)
bloodBankName VARCHAR(30),
donorNationalID INT(20),
recipientNationalID INT(20),
Quantity DECIMAL(3,1), 
donationDate DATE,
CONSTRAINT bloodUnit_PK PRIMARY KEY (DIN),
CONSTRAINT bloodUnit_FK1 FOREIGN KEY (bloodBankName) REFERENCES bloodBank(bloodBankName) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT bloodUnit_FK2 FOREIGN KEY (donorNationalID) REFERENCES donor(nationalID) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT bloodUnit_FK3 FOREIGN KEY (recipientNationalID) REFERENCES recipient(nationalID)ON DELETE SET NULL ON UPDATE CASCADE
);
 
CREATE TABLE bloodDonations.companion(
donorNationalID INT(20) NOT NULL,
comapnionNationalID INT(20) NOT NULL,
firstName VARCHAR(15),
lastName VARCHAR(15),
birthdate DATE,
CONSTRAINT companion_PK PRIMARY KEY (donorNationalID, comapnionNationalID),
CONSTRAINT companion_FK FOREIGN KEY (donorNationalID) REFERENCES donor(nationalID) ON DELETE CASCADE ON UPDATE CASCADE
);
 
CREATE TABLE bloodDonations.donorContacts(
nationalID INT(20) NOT NULL,
contactNo INT(20) NOT NULL,
CONSTRAINT donorContacts_PK PRIMARY KEY (nationalID, contactNo),
CONSTRAINT donorContacts_FK FOREIGN KEY (nationalID) REFERENCES donor(nationalID) ON DELETE CASCADE ON UPDATE CASCADE
);
 
CREATE TABLE bloodDonations.recepientContacts(
nationalID INT(20) NOT NULL,
contactNo INT(20) NOT NULL,
CONSTRAINT recepientContacts_PK PRIMARY KEY (nationalID, contactNo),
CONSTRAINT recepientContacts_FK FOREIGN KEY (nationalID) REFERENCES recipient(nationalID) ON DELETE CASCADE ON UPDATE CASCADE
);
 
# Step 3: Inserting Data into tables
INSERT INTO bloodDonations.recipient (nationalID, firstName, lastName, birthdate, email, bloodType)
VALUE(1111516777,'Mohammed','Ahmed','02-11-01','Mohammed1488@gmail.com','O'),
(1111315655,'Majed','Saad','99-08-02','majedS1999@gmail.com','A'),
(1111418766,'Ahmed','Omar','02-09-2','Ahmedoo3788@gmail.com','B'),
(1111915855,'Abdullah','Fahad','99-04-01','Abdff1889@gmail.com','+O'),
(1118148440,'Yasser','Khaled','66-08-01','yaskk11991@gmail.com','-A');
 
INSERT INTO bloodDonations.bloodBank(bloodBankName, email, phoneNo, street, zipCode)
VALUE('One Blood','mm222@gmail.com',0566666451,'AL-awali,Ibrahim-AL-Juffali',24372),
('Mecca’s Blood Center','ol11111444@gmail.com',0784257375,'Waly-AL-Ahd ',24353),
('Community Blood Bank','Khee11103033@gmail.com',0456434564,'Al-Shawqiah',24351),
('Saudi blood services','ash155671@gmail.com',0345673456,'AL-diyafa',24221),
('National Guard Blood Bank','saa1277782@gmail.com',0862356743,'Al-Zaher',24222);
 
INSERT INTO bloodDonations.medicalStaff(nationalID, firstName, lastName, phoneNo, email, salary, bloodBankName, workingHours, super_ID)
VALUE(1119158555,'Anas','Saad',0876545673,'ann1333222@gmail.com',500,'National Guard Blood Bank',7,null),
(1111562319,'Hatem','Saud',0635324853,'hate1244@gmail.com',650,'One Blood',6,1119158555),
(1111132452,'Zeyad','Mohammed',0758534266,'zed1424@gmail.com',870,'Mecca’s Blood Center',5,1111562319),
(1212311111,'Qasim','Khaled',0985736461,'qa11117@gmail.com',900,'Saudi blood services',7,1111132452),
(1111215667,'Mohammed','Mourad',0652646324,'mouq14567@gmail.com',1000,'Community Blood Bank',6,1212311111),
(1122117890,'Maha','Mourad',0522006803,'mmrr13244@gmail.com',2000,'Mecca’s Blood Center',7,1111215667),
(1113467881,'Maram','Ahmed',0523409786,'meeeq14333@gmail.com',3000,'Saudi blood services',5,1122117890);
 
INSERT INTO bloodDonations.donor(nationalID, firstName, lastName, birthDate, email, staffNationalID, bloodType)
VALUE(1123366211,'Qasim','Saad','03-05-22','qfr17272@gmail.com',1119158555,'A'),
(1116512344,'Omar','Abduallah','02-08-24','oma121@gmail.com',1111562319,'B'),
(1230987645,'Moneer','Btal','04-11-12','Mmy12399@gmail.com',1111132452,'+O'),
(0432109876,'Majed','omar','01-02-25','mois1243@gmail.com',1212311111,'-A'),
(0947593021,'Khaled','Noor','99-12-01','KNsns138782@gmail.com',1111215667,'O');
 
INSERT INTO bloodDonations.bloodUnit(DIN,bloodBankName,donorNationalID,recipientNationalID,Quantity,donationDate)
VALUE('101-736-523-875-1','National Guard Blood Bank',1123366211,1111315655,2.6,'20-04-12'),
('102-434-985-878-6','Mecca’s Blood Center',1116512344,1111418766,6.5,'19-05-22'),
('103-212-666-188-3','Community Blood Bank',1230987645,1111915855,7.8,'21-06-11'),
('104-133-700-167-2','One Blood',0947593021,1111516777,8.5,'17-06-18'),
('105-644-353-855-7','Saudi blood services',0432109876,1118148440,5,'21-05-06');
 
INSERT INTO bloodDonations.companion(donorNationalID,comapnionNationalID,firstName,lastName,birthdate)
VALUE(1123366211,1022992214,'Ahmed','Salim','03-08-04'),
(1116512344,0555555441,'Omar','Mohammed','05-11-05'),
(1230987645,0991112226,'Fahad','Saud','90-10-22'),
(0432109876,0885559230,'Sami','Fahad','98-02-12'),
(0947593021,0967452301,'Amjed','Sami','04-05-01');
 
INSERT INTO bloodDonations.donorContacts(nationalID,contactNo)
VALUE(1123366211,1119241236),
(1116512344,0435877895),
(1230987645,1352435683),
(0432109876,0889653220),
(0947593021,0171234012);
 
INSERT INTO bloodDonations.recepientContacts(nationalID,contactNo)
VALUE(1111516777,0176541230),
(1111315655,1209348718),
(1111418766,1074563210),
(1111915855,0156988971),
(1118148440,0101235456);

#step 4: Creating DB commands
UPDATE bloodDonations.medicalStaff #update the salary of medicalstaff, give them 10% salary increase
SET salary= salary*1.1;

UPDATE bloodDonations.medicalStaff #update the workingHours of medicalstaff whith 5 workingHours , give them  3 hours increase
SET workingHours = workingHours+3
WHERE workingHours='5';

DELETE FROM medicalStaff; #deleting a table 

DELETE contactNo FROM donorContacts; #deleting a colume in a table 


SELECT firstName, email, phoneNo, workingHours # select statment using where
      FROM bloodDonations.medicalStaff
      WHERE salary BETWEEN 500.00 AND 1000.00;

SELECT nationalID, bloodType 
      FROM bloodDonations.donor
      WHERE bloodType IN('O', '+O');
  
SELECT bloodBankName, count(nationalID) AS numberOfMedicalStaff 
      FROM bloodDonations.medicalStaff
      group by bloodBankName;

SELECT workingHours, count(nationalID) AS numberOfMedicalStaff
      FROM bloodDonations.medicalStaff
      group by workingHours;

SELECT bloodBankName, count(nationalID) AS numberOfMedicalStaff, SUM(salary) as salarySum
FROM bloodDonations.medicalStaff
group by bloodBankName
having count(nationalID) >1;


SELECT  # select statment with DESC order using ordrer by
    *
FROM
    companion
ORDER BY birthdate DESC;

SELECT #select statment with DESC and ASC orders using ordrer by
    *
FROM
    bloodBank
ORDER BY bloodBankName ASC , zipcode DESC;


SELECT #select statment with supqueries
    *
FROM
    bloodUnit
WHERE
    donorNationalID IN (SELECT 
            nationalID
        FROM
            donor
        WHERE
            bloodType = 'A'
                OR email = 'Mmy12399@gmail.com');

SELECT #select statment with supqueries
    *
FROM
    medicalstaff
WHERE
    super_ID = (SELECT 
                       super_ID
				 FROM
                       medicalstaff
                 WHERE
					   bloodBankName = ( SELECT 
                                               bloodBankName
										 FROM
                                               bloodbank
                                         WHERE
                                               zipCode = 24353) 
                                                                );
 
 SELECT #select statment with join opration
    R.bloodType, R.nationalID, D.bloodType,D.nationalID
FROM
    recipient R,
    donor D,
    bloodunit B
where 
   B.recipientNationalID = R.nationalID And B.donationDate = D.nationalID ;