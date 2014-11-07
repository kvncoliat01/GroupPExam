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
 ('Software & Database Developer'),('Accounting Specialist'),('Administrative Professional '),
 ('Business Administration'),('Casino / Resort / Event Coordinator'),('Legal Assistant'),
 ('Travel Counsellor'),('Veterinary Office Assistant'),('Network Administrator'),
 ('Enhanced Health Care Aide'),('Health Care Aide '),('Massage Therapy '),
('Medical Laboratory Assistant'),('Medical Office Assistant'),('Nursing Assistant'),
('Pharmacy Technician')
go

create table tbClass(
Classid int primary key identity (0,1),
Classname varchar(60),
Courseid int foreign key references tbCourse(Courseid)on delete cascade
)
go

insert into tbClass(Classname,Courseid)values
('SD18',0),('SD19',0),('SD20',0),
('AS01',1),('AS02',1),('AS03',1),
('AP12',2),('AP13',2),('AP14',2),
('BA23',3),('BA24',3),('BA25',3),
('CREC01',4),('CREC02',4),('CREC03',4),
('LA10',5),('LA11',5),('LA12',5),
('TC002',6),('TC003',6),('TC004',6),
('VOA1',7),('VOA2',7),('VOA3',7),
('NA001',8),('NA002',8),('NA003',8),
('EHCA31',9),('EHCA32',9),('EHCA3',9),
('HCA07',10),('HCA08',10),('HCA09',10),
('MT03',11),('MT04',11),('MT05',11),
('MLA022',12),('MLA023',12),('MLA024',12),
('MOA11',13),('MOA12',13),('MOA14',13),
('NA15',14),('NA16',14),('NA17',14),
('PT007',15),('PT008',15),('PT009',15)
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
Email varchar(60) Unique,
LostPass varchar(20)
)
go


