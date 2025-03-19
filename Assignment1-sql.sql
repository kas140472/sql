-- Q1
Select ProductID, Name, Color, ListPrice
from Production.Product

-- Q2
Select ProductID, Name, Color, ListPrice
from Production.Product
where ListPrice!=0

-- Q3
Select ProductID, Name, Color, ListPrice
from Production.Product
where Color is null

-- Q4
Select ProductID, Name, Color, ListPrice
from Production.Product
where Color is not null

-- Q5
Select ProductID, Name, Color, ListPrice
from Production.Product
where Color is not null and ListPrice>0

-- Q6
Select ProductID, Name+Color as NameColor, ListPrice
from Production.Product
where Color is not null

-- Q7
Select Name, Color
from Production.Product
where Name like '%Crankarm' or Name like 'Chainring%'
order by Name DESC

-- Q8
Select ProductID, Name
from Production.Product
where ProductID between 400 and 500

-- Q9
Select ProductID, Name, Color
from Production.Product
where Color in ('Black', 'Blue')

-- Q10
Select ProductID, Name
from Production.Product
where Name like 'S%'

-- Q11
Select Name, ListPrice
from Production.Product
order by Name

-- Q12
Select Name, ListPrice
from Production.Product
where Name like '[AS]%'
order by Name

-- Q13
Select Name
from Production.Product
where Name like 'SPO[^K]%'
order by Name

-- Q14
Select DISTINCT Color
from Production.Product
order by Color DESC
