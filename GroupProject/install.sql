﻿use master
go
drop database Exam
go
create database Exam
go
use Exam
go

create table tbCourse(
Courseid int primary key identity(0,1),
Coursename varchar(60)
)
go

insert into tbCourse(Coursename)values
('Software Developer'),('Network Engineering')
go

create table tbClass(
Classid int primary key identity (0,1),
Classname varchar(60),
Courseid int foreign key references tbCourse(Courseid)on delete cascade
)
go

insert into tbClass(Classname,Courseid)values
('SD18',0),('SD19',0),('SD20',0),('SD21',0),('SD22',0),
('NT03',1),('NT04',1)
go

create table tbDifficulty(
Difficultyid int primary key identity(0,1),
Difficultyname varchar(60)
)
go

insert into tbDifficulty(Difficultyname)values
('Beginner'),('Intermediate'),('Advanced')
go

create table tbUser(
Userid int primary key identity (0,1),
Firstname varchar(60),
Lastname varchar(60),
Password varchar(60),
Classid int foreign key references tbClass(Classid)on delete cascade,
SecurityLevel int,
UserPicture varchar(60),
Email varchar(60) Unique
)
go


insert into tbUser(Firstname,Lastname,Password,Classid,SecurityLevel,UserPicture,Email)values
('Kevin','Coliat','Kevin1',0,3,'SamplePicture1.jpg','Kevin@yahoo.com'),
('Doug','Jackson','pass',0,2,'SamplePicture2.jpg','Doug@yahoo.com'),
('Nupur','Singh','Nupur1',0,1,'SamplePicture3.jpg','Nupur@yahoo.com'),
('Janry','Alex','Janry1',1,1,'SamplePicture4.jpg','Janry@yahoo.com'),
('Adrian','Carter','Adrian1',2,1,'SamplePicture5.jpg','Adrian@yahoo.com'),
('Veberly','Carvalho','Veberly1',0,1,'SamplePicture6.jpg','Veberly@yahoo.com'),
('OtherKevin','Coliat','Kevin1',1,1,'SamplePicture1.jpg','Kevin0@yahoo.com'),
('AnotherKevin','Coliat','Kevin1',1,1,'SamplePicture1.jpg','Kevin9@yahoo.com')
go

--select * from tbClass

--create table tbResults(
--Resultid int primary key identity (0,1),
--Userid int foreign key references tbUser(Userid),
--Versionid int foreign key references tbQuizVersion(Versionid), 
--Quizid int foreign key references tbQuiz(Quizid),
--TotalScore decimal(10,5)
--)
go

--insert into tbResults(Userid,Versionid,Quizid,TotalScore)values 
--(2,1,0,85.50),(3,1,0,90.00),(4,1,0,90.95),(5,1,0,99.9)

--Failed Login Attempts
--create table tbFailedLoginAttempt(
--Email varchar(60),
--Password varchar(60),
--DateAttempted date
--)
--go

--insert into tbFailedLoginAttempt(Email,Password,DateAttempted)values
--('Geoffrey','Smith','01-12-2014'),
--('Ian','Morgan','02-24-2014'),
--('Katie','Hunter','06-16-2014'),
--('Elmer','Sherman','06-25-2014'),
--('Isabel','Holland','07-03-2014'),
--('Andrea','Barrett','07-08-2014'),
--('Whitney','Woods','07-10-2014'),
--('Abraham','Washington','08-13-2013'),
--('Sophia','Roy','08-14-2013'),
--('Lester','Tran','04-06-2014'),
--('Tasha','Nguyen','04-15-2014'),
--('Desiree','Mcbride','04-20-2014'),
--('Melody','Allison','05-13-2014'),
--('Lee','Hopkins','05-20-2014'),
--('Irving','Evans','05-26-2014')
--go

create table tbQuizStatus(
StatusId int primary key identity (0,1),
StatusName varchar(10)
)

----testing xml datatype here to save uploaded quizzes----plz don't delete yet// thanks Nupur
create table tbXMLQuizContent(
XMLQuizID int primary key,    --extracting it from the XML file    
Title varchar(60),
Subject varchar(60),
CourseID int foreign key references tbCourse(Courseid),
Time int,
DifficultyId int foreign key references tbDifficulty(Difficultyid),

)
go

create table tbQuizVersion(
Versionid int primary key identity (0,1),
Quizid int foreign key references tbXMLQuizContent(XMLQuizID),
Version int,
XmlFile xml
)
go

create table tbIssuedTest(		-- issued quiz and its statuses
IssuedTestId int primary key identity(0,1),
Versionid int foreign key references tbQuizVersion(Versionid), -- actual quiz, has XMLQUIzContent and Version
StudentsToTakeId int foreign key references tbUser(Userid),		-- users who will take the test!
DateIssued date,
TestStatus int foreign key references tbQuizStatus(StatusId)
)