insert into tbUser(Firstname,Lastname,Password,Classid,SecurityLevel,UserPicture,Email)values
('Kevin','Coliat','Kevin1',0,3,'kevin.jpg','kevin.coliat@robertsoncollege.net'),
('Doug','Jackson','pass',0,2,'SamplePicture2.jpg','Doug@yahoo.com'),
('Nupur','Singh','Nupur1',0,3,'Nupur.jpg','nupur.singh@robertsoncollege.net'),
('Janry','Alex','Janry1',0,1,'janry.jpg','janry.alex@robertsoncollege.net'),
('Adrian','Carter','Adrian1',0,1,'AdrianCarter2.jpg','adrian.carter@robertsoncollege.net'),
('Veberly','Carvalho','Veberly1',0,1,'veberly.jpg','veberly.carvalho@robertsoncollege.net'),
('Samuel','Gear','Samuel1',0,1,'Samuel.jpg','Samuel.Gear@robertsoncollege.net'),
('Nathaniel','Bosman','Nathaniel',0,1,'SamplePicture1.jpg','Nathaniel@robertsoncollege.net'),
('Micheala','Amor','Micheala1',0,1,'SamplePicture1.jpg','Micheala@robertsoncollege.net'),
('Bella','De Rosa','Bella1',0,1,'Bella.jpg','Bela@robertsoncollege.net'),
('James','Smith','James1',1,1,'James.jpg','James.Smith@robertsoncollege.net'),
('Arnold','De Gusman','Arnold1',1,1,'Arnold.jpg','Arnold@robertsoncollege.net'),
('Jenifer','Tiamzon','Jenifer1',1,1,'Jenifer.jpg','Jenifer@robertsoncollege.net'),
('Monica','Ybanez','Monica1',2,1,'Moinca.jpg','Monica@robertsoncollege.net'),
('Elizabeth','Ramsay','Elizabeth1',2,1,'Elizabeth.jpg','Elizabeth@robertsoncollege.net'),
('Zevy','Gordon','Zevy1',2,1,'Zevy.jpg','Zevy@robertsoncollege.net'),
('Daniel','Wawazaki','Daniel1',2,1,'Daniel.jpg','Daniel@robertsoncollege.net'),
('Corazon','Zilva','Corazon1',3,1,'Corazon.jpg','Corazon@robertsoncollege.net'),
('Lulaby','Camaron1','Lulaby1',3,1,'Camaron.jpg','Camaron@robertsoncollege.net'),
('Stephanie','Stephanie','Stephanie1',3,1,'Stephanie.jpg','Stephanie@robertsoncollege.net'),
('Jackson','Switz','Jackson1',4,1,'Jackson.jpg','Jackson@robertsoncollege.net'),
('Bernard','Wisk','Bernard1',4,1,'Bernard.jpg','Bernard@robertsoncollege.net'),
('Ariala','Wisdom','Wisdom1',4,1,'Ariala.jpg','Ariala@robertsoncollege.net'),
('Jinky','Swamm','Jinky1',5,1,'Jinky.jpg','Jinky@robertsoncollege.net'),
('Ricky','Salvador','Ricky1',5,1,'Ricky.jpg','Ricky@robertsoncollege.net'),
('Roxanne','Cornejo','Roxanne1',5,1,'Roxanne.jpg','Roxanne@robertsoncollege.net'),
('Dave','Jones','Dave1',6,1,'dave.jpg','dave.alex@robertsoncollege.net'),
('Steven','De','Seven1',6,1,'Steven.jpg','Steven@robertsoncollege.net'),
('Clariza','Winx','Clariza1',6,1,'Clariza.jpg','Clariza@robertsoncollege.net'),
('Janelle','Hawla','Janelle1',7,1,'Janelle.jpg','Janelle@robertsoncollege.net'),
('Joshua','Mayer','Joshua',7,1,'Joshua.jpg','Joshua@robertsoncollege.net'),
('Melanie','Strong','Melanie1',7,1,'Melanie.jpg','Melanie@robertsoncollege.net'),
('Allysha','Bell','Allysha1',8,1,'Allysha.jpg','Allysha@robertsoncollege.net'),
('Alexis','Sandra','Alexis1',8,1,'Alexis.jpg','Alexis@robertsoncollege.net'),
('Scott','Anderson','Scott1',8,1,'Scott.jpg','Scott@robertsoncollege.net'),
('Cassandra','Morlin','Cassandra1',9,1,'Cassandra.jpg','Cassandra@robertsoncollege.net'),
('RoseMarie','','RoseMarie1',9,1,'RoseMarie.jpg','RoseMarie@robertsoncollege.net'),
('Andrew','Ong','Andrew1',9,1,'Andrew.jpg','Andrew.Ong@robertsoncollege.net'),
('Jezel','De Jesus','Jezel1',10,1,'Jezel.jpg','Jezel@robertsoncollege.net'),
('Rogelio','Bentura','Rogelio1',10,1,'Rogelio.jpg','Rogelio@robertsoncollege.net'),
('Rosalie','Zamora','Rosalie1',10,1,'Rosalie.jpg','Rosalie@robertsoncollege.net'),
('JhonMark','Escouzora','JhonMark1',11,1,'JhonMark.jpg','JhonMark@robertsoncollege.net'),
('Kenneth','Cacerez','Kenneth1',11,1,'Kenneth.jpg','Kenneth@robertsoncollege.net'),
('Albert','Morello','Albert1',11,1,'Albert.jpg','Albert@robertsoncollege.net'),
('Claire','Tabat','Claire1',12,1,'Claire.jpg','Claire@robertsoncollege.net'),
('Benmarie','Salhay','Benmarie1',12,1,'Benmarie.jpg','Benmarie@robertsoncollege.net'),
('Cherry','Priolo','Cherry1',12,1,'Cherry.jpg','Cherry@robertsoncollege.net'),
('Stanley','Smith','Stanley1',13,1,'Stanley.jpg','Stanley@robertsoncollege.net'),
('Erwin','Gomes','Erwin1',13,1,'Erwin.jpg','Erwin@robertsoncollege.net'),
('Mary Grace','Arby','Mary Grace1',13,1,'Mary Grace.jpg','MG@robertsoncollege.net'),
('Samantha','Hauwla','Samantha1',13,1,'Samantha.jpg','Samantha@robertsoncollege.net')

