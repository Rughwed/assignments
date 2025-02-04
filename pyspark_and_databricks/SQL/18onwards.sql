--display empname,terriroty name,group,saleslastyear salesquota,bonus
use AdventureWorks2022;
select * from Sales.SalesPerson
select * from Sales.SalesTerritory
select * from Person.Person

Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) fullname,
	   (select [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
	   from Sales.SalesPerson ss;

--display empname,terriroty name,group,saleslastyear salesquota,bonus from Germeny and UK
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname,
	   (select  [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select Name from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) cname,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) slast,
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) squota,
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE Name IN ('Germany', 'United Kingdom'));

--find all employees who worked in all North America territory
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE [Group] = 'North America');

--find the product detail in cart
select * from Sales.ShoppingCartItem
select *from Production.Product

select * from Production.Product
where ProductID in
(select ProductID
from Sales.ShoppingCartItem);

--find the product with special offer
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product


select
p.productid,
p.name as prodname,
sop.specialofferid
from production.product p,
Sales.SpecialOfferProduct sop
where p.ProductID = sop.ProductID;

--.job title, card details whose credit card expired in the month 11 and year as 2008

select 
(select JobTitle from HumanResources.Employee e where e.BusinessEntityID=pcc.BusinessEntityID)jobtitle,
(select FirstName from Person.Person p where p.BusinessEntityID=pcc.BusinessEntityID)fname,
(select CardNumber from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)cno,
(select ExpMonth from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)expm,
(select ExpYear from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)expy
from Sales.PersonCreditCard pcc 
where pcc.CreditCardID in (select CreditCardID from sales.CreditCard crd where ExpMonth = 11 and ExpYear =2008)

--20. Find the employee whose payment might be revised  (Hint : Employee payment history)

--joins
--21.Find the personal details with address and address 
--type(hint: Business Entiry Address , Address, Address type)

select p.FirstName,p.LastName,a.AddressLine1,at.AddressTypeID
from Person.BusinessEntityAddress ba,
Person.Address a,
Person.Person p,
Person.AddressType at
where a.AddressID = ba.AddressID and
at.AddressTypeID = ba.AddressTypeID 
and p.BusinessEntityID = ba.BusinessEntityID

--22. Find the name of employees working in group of North America territory
select p.FirstName,p.LastName,t.Name,t.[group] from Person.Person p,
Sales.SalesTerritory t,
Sales.SalesTerritoryHistory th
where t.TerritoryID = th.TerritoryID and
th.BusinessEntityID = p.BusinessEntityID
and t.[Group] = 'North America'


--24. display the personal details of  employee whose payment is revised for more than once.
SELECT e.BusinessEntityID,p.FirstName,p.LastName,COUNT(*) as rev
FROM HumanResources.EmployeePayHistory e,
Person.Person p
where p.BusinessEntityID = e.BusinessEntityID
GROUP BY e.BusinessEntityID,p.FirstName,p.LastName
HAVING COUNT(*) > 1;

--26. check if any employee from jobcandidate table is having any payment revisions
select  e.BusinessEntityID,p.FirstName,p.LastName,count(*) as rev
from HumanResources.JobCandidate j,
HumanResources.EmployeePayHistory e	,
Person.Person p
where e.BusinessEntityID = j.BusinessEntityID
and j.BusinessEntityID = p.BusinessEntityID
group by  e.BusinessEntityID,p.FirstName,p.LastName
having count(*)>0 

--27.check the department having more salary revision

select d.Name,count(*) rev
from HumanResources.EmployeePayHistory ph,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Department d
where dh.BusinessEntityID = ph.BusinessEntityID and
d.DepartmentID = dh.DepartmentID
group by d.Name
order by count(*) desc

--check the employee whose payment is not yet revised
select * from Person.Person where BusinessEntityID not in 
(select BusinessEntityID from HumanResources.EmployeePayHistory
)

--29. find the job title having more revised payments
select e.JobTitle,count(* )
from HumanResources.EmployeePayHistory ph,
HumanResources.Employee e
where e.BusinessEntityID = ph.BusinessEntityID
group by e.JobTitle
order by count(*) desc

--31. find the colour wise count of the product (tbl: product)

select Color,count(*) prodt_c
from Production.Product
group by Color

--32. find out the product who are not in position to sell 
--(hint: check the sell start and end date)
select name,SellEndDate
from Production.Product
where SellEndDate is not null

--33.  find the class wise, style wise average standard cost

select class,Style ,avg( StandardCost) av_sc
from Production.Product 
where Class is not null and Style is not null
group by class,style

--check colour wise standard cost
select Color,sum(StandardCost) total
from Production.Product
group by color


--35. find the product line wise standard cost

 select ProductLine,sum(StandardCost)total
 from Production.Product
 where ProductLine is not null
 group by ProductLine

 -- 36.Find the state wise tax rate 
 --(hint: Sales.SalesTaxRate, Person.StateProvince)

 select * from Sales.SalesTaxRate
 select * from Person.StateProvince

select sp.StateProvinceID,sum(TaxRate)total 
from Sales.SalesTaxRate tr,
Person.StateProvince sp
where sp.StateProvinceID = tr.StateProvinceID
group by sp.StateProvinceID

--38.Calculate the age of employees
select p.FirstName,p.LastName,datediff(year,BirthDate,GETDATE())age
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by age desc

--39.Calculate the year of experience of the employee based on hire date
select p.FirstName,p.LastName,datediff(year,HireDate,GETDATE())exp
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by exp desc

--40.Find the age of employee at the time of joining
select p.FirstName,p.LastName,datediff(year,BirthDate,HireDate)Age_hire
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by Age_hire desc

--41.Find the average age of male and female
select gender,avg(datediff(year,BirthDate,GETDATE())) avg_age
from HumanResources.Employee 
group by gender

--42. Which product is the oldest product as on the date 
--(refer  the product sell start date)

select top(1) ProductID,Name,DATEDIFF(DAY,SellStartDate,getdate()) prod_age
from Production.Product
order by prod_age desc