create table tbTestStudent(			
TestStudentid int primary key identity (0,1), -- just the id nothing else
IssuedTestId int foreign key references tbIssuedTest(IssuedTestId), 
Userid int foreign key references tbUser(Userid),  ---Student
XMLStudentResponse xml, 
Status varchar(20),
Points int   -- results or number of correct responses by each student
)
go


------------------------STORED PROCEDURES-----------------------

create procedure spInsertXMLContent(
@xml xml
)
as declare
@QuizIdDuplicate int,
@getQuizVersionOccurence int
 begin
begin transaction
 set nocount on;
 -- check first for duplicates, if so then make a new version of it...
 ;WITH XMLNAMESPACES (N'urn:Question-Schema' as ns)
 select @QuizIdDuplicate = (select t.value('@QuizId','int') as XMLQuizID
 from
 @xml.nodes('/ns:Quiz')AS TempTable(t))

 if not EXISTS(select 1 from tbXMLQuizContent where XMLQuizID = @QuizIdDuplicate)
 begin
 --- insert if no duplicate quizid
 ;WITH XMLNAMESPACES (N'urn:Question-Schema' as ns)
 insert into tbXMLQuizContent
 select 
 t.value('@QuizId','int') as XMLQuizID,    --attribute from xml file
 t.value('(ns:Details/ns:Title/text())[1]','VARCHAR(60)') as Title,   
 t.value('(ns:Details/ns:Subject/text())[1]','VARCHAR(60)') as Subject,
 (select Courseid from tbCourse where Coursename in (t.value('(ns:Details/ns:Course/text())[1]','VARCHAR(60)'))) as CourseID,
 t.value('(ns:Details/ns:Time/text())[1]','int') as Time,   
 (select Difficultyid from tbDifficulty where Difficultyname in (t.value('(ns:Details/ns:Difficulty/text())[1]','VARCHAR(60)'))) as Difficulty  
 from
 @xml.nodes('/ns:Quiz')AS TempTable(t)
 --- and insert new quizversion, set to version 1, first version of quiz
 ;WITH XMLNAMESPACES (N'urn:Question-Schema' as ns)
 insert into tbQuizVersion(Quizid,Version,XmlFile)
 select
 t.value('@QuizId','int') as Quizid,
 1 as Version,
 @xml as XmlFile
 from
 @xml.nodes('/ns:Quiz')AS TempTable(t)
 end
 else --- if there is a version exists in the database, then addnew version and the path of xml file
	begin
 ---- insert into tbQuizVersion
 set @getQuizVersionOccurence = (select COUNT(Versionid) from tbQuizVersion where Quizid = @QuizIdDuplicate)
 set @getQuizVersionOccurence += 1;
 ;WITH XMLNAMESPACES (N'urn:Question-Schema' as ns)
 insert into tbQuizVersion(Quizid,Version,XmlFile)
 select
 t.value('@QuizId','int') as Quizid,
 @getQuizVersionOccurence as Version,
 @xml as XmlFile
 from
 @xml.nodes('/ns:Quiz') AS TempTable(t)
	end

 if @@ERROR != 0
        begin
            ROLLBACK TRANSACTION
			select 'error' as status
		end
else
	begin
        commit transaction
		select 'success' as status
    end

end
go
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="111230123" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testtitle</Title><Subject>tsubh</Subject><Course>Software Developer</Course><Time>15</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="111230123" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testtitle</Title><Subject>tsubh</Subject><Course>Software Developer</Course><Time>25</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="9999" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testNetwork</Title><Subject>tsubh</Subject><Course>Network Engineering</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0"?><Quiz QuizId="570748" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>Yow </Title><Subject>YowS</Subject><Course>Software Developer</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>What is ?</Questi><Options><Option>a</Option><Option>3b</Option><Option Correct="yes">4x</Option><Option>5a</Option></Options></Question><Question ID="2"><Questi>Who is</Questi><Options><Option Correct="yes">zxcasd</Option><Option>4asdasd</Option><Option>5qwe</Option><Option>6asda</Option></Options></Question><Question ID="3"><Questi>What kind of?</Questi><Options><Option>4zxc</Option><Option>5asd</Option><Option Correct="yes">6qw</Option><Option>7qe</Option></Options></Question><Question ID="4"><Questi>Where is?</Questi><Options><Option>1asd</Option><Option>2xzcasd</Option><Option Correct="yes">3asd</Option><Option>5qwe</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
select * from tbXMLQuizContent
select * from tbCourse
select * from tbQuizVersion
go
-----------------------------PROCEDURES-----------------------------------------


