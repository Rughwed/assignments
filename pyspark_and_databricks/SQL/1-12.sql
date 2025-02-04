use AdventureWorks2022;

--1)find the average currency rate conversion from USD to Algerian Dinar 
--and Australian Doller 

select * from Sales.CurrencyRate 
select * from sales.Currency where Name ='Algerian Dinar'

select cr.ToCurrencyCode ,cr.FromCurrencyCode,avg(AverageRate)
from Sales.CurrencyRate cr,
sales.Currency c
where ToCurrencyCode in ('DZD','AUD')
group by  cr.ToCurrencyCode ,cr.FromCurrencyCode

--2)Find the products having offer on it and display product name , safety Stock Level, Listprice,and product model id, 
--type of discount,  percentage of discount,  offer start date and offer end date

select * from Sales.SpecialOffer
select * from Production.Product

select pp.Name,pp.SafetyStockLevel,pp.ListPrice,pp.ProductModelID,so.Type,so.DiscountPct,so.StartDate,so.EndDate
from sales.SpecialOffer as so,
Sales.SpecialOfferProduct as sop,
Production.Product as pp
where pp.ProductID = sop.ProductID and
sop.SpecialOfferID = so.SpecialOfferID

--3. create  view to display Product name and Product review
create view v3 as 
select pp.Name,pr.Comments
from Production.Product pp,
Production.ProductReview pr
where pp.ProductID = pr.ProductID

select * from v3

--4. find out the vendor for product   paint, Adjustable Race and blade
select *from Production.Product where name in ('Blade','Adjustable Race')
select * from Purchasing.ProductVendor
select * from Purchasing.Vendor

select pp.name,v.name,count(*)
from Production.Product as pp,
Purchasing.ProductVendor as pv,
Purchasing.Vendor as v
where pv.ProductID = pp.ProductID and
pv.BusinessEntityID = v.BusinessEntityID and
pp.name like '%Paint%' or pp.name like '%Adjustable%' or pp.name like '%Blade%'
group by pp.name,v.name
order by pp.name

select p.Name, v.Name,
count(*)
from Production.product p,
Purchasing.ProductVendor pv,
Purchasing.Vendor v
where pv.BusinessEntityID = v.BusinessEntityID and  p.ProductID = pv.ProductID
and (p.Name like 'Blade' or p.Name like 'Paint%') or p.Name like '%Adjustable Race%'
group by p.Name, v.Name
order by p.name


--5. find product details shipped through ZY - EXPRESS

select * from Purchasing.ShipMethod
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader
select * from Production.Product

select distinct pp.name
from Production.Product as pp,
Purchasing.PurchaseOrderDetail pod,
Purchasing.PurchaseOrderHeader poh,
Purchasing.ShipMethod as sm
where sm.ShipMethodID = poh.ShipMethodID and
pp.ProductID = pod.ProductID and
poh.PurchaseOrderID = pod.PurchaseOrderID and
sm.Name = 'ZY - EXPRESS'

--6. find the tax amt for products where order date and ship date are on the same day
select po.ShipDate,so.OrderDate,po.TaxAmt from Sales.SalesOrderHeader so,
Purchasing.PurchaseOrderHeader po
where cast(po.shipdate as date) = cast(so.orderdate as date) and
so.ShipMethodID= po.ShipMethodID

--7. find the average days required to ship the product based on shipment type.
select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Purchasing.PurchaseOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name

select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Sales.salesOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name


--8. find the name of employees working in day shift

select * from Person.Person where BusinessEntityID in (
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory  where ShiftID in(
select ShiftID from HumanResources.Shift where name ='day'))

--9. based on product and product cost history find the name , 
--service provider time and average Standardcost  

select * from Production.Product
select * from Production.ProductCostHistory
select * from Production.vProductModelInstructions

select pp.Name,count(datediff(day,StartDate,EndDate)) as dd,avg(pch.StandardCost) from 
Production.Product pp,
Production.ProductCostHistory pch
where pp.ProductID = pch.ProductID
group by pp.name

--10. find products with average cost more than 500

select Name,avg(StandardCost) av from 
Production.Product 
group by name
having avg(StandardCost)>500
order by avg(StandardCost)

--11. find the employee who worked in multiple territory

select * from sales.SalesTerritory
select * from sales.SalesTerritoryHistory
select * from Person.Person

select pp.FirstName,count(*)
from Sales.SalesTerritory ti,
Sales.SalesTerritoryHistory tih,
Person.Person pp
where tih.BusinessEntityID=pp.BusinessEntityID and
ti.TerritoryID=tih.TerritoryID
group by pp.FirstName
having count(*)>1

--12. find out the Product model name,  product description for culture as Arabic

select * from Production.ProductModel
select * from Production.ProductDescription
select * from Production.ProductModelProductDescriptionCulture
select * from Production.Culture

select pm.name,pd.Description
from Production.ProductModel pm,
 Production.ProductDescription pd,
 Production.ProductModelProductDescriptionCulture p,
 Production.Culture c
 where pm.ProductModelID = p.ProductModelID and
 c.CultureID = p.CultureID and
 p.ProductDescriptionID = pd.ProductDescriptionID
 and c.name like '%Arabic%'
 



