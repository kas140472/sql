-- 1
select distinct c.City
from Customers c
inner join Employees e on c.City = e.City;

-- 2a
select distinct City
from Customers
where City not in (select City from Employees);

-- 2b
select distinct c.City
from Customers c
left join Employees e on c.City = e.City
where e.EmployeeID is null;

-- 3
select p.ProductID, p.ProductName, sum(od.Quantity) as TotalQuantity
from Products p
left join [Order Details] od on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName
order by TotalQuantity desc;

-- 4
select c.City, sum(od.Quantity) as TotalProductsOrdered
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
group by c.City
order by TotalProductsOrdered desc;

-- 5
select City, count(CustomerID) as CustomerCount
from Customers
group by City
having count(CustomerID) >= 2
order by CustomerCount desc;

-- 6
select c.City, count(distinct od.ProductID) as DifferentProducts
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
group by c.City
having count(distinct od.ProductID) >= 2
order by DifferentProducts desc;

-- 7 - not sure

-- 8
with ProductQuantities as (
    select 
        od.ProductID,
        p.ProductName,
        avg(od.UnitPrice) as AvgPrice,
        c.City,
        sum(od.Quantity) as TotalQuantity,
        row_number() over (partition by od.ProductID order by sum(od.Quantity) desc) as CityRank
    from [Order Details] od
    join Orders o on od.OrderID = o.OrderID
    join Customers c on o.CustomerID = c.CustomerID
    join Products p on od.ProductID = p.ProductID
    group by od.ProductID, p.ProductName, c.City
),
ProductTotals as (
    select 
        ProductID,
        ProductName,
        AvgPrice,
        sum(TotalQuantity) over (partition by ProductID) as GrandTotal
    from ProductQuantities
    where CityRank = 1
)
select top 5
    pq.ProductID,
    pq.ProductName,
    pt.GrandTotal as TotalQuantityOrdered,
    pq.AvgPrice,
    pq.City as TopOrderingCity,
    pq.TotalQuantity as CityQuantityOrdered
from ProductQuantities pq
join ProductTotals pt on pq.ProductID = pt.ProductID and pq.ProductName = pt.ProductName
where pq.CityRank = 1
order by pt.GrandTotal desc;

-- 9a
select distinct e.City
from Employees e
where e.City not in (
    select distinct o.ShipCity
    from Orders o
);

-- 9b
select distinct e.City
from Employees e
left join Orders o on e.City = o.ShipCity
where o.OrderID is null;

-- 10
with EmployeeOrderCounts as (
    select 
        e.City,
        count(o.OrderID) as OrderCount,
        rank() over (order by count(o.OrderID) desc) as OrderRank
    from Employees e
    join Orders o on e.EmployeeID = o.EmployeeID
    group by e.City
),
CityProductCounts as (
    select 
        o.ShipCity as City,
        sum(od.Quantity) as TotalQuantity,
        rank() over (order by sum(od.Quantity) desc) as QuantityRank
    from Orders o
    join [Order Details] od on o.OrderID = od.OrderID
    group by o.ShipCity
)
select eoc.City
from EmployeeOrderCounts eoc
join CityProductCounts cpc on eoc.City = cpc.City
where eoc.OrderRank = 1 and cpc.QuantityRank = 1;