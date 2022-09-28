use blooddonors
go

insert [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (1, 'Al-Amin', 'Dhaka')
GO
insert [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (2, 'Masud Sheikh', 'Nilfamari')
GO
insert [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (3, 'Ripon Sheikh', 'Jamalpur')
GO
insert [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (4, 'Hemayet Molla', 'Madaripur')
GO
insert [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (5, 'Mujtoba Mahmud', 'Meherpur')
GO

insert [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (1, 'National Heart Foundation')
GO
insert [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (2, 'Prime Hospital')
GO
insert [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (3, 'Kidney Foundation')
GO
insert [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (4, 'Square Hospital Bangladesh')
GO
insert [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (5, 'Ever Care')
GO

insert [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (1, 'Mamun Hasan', 'B+', 'Mirpur, Dhaka', 1000.0000, 1)
GO
insert [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (2, 'Rajab Sheikh', 'A+', 'Uttara, Dhaka', 150000.0000, 2)
GO
insert [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (3, 'Mahidul Molla', 'O-', 'Dhanmondi, Dhaka', 200000.0000, 3)
GO
insert [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (4, 'Masud Rana', 'AB+', 'Savar, Dhaka', 25000.0000, 4)
GO
USE [blooddonors]
GO
insert [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (1, 1, 1, CAST('2022-08-01 12:00:00.000' AS DateTime))
GO
insert [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (2, 2, 3, CAST('2022-05-01 22:00:00.000' AS DateTime))
GO
insert [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (3, 3, 4, CAST('2022-09-02 18:00:00.000' AS DateTime))
GO
insert [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (4, 4, 2, CAST('2022-010-01 11:00:00.000' AS DateTime))
GO
--procedure
EXEC spInsertDonors  'Amirul', 'Keranigonj'
 GO
insert * FROM donors
 GO
EXEC spUpdateDonors 6, 'Amirul Islam', 'Keranigonj, Dhaka'
 GO
insert * FROM donors
GO
EXEC  spDeleteDonors 6
GO
insert * FROM donors
GO
EXEC spInsertHospitals 'Medicare'
GO
insert * FROM hospitals
GO
EXEC spUpdateHospitals 6, 'Medicare Hospital'
GO
insert * FROM hospitals
GO
EXEC spDeleteHospitals 6
GO
insert * FROM hospitals
GO
EXEC spInsertpatients 'Abdul Alim', 'A+','Mirpur, Dhaka',21000,5
GO
insert * FROM patients
GO
EXEC spUpdatepatients 5, 'Abdul Alim', 'AB+','Mirpur-1, Dhaka',21000,5
GO
insert * FROM patients
GO
EXEC spDeletepatients 5
GO
insert * FROM patients
GO
EXEC spInsertPatiantDonors 5 ,4, '2022-03-14'	
GO
insert * FROM patiantDonors
GO
EXEC spDeletePatiantDonors 5
GO
insert * FROM patiantDonors
GO
--views
insert * FROM vPatiantDetails
GO
insert * FROM vAvailableDonors
GO
--udf
insert * FROM fnDonationDetails(1)
GO
insert dbo.fnpatients('A+')
go
--trigger
EXEC spInsertDonors  'Amirul', 'Keranigonj'
 GO
EXEC spInsertPatiantDonors 5 ,4, '2022-03-1'	
GO
insert * FROM donors
GO
insert * FROM patiantDonors
GO
insert [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (6, 5, 1, '2022-03-14') --cannot donate in 90 days
go
insert * FROM patiantDonors
GO
/*
 * --Queries added
 */
/***	 1 Join Inner	***/

select d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
GO

/***	 2 filter blod grpup		***/

select d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
WHERE p.bloodGroup = 'O-'
GO

/***	3 filter hosptal	***/

select d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
WHERE h. hospitalName = 'National Heart Foundation'
GO

/***	 4 outer (right)	***/

select d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
inner join patiantDonors AS pd ON p.patiantID = pd.patiantID 
inner join hospitals AS h ON p.hospitalID = h.hospitalID 
right outer join donors AS d ON pd.donorID = d.donorID
GO
/***	 5 rewrite 4 with cte	***/
 
WITH cteall AS
(

select  pd.donorID, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
inner join patiantDonors AS pd ON p.patiantID = pd.patiantID 
inner join hospitals AS h ON p.hospitalID = h.hospitalID 
)
select d.donorName, c.patiantName, c.bloodGroup, c.patiantAddress, c.hospitalName, c.timeOfDonation
FROM cteall c
right outer join donors d ON c.donorID=d.donorID
GO

/***	6 outer (right) not matched		***/
 
select  d.donorName, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
inner join patiantDonors AS pd ON p.patiantID = pd.patiantID 
inner join hospitals AS h ON p.hospitalID = h.hospitalID 
right outer join donors AS d ON pd.donorID = d.donorID
WHERE pd.donorID IS NULL
GO

/***	 7 sme 6 with sub-query		***/
 
select  d.donorName, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
inner join patiantDonors AS pd ON p.patiantID = pd.patiantID 
inner join hospitals AS h ON p.hospitalID = h.hospitalID 
right outer join donors AS d ON pd.donorID = d.donorID
WHERE d.donorID NOT IN (select donorID FROM patiantDonors)
GO

/***	 8 aggregate	***/
 
select d.donorName, count(pd.donorID)
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName
GO
select d.donorName, p.bloodGroup, count(pd.donorID)
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName,  p.bloodGroup
GO

/***	 9 aggregate+having		***/
 
select d.donorName, count(pd.donorID)
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName,  p.bloodGroup
HAVING p.bloodGroup = 'AB+'
GO

/***	10 windowing function	***/
 
select d.donorName, 
 count(pd.donorID) OVER(ORDER BY d.donorID) 'count',
 ROW_NUMBER() OVER(ORDER BY d.donorID) 'number',
 RANK() OVER(ORDER BY d.donorID) 'rank',
 DENSE_RANK() OVER(ORDER BY d.donorID) 'denserank',
 NTILE(3) OVER(ORDER BY d.donorID) 'ntile(3)'
FROM donors d
inner join patiantDonors pd ON d.donorID = pd.donorID 
inner join patients p ON pd.patiantID = p.patiantID 
inner join  hospitals h ON p.hospitalID = h.hospitalID
GO

/***	11 CASE .. WHEN...END	***/
 
select
	WHEN p.patiantName IS NULL THEN 'nil'
	ELSE p.patiantName
END 'patiantName'
FROM   patients AS p 
inner join patiantDonors AS pd ON p.patiantID = pd.patiantID 
inner join hospitals AS h ON p.hospitalID = h.hospitalID 
right outer join donors AS d ON pd.donorID = d.donorID