go
create table tbToken(
Tokenid int primary key identity (0,1),
TToken varchar(50),
TUserid int foreign key references tbUser(Userid)
)
go


create table tbQuizStatus(
StatusId int primary key identity (0,1),
StatusName varchar(10)
)

insert into tbQuizStatus values
('Offline'),		-- 0
('Online'),			--1 
('Completed')			--2

create table tbQuizStudentStatus(
StatusId int primary key identity (0,1),
StatusName varchar(10))

insert into tbQuizStudentStatus values
('Not taken'),		-- 0
('Incomplete'),			--1 
('Completed'),			--2
('Ongoing')				--3

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
create table tbIssuedQuiz(		-- issued quiz and its statuses,
IssuedQuizId int primary key identity(0,1),
Versionid int foreign key references tbQuizVersion(Versionid), -- actual quiz, has XMLQUIzContent and Version
ClassId int foreign key references tbClass(Classid),		-- users who will take the test!
DateIssued date,
Mentorid int foreign key references tbUser(Userid),
QuizStatus int foreign key references tbQuizStatus(StatusId)
)

create table tbQuizStudent(			
QuizStudentid int primary key identity (0,1), -- just the id nothing else
IssuedQuizId int foreign key references tbIssuedQuiz(IssuedQuizId), 
Userid int foreign key references tbUser(Userid),  ---Student
XMLStudentResponse xml, 
Status int foreign key references tbQuizStudentStatus(StatusId),
Points decimal(5,2) null   -- results or number of correct responses by each student
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
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="111230123" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testtitle</Title><Subject>tsubh</Subject><Course>Software Developer</Course><Time>15</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice> <Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="111230123" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testtitle</Title><Subject>tsubh</Subject><Course>Software Developer</Course><Time>25</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0" encoding="utf-8"?><Quiz QuizId="9999" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>testNetwork</Title><Subject>tsubh</Subject><Course>Network Engineering</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>what is?</Questi><Options><Option>a</Option><Option Correct="yes">b</Option><Option>c</Option><Option>d</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml = '<?xml version="1.0"?><Quiz QuizId="570748" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>Yow </Title><Subject>YowS</Subject><Course>Software Developer</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>What is ?</Questi><Options><Option>a</Option><Option>3b</Option><Option Correct="yes">4x</Option><Option>5a</Option></Options></Question><Question ID="2"><Questi>Who is</Questi><Options><Option Correct="yes">zxcasd</Option><Option>4asdasd</Option><Option>5qwe</Option><Option>6asda</Option></Options></Question><Question ID="3"><Questi>What kind of?</Questi><Options><Option>4zxc</Option><Option>5asd</Option><Option Correct="yes">6qw</Option><Option>7qe</Option></Options></Question><Question ID="4"><Questi>Where is?</Questi><Options><Option>1asd</Option><Option>2xzcasd</Option><Option Correct="yes">3asd</Option><Option>5qwe</Option></Options></Question><Question ID="5"><Questi>add ?</Questi><Options><Option Correct="yes">sad</Option><Option>asd</Option><Option>qw</Option><Option>qeqwe</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
spInsertXMLContent @xml ='<?xml version="1.0"?><Quiz QuizId="249747" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>test2</Title><Subject>test2</Subject><Course>Software Developer</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>test2</Questi><Options><Option>test2</Option><Option>test2</Option><Option>test2</Option><Option Correct="yes">tewst</Option></Options></Question><Question ID="2"><Questi>xzcase</Questi><Options><Option Correct="yes">asdqweqweqw</Option><Option>asdase</Option><Option>eas</Option><Option>dqwe</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>'
go
select * from tbXMLQuizContent
select * from tbCourse
select * from tbQuizVersion
select * from tbUser
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

create procedure spIssueNewQuiz(
@Versionid int,
@Mentorid int,
@ClassId int
)
as begin
begin transaction

if not EXISTS(select * from tbIssuedQuiz where Versionid = @Versionid and ClassId = @ClassId)
	begin
	begin transaction
		if EXISTS (select * from tbUser where SecurityLevel != 1 and Userid = @Mentorid)
			begin
			insert into tbIssuedQuiz values(@Versionid,@ClassId,GETDATE(),@Mentorid,0)
			select @@IDENTITY as IssuedQuizId
			end
		else
		begin
			select 'Insufficient Level' status
		end
	commit transaction
	end
else
	begin
	select 'TestExists' as status
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

create procedure spIssueNewQuizStudent(
@IssuedQuizId int,
@UserId int,
@XMLStudentResponse xml
)
as
 begin
begin transaction

	--set @getxml = (select tbQuizVersion.XmlFile from tbIssuedQuiz
	--join tbQuizVersion on tbQuizVersion.Versionid = tbIssuedQuiz.Versionid
	--where tbIssuedQuiz.IssuedQuizId = @IssuedQuizId)

	--;WITH XMLNAMESPACES (N'urn:Question-Schema' as ns)
	--(select @xmlMultipleCount = (select @getxml.value('count(/ns:Quiz/ns:Questions/ns:MultipleChoice/ns:Question)','int') as Count))
	--select @getxml as XML, @xmlMultipleCount as MultipleCount
	
	if not EXISTS(select * from tbQuizStudent where IssuedQuizId = @IssuedQuizId and Userid = @UserId and Status != 0)
	begin
		insert into tbQuizStudent values (@IssuedQuizId,@UserId,@XMLStudentResponse,0,null)
	end
	else
	begin
		update tbQuizStudent set XMLStudentResponse = @XMLStudentResponse where IssuedQuizId = @IssuedQuizId and Userid = @UserId
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
create procedure spStartQuiz(
@IssuedQuizId int
)
as begin
if EXISTS(select * from tbIssuedQuiz where IssuedQuizId=@IssuedQuizId and QuizStatus != 1)
	begin
	update tbIssuedQuiz set QuizStatus = 1 where IssuedQuizId = @IssuedQuizId
	select 'Activated' as status
	end
else
begin
	select 'error' as status
end
end

go
create procedure spStartQuizStudent (
@UserId int,
@QuizStudentId int
)
as declare
@IssuedQuizId int = -1
begin
begin tran
set @IssuedQuizId = (select IssuedQuizId from tbQuizStudent where Userid = @UserId and QuizStudentid = @QuizStudentId)

if EXISTS(select * from tbIssuedQuiz where @IssuedQuizId != -1 and IssuedQuizId = @IssuedQuizId and QuizStatus = 1) -- The IssuedQuiz status must be active first
begin
	if EXISTS(select * from tbQuizStudent where Userid = @UserId and QuizStudentid = @QuizStudentId)
	begin
	update tbQuizStudent set Status= 3 where Userid = @UserId and QuizStudentid = @QuizStudentId
	select XMLStudentResponse from tbQuizStudent where Userid = @UserId and QuizStudentid = @QuizStudentId
	end
	else
	begin
	select 'invalid Quiz' as status
	end
end
else
begin
select 'QuizNotActive' as status
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
-- spIssueNewQuizStudent @IssuedQuizId=0, @UserId = 3
go
spIssueNewQuiz @Versionid = 0, @ClassId = 1, @Mentorid =0
select * from tbQuizStatus 
select * from tbIssuedQuiz
select * from tbQuizStudent
select * from tbUser
select * from tbQuizStudentStatus
select * from tbQuizVersion
select * from tbXMLQuizContent

insert into tbQuizStudent values (0,7,'<?xml version="1.0"?><Quiz QuizId="570748" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema"><Details><Title>Yow </Title><Subject>YowS</Subject><Course>Software Developer</Course><Time>31</Time><Difficulty>Intermediate</Difficulty></Details><Questions><MultipleChoice><Question ID="1"><Questi>What is ?</Questi><Options><Option>a</Option><Option>3b</Option><Option Correct="yes">4x</Option><Option>5a</Option></Options></Question><Question ID="2"><Questi>Who is</Questi><Options><Option Correct="yes">zxcasd</Option><Option>4asdasd</Option><Option>5qwe</Option><Option>6asda</Option></Options></Question><Question ID="3"><Questi>What kind of?</Questi><Options><Option>4zxc</Option><Option>5asd</Option><Option Correct="yes">6qw</Option><Option>7qe</Option></Options></Question><Question ID="4"><Questi>Where is?</Questi><Options><Option>1asd</Option><Option>2xzcasd</Option><Option Correct="yes">3asd</Option><Option>5qwe</Option></Options></Question><Question ID="5"><Questi>add ?</Questi><Options><Option Correct="yes">sad</Option><Option>asd</Option><Option>qw</Option><Option>qeqwe</Option></Options></Question></MultipleChoice><FillBlanks /><TrueFalse /><longAnswer /></Questions></Quiz>',0,null)

go
create procedure spGetQuizStudentByStudent(
@UserId int
)
as begin
if Exists(select * from tbQuizStudent where Userid = @UserId and IssuedQuizId in (select IssuedQuizId from tbIssuedQuiz where QuizStatus = 1) ) -- ongoing
	begin
		select QuizStudentid,Title,Subject, Time from tbQuizStudent
		join tbIssuedQuiz on tbIssuedQuiz.IssuedQuizId = tbQuizStudent.IssuedQuizId
		join tbQuizVersion on tbQuizVersion.Versionid = tbIssuedQuiz.Versionid
		join tbXMLQuizContent on tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
		where Userid = @UserId
	end
else
	begin
	select 'Empty' status
	end
end
go
-- spStartQuiz @IssuedQuizId = 0
-- spGetQuizStudentByStudent @UserId=7
-- spStartQuizStudent @UserId= 7,@QuizStudentId= 0

go
create procedure spGetIssuedQuizByMentor (
@Userid int
)
as begin
if EXISTS(select * from tbUser where Userid= @Userid and SecurityLevel != 1)
begin
	select * from tbIssuedQuiz
	join tbClass on tbClass.Classid = tbIssuedQuiz.ClassId
	join tbQuizVersion on tbQuizVersion.Versionid = tbIssuedQuiz.Versionid
	join tbQuizStatus on tbQuizStatus.StatusId = tbIssuedQuiz.QuizStatus
	join tbXMLQuizContent on tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid
	join tbCourse on tbCourse.Courseid = tbXMLQuizContent.CourseID
	where tbIssuedQuiz.Mentorid = @Userid
	 end
end
go
spGetIssuedQuizByMentor @Userid= 0
go

create procedure getIssuedQuizDetails(
@IssuedQuizId int
)
as begin
select IssuedQuizId,Classname,Title,Time,QuizStatus,StatusName from tbIssuedQuiz
join tbQuizVersion on tbQuizVersion.Versionid = tbIssuedQuiz.Versionid
join tbClass on tbClass.Classid = tbIssuedQuiz.ClassId
join tbQuizStatus on tbQuizStatus.StatusId = tbIssuedQuiz.QuizStatus
join tbXMLQuizContent on tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid

 where IssuedQuizId = @IssuedQuizId
end
go

go
create procedure spForgotPassword(
@EmailAddress varchar (50)
)
as declare
@message varchar (50),
@Token varchar (50)='notExists'
begin
begin transaction
if Exists (select 1 from tbUser where Email = @EmailAddress)
begin 
while not Exists (select 1 from tbUser where LostPass = @Token)
begin 
SELECT @Token = (select char(rand()*26+65)+char(rand()*26+65)+char(rand()*26+65)
+char(rand()*26+65)+char(rand()*26+65)+char(rand()*26+65)
+char(rand()*26+65)+char(rand()*26+65)+char(rand()*26+65)
+char(rand()*26+65)+char(rand()*26+65)+char(rand()*26+65)
+char(rand()*26+65)+char(rand()*26+65)+char(rand()*26+65))
update tbUser set LostPass=@Token where Email=@EmailAddress
set @Message = 'CheckMail'
end
end
else
begin
set @Message = 'EmailInvalid'
end
if @@ERROR != 0
begin
ROLLBACK TRANSACTION
select @Message as message
end
else 
begin
commit transaction
select @Message as message, @Token as Token
end
end
go
--spCheckToken @Token= 'COSNMXEDEEDMSAK'
create procedure spCheckToken(
@Token varchar(20)
)
as begin
if exists(select 1 from tbUser where LostPass=@Token)
begin
select 'true' as exist
end
else
begin
select 'false' as exist
end
end
go

--spChangePass @Token='UMZSWKHAOMWHWVC', @NewPass = 'new'
go
create procedure spChangePassWord(
@Token varchar(20),
@NewPass varchar(60)
)
as declare
@message varchar(60)
 begin
begin transaction
if Exists(select 1 from tbUser where LostPass = @Token)
begin
	update tbUser set password=@NewPass, LostPass=null where LostPass=@Token
	set @message = 'success'
end
else
begin
	set @message='invalid token'
end
if @@ERROR != 0
        begin
            ROLLBACK TRANSACTION
			select @message as message
		end
else 
	begin
        commit transaction
		select @message as message
    end
end
go
create procedure spGetStudentInfo(
@Userid int 
)
as
begin
select Userid,'./Pictures/' + UserPicture as UserPicture,Firstname,Lastname,Classid,Email 
from tbUser
where Userid = @Userid
end
go


go
create procedure spGetStudents(
@Classid int = null,
@Userid int = null
)
as begin
	select './Pictures/' + UserPicture as UserPicture,
	Userid,Lastname, Classname, Coursename,
	Firstname,Password, tbClass.Classid, SecurityLevel,Email
    from  tbUser, tbCourse, tbClass 
	where tbUser.Classid = isnull(@Classid, tbUser.Classid) and 
	      tbUser.Userid = isnull(@Userid, tbUser.Userid) and
	      tbUser.Classid = tbClass.Classid and
		  tbClass.Courseid = tbCourse.Courseid and
		  tbUser.SecurityLevel = 1
	    
end
go

create procedure spGetUsers(
@Classid int = null,
@Userid int = null
)
as begin
	select './Pictures/' + UserPicture as UserPicture,
	Userid,Lastname, Classname, Coursename,
	Firstname,Password, tbClass.Classid, SecurityLevel,Email
    from  tbUser, tbCourse, tbClass 
	where tbUser.Classid = isnull(@Classid, tbUser.Classid) and 
	      tbUser.Userid = isnull(@Userid, tbUser.Userid) and
	      tbUser.Classid = tbClass.Classid and
		  tbClass.Courseid = tbCourse.Courseid
	    
end
go


create procedure spLoadAllStudentClass(
@Classid int
)
as begin
select './Pictures/' + UserPicture as UserPicture,
	Userid,Lastname + ', ' + Firstname as Studentname, Classname, Coursename,
	Firstname,Password, tbClass.Classid, SecurityLevel,Email
    from  tbUser, tbCourse, tbClass 
	where tbUser.Classid = isnull(tbUser.Classid, @Classid) and 
	      tbUser.Classid = tbClass.Classid and
		  tbClass.Courseid = tbCourse.Courseid and
	      tbUser.SecurityLevel = 1 -- students 
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
@CourseId int = null
)
as begin
	select tbClass.Classid, tbClass.Classname, Coursename
	from tbClass, tbCourse
	--left join tbCourse on tbCourse.Courseid = @CourseId
	where tbClass.Courseid = @CourseId and
	      tbclass.Courseid = tbCourse.Courseid