create procedure spGetQuizAndInfo(
@versionid int
)
as begin
select XMLQuizID,Title,Subject,CourseID,Time,DifficultyId,XmlFile from tbXMLQuizContent,tbQuizVersion where XMLQuizID in (select top 1 Quizid from tbQuizVersion where Versionid = @versionid) and tbXMLQuizContent.XMLQuizID=tbQuizVersion.Quizid and tbQuizVersion.Versionid =@versionid
end
go
-- spGetQuizAndInfo @versionid=1
go
--Login
create procedure spLogin(
@Email varchar(60),
@Password varchar(60)
)
as begin
	select * from tbUser where tbUser.Email = @Email and tbUser.Password = @Password
end
go


-----------SELECTS------------

--Loads students by Class
--create procedure spGetStudents(
--@Classid int = null,
--@SecurityLevel int 
--)
--as begin
--	select './Pictures/' + UserPicture as UserPicture,Userid,Firstname, Lastname,Password,Classid,SecurityLevel,Email
--    from tbUser where tbUser.Classid = isnull(Classid, @Classid) and 
--	tbUser.SecurityLevel =1 and tbUser.SecurityLevel = @SecurityLevel
--end
--go

create procedure spGetStudents(
@Classid int = null
)
as begin
	select './Pictures/' + UserPicture as UserPicture,Userid,Lastname + ', ' + Firstname as Studentname,Password,Classid,SecurityLevel,Email
    from tbUser where tbUser.Classid = isnull(Classid, @Classid) and 
	tbUser.SecurityLevel =1 -- students
end
go

create procedure spGetStudents3(
@Classid int,
@SecurityLevel int 
)
as begin
	select './Pictures/' + UserPicture as UserPicture,Userid,Lastname + ', ' + Firstname as Studentname,Password,Classid,SecurityLevel,Email
    from tbUser where tbUser.Classid = @Classid and 
	tbUser.SecurityLevel =1 and tbUser.SecurityLevel = @SecurityLevel
end
go

--Difficulty
create procedure spGetDifficulty(
@Difficultyid int = null
)
as begin
	select * from tbDifficulty where tbDifficulty.Difficultyid = @Difficultyid
end 
go

--Loads Class
create procedure spLoadClass(
@CourseId int
)
as begin
	select tbClass.Classid, tbClass.Classname from tbClass
	left join tbCourse on tbCourse.Courseid = @CourseId
	where tbClass.Courseid = @CourseId
end
go
-- spLoadClass @CourseId = 1
go

--Loads Class
create procedure spGetClass(
@Classid int = null
)
as begin
	select * from tbClass where tbClass.Classid = @Classid
end
go

--Loads Course by Courseid
create procedure spGetCourse(
@Courseid int
)
as begin 
	select * from tbCourse where Courseid= @Courseid
end
go

--Load Course by Classid
create procedure spLoadCourse
as begin
	select * from tbCourse
end	
go

go

create procedure spLoadQuizes(
@Courseid int
)
as begin
	select XMLQuizID,Title,Subject,tbXMLQuizContent.CourseID,Time,DifficultyId from tbXMLQuizContent
	left join tbCourse on tbCourse.Courseid = tbXMLQuizContent.CourseID
	where tbXMLQuizContent.CourseID = @Courseid
end

go
-- spLoadQuizes @Courseid = 0;
go


--Load Quiz get it from versioning table and join it on tbXMLcontent
create procedure spLoadQuiz
as begin 
	select * from tbXMLQuizContent, tbQuizVersion
	where tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
end 
go

--Load Quiz by Courseid
create procedure spLoadQuiz2(
@Courseid int
)
as begin 
	select * from tbXMLQuizContent where tbXMLQuizContent.CourseID =@Courseid
end 
go

--Load Quiz by Quizid
create procedure spLoadQuiz5(
@Quizid int
)
as begin 
	select * from tbXMLQuizContent,tbDifficulty,tbQuizVersion 
	where tbXMLQuizContent.XMLQuizID = @Quizid and 
	tbDifficulty.Difficultyid = tbXMLQuizContent.DifficultyId and 
	tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
end 
go

--Loads Quiz
create procedure spLoadQuiz4
as begin
	select * from tbXMLQuizContent, tbQuizVersion 
	where tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
end
go
--Loads Version
create procedure spLoadVersion(
@QuizId int
)
as begin 
	select * from tbQuizVersion where Quizid = @QuizId
end 
go
spLoadVersion @QuizId = 111230123
go

--Loads the Quiz 
create procedure spViewQuiz
as begin 
	select tbXMLQuizContent.XMLQuizID, tbXMLQuizContent.Subject, tbXMLQuizContent.Time,
	       tbXMLQuizContent.DifficultyId, tbQuizVersion.Version, tbQuizVersion.Versionid
	from tbXMLQuizContent,tbQuizVersion
	where tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
	
end 
go


--Loads the Quiz Result (User side)
create procedure spViewQuizResults(
@Userid int
)

as begin 
	select * from tbQuizVersion, tbTestStudent, tbIssuedTest 
	where tbTestStudent.TestStudentid = @Userid and
	      tbQuizVersion.Versionid = tbIssuedTest.Versionid and
		  tbIssuedTest.IssuedTestId = tbTestStudent.IssuedTestId
end 
go

--Loads the Quiz Result of all students
create procedure spViewQuizResults2

as begin 
	select * from tbResults 
	
end 
go

--Loads Pending Quiz (student side)
 create procedure spViewPendingQuiz2(
 @Userid int
 )
as begin 
	select * from tbTestStudent,tbXMLQuizContent,tbDifficulty, tbIssuedTest
	where  Userid=@Userid and
	       tbTestStudent.IssuedTestId = tbIssuedTest.IssuedTestId and	      
	      tbXMLQuizContent.DifficultyId = tbDifficulty.Difficultyid
	end 
go

--spViewPendingQuiz2 @Userid=3
create procedure spInsertStudent(
@Firstname varchar(60),
@Lastname varchar(60),
@Password varchar(60),
@Classid int,
@SecurityLevel int
)
as begin
	insert into tbUser(Firstname,Lastname,Password,Classid,SecurityLevel)values
					  (@Firstname,@Lastname,@Password,@Classid,@SecurityLevel)
end
go

--Insert Difficulty
create procedure spInsertDifficulty(
@Difficultyname varchar(60)
)
as begin
	insert into tbDifficulty(Difficultyname)values
				(@Difficultyname)
end
go

----Insert Class

--Insert Course
create procedure spInsertCourse(
@Coursename varchar(60)
)
as begin 
	insert into tbCourse (Coursename) values
						 (@Coursename)
end
go

----------------UPDATES-------------

--Update Students
create procedure spUpdateStudent(
@Userid int = null,
@Firstname varchar (60),
@Lastname varchar (60),
@Password varchar (60),
@Classid int,
@SecurityLevel int
)
as begin
update tbUser set Firstname =@Firstname, Lastname=@Lastname, Password=@Password, 
		Classid=@Classid, SecurityLevel=@SecurityLevel
			 where tbUser.Userid = @Userid
end
go

--Update Difficulty
create procedure spUpdateDifficulty(
@Difficultyid int = null,
@Difficultyname varchar(60)
)
as begin
	update tbDifficulty set Difficultyname = @Difficultyname
	where Difficultyid =@Difficultyid
end 
go

--Update Class
create procedure spUpdateClass(
@Classid int = null,
@Classname varchar (60),
@Courseid int
)
as begin
update tbClass set Classname =@Classname, Courseid=@Courseid
			 where tbClass.Classid = @Classid
end
go

--Update Course
create procedure spUpdateCourse(
@Courseid int = null,
@Coursename varchar(60)
)
as begin
	update tbCourse set Coursename = @Coursename 
	where Courseid=@Courseid
end
go


-----------------DELETES----------------

--Delete Students

create procedure spDeleteStudent(
@Userid int = null
)
as begin
	delete from tbResults
	where tbResults.Userid = @Userid

	delete from tbQuizTaker
	where tbQuizTaker.Userid = @Userid

	delete from tbUser 
	where tbUser.Userid = @Userid
end
go

--Delete Difficulty
create procedure spDeleteDifficulty(
@Difficultyid int = null
)
as begin 
	delete from tbQuiz
	where tbQuiz.Difficulty =@Difficultyid

	delete from tbDifficulty 
	where tbDifficulty.Difficultyid = @Difficultyid
	
	delete from tbQuiz
	where tbQuiz.Difficulty = @Difficultyid
end 
go

--Delete Class
create procedure spDeleteClass(
@Classid int
)
as begin
	
	delete from tbClass 
	where tbClass.Classid = @Classid
end
go

--Delete Course
create procedure spDeleteCourse(
@Courseid int

)
as begin 
	delete from tbCourse 
	where tbCourse.Courseid =@Courseid
end 
go


----------------Settings-------------

--Update---
create procedure spUpdateSettings(
@Userid int = null,
@Firstname varchar (60),
@Lastname varchar (60),
@Password varchar (60),
@Classid int,
@SecurityLevel int
)
as begin
update tbUser set Firstname =@Firstname, Lastname=@Lastname, Password=@Password, 
		Classid=@Classid, SecurityLevel=@SecurityLevel
			 where tbUser.Userid = @Userid
end
go

create procedure spGetXml
as begin
select * from tbQuizVersion
end
go