end
go
-- spLoadClass @CourseId = 1
go

--Loads Class
create procedure spGetClass(
@Classid int = null
)
as begin
	select * from tbClass
	 where Classid = isnull(@Classid, Classid)
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
@Courseid int = null
)
as declare
@CourseIdNotEmpty int
 begin
 if(@Courseid != null and @Courseid = -1)
 begin
 set @CourseIdNotEmpty = null
 end
	select XMLQuizID,Title,Subject,tbXMLQuizContent.CourseID,Time,DifficultyId from tbXMLQuizContent
	left join tbCourse on tbCourse.Courseid = tbXMLQuizContent.CourseID
	where tbXMLQuizContent.CourseID = ISNULL(@CourseIdNotEmpty,tbXMLQuizContent.CourseID)
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
	       tbXMLQuizContent.Title,
	       tbXMLQuizContent.DifficultyId, tbQuizVersion.Version, tbQuizVersion.Versionid,
		   tbDifficulty.Difficultyname
	from tbXMLQuizContent,tbQuizVersion, tbDifficulty
	where tbXMLQuizContent.XMLQuizID = tbQuizVersion.Quizid and
	      tbXMLQuizContent.DifficultyId = tbDifficulty.Difficultyid
	
end 
go


--Loads the Quiz Result (User side)
create procedure spViewQuizResults(
@Userid int
)

as begin 
	select * from tbQuizVersion, tbQuizStudent, tbIssuedQuiz 
	where tbQuizStudent.QuizStudentid = @Userid and
	      tbQuizVersion.Versionid = tbIssuedQuiz.Versionid and
		  tbIssuedQuiz.IssuedQuizId = tbQuizStudent.IssuedQuizId
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
	select * from tbQuizStudent,tbXMLQuizContent,tbDifficulty, tbIssuedQuiz
	where  Userid=@Userid and
	       tbQuizStudent.IssuedQuizId = tbIssuedQuiz.IssuedQuizId and	      
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

--Update Users
create procedure spUpdateUser(
@Userid int,
@Firstname varchar (60),
@Lastname varchar (60),
@Password varchar (60),
@Email varchar (60),
@Classid int,
@SecurityLevel int
)
as begin
update tbUser set Firstname =@Firstname, Lastname=@Lastname, Password=@Password, 
		Classid=@Classid, SecurityLevel=@SecurityLevel, Email = @Email
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

    delete from tbQuizStudent
	where tbQuizStudent.Userid = @Userid

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

---------------------------------------------------

create table tbTestSample(
TestSampleid int primary key identity(0,1),
XMLQuiz xml
)
go

insert into tbTestSample(XMLQuiz)values
('<Quiz xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:Question-Schema" QuizId="111230123">
  <?xml-stylesheet type="text/xsl" href="Quiz.xsl"?>
  <Details>
    <Title>testtitle</Title>
    <Subject>tsubh</Subject>
    <Course>Software Developer</Course>
    <Time>25</Time>
    <Difficulty>Intermediate</Difficulty>
  </Details>
  <Questions>
    <MultipleChoice>
      <Question ID="1">
        <Questi>What is the fastest mammal?</Questi>
        <Options>
          <Option>a.Lion </Option>
          <Option Correct="yes">b. Cheetah</Option>
          <Option>c. Kangaroo</Option>
          <Option>d. Turtle</Option>
        </Options>
      </Question>
	  <Question ID="2">
        <Questi>Whats up?</Questi>
        <Options>
          <Option>a. Good</Option>
          <Option Correct="yes">b. Great</Option>
          <Option>c. Bad</Option>
          <Option>d. Not feeling well</Option>
        </Options>
      </Question>
	  <Question ID="3">
        <Questi>Whats your name?</Questi>
        <Options>
          <Option>a. Kevin</Option>
          <Option Correct="yes">b. Janry</Option>
          <Option>c. Bebz</Option>
          <Option>d. Adrian</Option>
        </Options>
      </Question>
    </MultipleChoice>
    <FillBlanks />
    <TrueFalse />
    <longAnswer />
  </Questions>
</Quiz>')

go

select * from tbTestSample
go
create procedure spGetTestSample
as begin
	select * from tbTestSample
end 
go