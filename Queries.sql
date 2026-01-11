/*
========================================================
Task 1 (Easy – Date + Aggregate)

Return each customer’s ID and the year of their first order.

Requirements:
-Use at least one date function
-Use at least one aggregate function
-Use GROUP BY
-Return:
	-CustomerID
	-FirstOrderYear
-Sort by CustomerID ascending
========================================================
*/

SELECT 
	customerID,
	MIN(YEAR(OrderDate)) AS FirstOrderYear
FROM WorkingFile
GROUP BY customerID
ORDER BY customerID


/*
========================================================
Task 2 (Easy → Moderate – String + Aggregate)

Return each customer’s ID and the length of their customer ID, but only include customers who have placed more than 5 orders.

Requirements:
-Use at least one string function
-Use at least one aggregate function
-Use GROUP BY
-Use HAVING
-Return:
	-CustomerID
	-CustomerIDLength
-Sort by CustomerID ascending
========================================================
*/

SELECT 
	CustomerID,
	LEN(customerID) AS CustomerIDLength
FROM WorkingFile
GROUP BY customerID
HAVING COUNT(*) > 5
ORDER BY customerID


/*
========================================================
Task 3 (Moderate – Date logic + CASE)

Return each order and classify it as either:
-'Late' if ShippedDate is after RequiredDate
-'On Time' otherwise

Requirements:
-Use a CASE statement
-Use at least one date function
-Return:
	-OrderID
	-RequiredDate
	-ShippedDate
	-DeliveryStatus
-No aggregation
-Sort by OrderID ascending
========================================================
*/

--Check if there is null required or shipped dates.
SELECT 
	RequiredDate,
	ShippedDate
FROM WorkingFile
WHERE ShippedDate is NULL OR RequiredDate is NULL
--WHERE RequiredDate is NULL


SELECT 
	orderID,
	RequiredDate,
	ShippedDate,
	CASE
		WHEN RequiredDate IS NOT NULL AND ShippedDate IS NULL THEN 'Missing Shipment'
		WHEN DATEDIFF(day,RequiredDate,ShippedDate)>0  THEN 'Late'
		WHEN DATEDIFF(day,RequiredDate,ShippedDate)<=0 THEN 'On Time'
	END AS DeliveryStatus
FROM WorkingFile
ORDER BY orderID



/*
========================================================
Task 4 (Moderate → Hard – NULL logic + Aggregate)

Return customers whose average shipping delay is greater than 2 days.

Definitions:
-Shipping delay = DATEDIFF(day, RequiredDate, ShippedDate)
-Ignore rows where ShippedDate is NULL

Requirements:
-Use at least one date function
-Use at least one aggregate function
-Use WHERE to exclude invalid rows
-Use GROUP BY
-Use HAVING
-Return:
	-CustomerID
	-AverageDelay
-Sort by AverageDelay descending
========================================================
*/

Select
	CustomerID,
	AVG(DATEDIFF(day, RequiredDate, ShippedDate)) AS AverageDelay
FROM WorkingFile
WHERE ShippedDate IS NOT NULL
GROUP BY customerID
HAVING AVG(DATEDIFF(day, RequiredDate, ShippedDate)) > 2
ORDER BY AverageDelay DESC



/*
========================================================
Task 5 (Harder – Date functions + grouping)

Return monthly order counts per year.

Requirements:
-Use at least one date function
-Use at least one aggregate function
-Use GROUP BY
-Return:
	-OrderYear
	-OrderMonth
	-NumberOfOrders
-Sort by:
	1.OrderYear ascending
	2.OrderMonth ascending
========================================================
*/

SELECT 
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	COUNT(*) AS NumberOfOrders
FROM WorkingFile
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth


/*
========================================================
Task 6 (Hard – String + CASE + Aggregate)

Return customer country statistics, showing:
-CustomerCountry
-TotalOrders
-CountryCategory

Where CountryCategory is:
-'High Volume' if TotalOrders >= 100
-'Medium Volume' if TotalOrders BETWEEN 50 AND 99
-'Low Volume' if TotalOrders < 50

Requirements:
-Use at least one aggregate function
-Use a CASE statement
-Use GROUP BY
-Use at least one string function (you choose where it makes sense)
-Sort by TotalOrders descending
========================================================
*/


SELECT 
	TRIM(CustomerCountry) AS CustomerCountry,
	COUNT(*) AS TotalOrders,
	CASE
		WHEN COUNT(*) >= 100 THEN 'High Volume'
		WHEN (COUNT(*) BETWEEN 50 and 99) THEN 'Medium Volume'
		ELSE 'Low Volume'
	END AS CountryCategory
FROM WorkingFile
GROUP BY TRIM(CustomerCountry)
ORDER BY TotalOrders DESC



/*
========================================================
Task 7 (Harder – Date logic + CASE + NULL handling)

Return orders with a shipping status classification:
-'Not Shipped' if ShippedDate is NULL
-'Shipped Early' if shipped before RequiredDate
-'Shipped On Time' if shipped on RequiredDate
-'Shipped Late' if shipped after RequiredDate

Requirements:
-Use a CASE statement
-Use at least one date function
-Handle NULL explicitly
-Return:
	-OrderID
	-RequiredDate
	-ShippedDate
	-ShippingStatus
-Sort by OrderID ascending
========================================================
*/

SELECT
	orderID,
	RequiredDate,
	ShippedDate,
	CASE
		WHEN ShippedDate IS NULL THEN 'Not Shipped'
		WHEN DATEDIFF(day, ShippedDate, RequiredDate) > 0 THEN 'Shipped Early'
		WHEN DATEDIFF(day, ShippedDate, RequiredDate) = 0 THEN 'Shipped On Time'
		WHEN DATEDIFF(day, ShippedDate, RequiredDate) < 0 THEN 'Shipped Late'
	END AS ShippingStatus
FROM WorkingFile
ORDER BY orderID


/*
========================================================
Task 8 (Very Hard – Relational thinking with functions)

Return customers whose longest gap between consecutive orders is greater than 30 days.

Definitions:
-Gap = difference in days between one order date and the next order date for the same customer
-Only consider customers with at least 2 orders

Requirements:
-Use at least one date function
-Use at least one aggregate function
-Use GROUP BY
-Use only the things you know (including newly learned functions)
-No window functions
========================================================
*/

--Finding the gaps between two consecutive orders for all orders. Table 'a' for next step. 
SELECT  
	e.customerID,
	e.OrderDate,
	l.OrderDate AS NextConsecutiveOrder,
	DATEDIFF(day, e.OrderDate, l.OrderDate) AS gap
FROM WorkingFile e
INNER JOIN WorkingFile l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate < l.OrderDate
WHERE m.OrderDate IS NULL 
GROUP BY e.customerID, e.OrderDate, l.OrderDate


--FINAL Result. Finding max gap for each customer and returning only >30.
SELECT 
	a.customerID,
	MAX(a.gap)
FROM
	(SELECT  
		e.customerID,
		e.OrderDate,
		l.OrderDate AS NextConsecutiveOrder,
		DATEDIFF(day, e.OrderDate, l.OrderDate) AS gap
	FROM WorkingFile e
	INNER JOIN WorkingFile l
		ON e.customerID = l.customerID
		AND e.OrderDate < l.OrderDate
	LEFT JOIN WorkingFile m
		ON e.customerID = m.customerID
		AND e.OrderDate < m.OrderDate 
		AND m.OrderDate < l.OrderDate
	WHERE m.OrderDate IS NULL 
	GROUP BY e.customerID, e.OrderDate, l.OrderDate) AS a
GROUP BY a.customerID
HAVING MAX(a.gap) > 30



/*
========================================================
Task 9 (Very Hard – Set operators + functions)

Return customers whose set of order months is identical to customer 'ALFKI'.

Definitions:
-Order month = YEAR(OrderDate) + MONTH(OrderDate) (month-year pair)

Requirements:
-Use at least one date function
-Use set operators (EXCEPT or INTERSECT)
-Use only the things you know
-No window functions
-Exclude 'ALFKI' itself
-Return only CustomerID
========================================================
*/


--1st TRY:----------------------------------------------------------------------------------------------- 
--'ALFKI' order month
SELECT DISTINCT
	CAST(MONTH(orderdate) AS nvarchar) + CAST(YEAR(OrderDate) AS nvarchar) AS OrderMonth
FROM WorkingFile
WHERE customerID IN ('ALFKI')

--Count of 'ALFKI' order month
SELECT COUNT(*)
FROM (
SELECT DISTINCT
	CAST(MONTH(orderdate) AS nvarchar) + CAST(YEAR(OrderDate) AS nvarchar) AS OrderMonth
FROM WorkingFile
WHERE customerID IN ('ALFKI')) AS a


--Other Customer OrderMonth which equals to 'ALFKI' OrderMonth in row level
SELECT 
	a.CustomerID,
	CAST(MONTH(a.orderdate) AS nvarchar) + CAST(YEAR(a.OrderDate) AS nvarchar) AS OrderMonthOthers,
	b.OrderMonth
FROM WorkingFile a
JOIN (SELECT DISTINCT
	CustomerID, CAST(MONTH(orderdate) AS nvarchar) + CAST(YEAR(OrderDate) AS nvarchar) AS OrderMonth
FROM WorkingFile
WHERE customerID IN ('ALFKI')) b
	ON a.customerID != b.customerID
WHERE CAST(MONTH(a.orderdate) AS nvarchar) + CAST(YEAR(a.OrderDate) AS nvarchar) = b.OrderMonth

--Customers whose OrderMonth and Count of Distinct OrderMonth matches to 'ALFKI'
SELECT 
	a.CustomerID
FROM WorkingFile a
JOIN (SELECT DISTINCT
			CustomerID, 
			CAST(MONTH(orderdate) AS nvarchar) + CAST(YEAR(OrderDate) AS nvarchar) AS OrderMonth
		FROM WorkingFile
		WHERE customerID IN ('ALFKI')) b
	ON a.customerID != b.customerID
WHERE CAST(MONTH(a.orderdate) AS nvarchar) + CAST(YEAR(a.OrderDate) AS nvarchar) = b.OrderMonth
GROUP BY a.CustomerID
HAVING Count(DISTINCT OrderMonth) = (SELECT COUNT(*)
									FROM (
									SELECT DISTINCT
										CAST(MONTH(orderdate) AS nvarchar) + CAST(YEAR(OrderDate) AS nvarchar) AS OrderMonth
									FROM WorkingFile
									WHERE customerID IN ('ALFKI')) AS a)




--Couldn't find. Answer from ChatGPT-----------------------------------------------------------------------------------

SELECT DISTINCT c.CustomerID
FROM WorkingFile c
WHERE c.CustomerID <> 'ALFKI'

AND c.CustomerID NOT IN (

    -- customers missing at least one ALFKI year-month
    SELECT CustomerID
    FROM WorkingFile
    GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate)

    EXCEPT

    SELECT CustomerID
    FROM WorkingFile
    WHERE CustomerID = 'ALFKI'
    GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate)
)

AND c.CustomerID NOT IN (

    -- customers having extra year-months beyond ALFKI
    SELECT CustomerID
    FROM WorkingFile
    WHERE CustomerID <> 'ALFKI'
    GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate)

    EXCEPT

    SELECT CustomerID
    FROM WorkingFile
    WHERE CustomerID = 'ALFKI'
    GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate)
)

ORDER BY c.CustomerID;



/*
========================================================
Task 10

Objective:
Return customerID and the percentage of their orders that were shipped late.

Definitions:
-An order is Late if ShippedDate > RequiredDate
-Ignore rows where ShippedDate is NULL

Requirements:
-Use CASE
-Use DATEDIFF
-Use aggregate functions
-Calculate the percentage as a numeric value (not text)
-Use GROUP BY
-Sort by percentage descending

Expected columns:
-CustomerID
-LateOrderPercentage
========================================================
*/


SELECT 
	a.customerID,
	CAST(b.TotalLateOrders AS float)/CAST(a.TotalOrders AS float)*100 AS LateOrderPercentage
FROM 
(--Total Orders per Customer
SELECT
	CustomerID,
	Count(*) AS TotalOrders
FROM WorkingFile
GROUP BY customerID) AS a
LEFT JOIN 
(--Total Late Orders for each customer
SELECT 
	ls.customerID,
	COUNT(*) TotalLateOrders
FROM (--Late shipments for each customer
	SELECT
		CustomerID,
		ShippedDate,
		RequiredDate,
		CASE
			WHEN DATEDIFF(day, RequiredDate, ShippedDate)>0 THEN 'Late'
		END AS late
	FROM WorkingFile
	WHERE CASE
			WHEN DATEDIFF(day, RequiredDate, ShippedDate)>0 THEN 'Late'
		END IS NOT NULL
	) AS ls
GROUP BY customerID) AS b
ON a.customerID = b.customerID
WHERE TotalLateOrders IS NOT NULL
ORDER BY LateOrderPercentage DESC


--ChatGPT simple version--------------
SELECT
    CustomerID,
    100.0 * SUM(CASE WHEN DATEDIFF(day, RequiredDate, ShippedDate) > 0 THEN 1 ELSE 0 END) 
          / COUNT(*) AS LateOrderPercentage
FROM WorkingFile
WHERE ShippedDate IS NOT NULL
GROUP BY CustomerID
ORDER BY LateOrderPercentage DESC;



/*
========================================================
Task 11

Objective:
Return CustomerCountry and the average number of days between OrderDate and ShippedDate for that country.

Rules / Requirements:
-Ignore rows where ShippedDate is NULL
-Use DATEDIFF
-Use an aggregate function (AVG)
-Use GROUP BY
-Use at least one string or NULL-related function (e.g. TRIM, ISNULL, COALESCE)
-Sort by the average delay descending

Expected columns:
-CustomerCountry
-AverageShippingDelayDays
========================================================
*/

SELECT
	TRIM(CustomerCountry) AS CustomerCountry,
	AVG (DATEDIFF (day,OrderDate, ShippedDate)) AS AverageShippingDelayDays
FROM WorkingFile
WHERE ShippedDate IS NOT NULL
GROUP BY TRIM(CustomerCountry)
ORDER BY AverageShippingDelayDays DESC



/*
========================================================
Task 12 (Easy → Moderate – String + NULL + Aggregate)

Return employee-level order statistics, showing how many orders
each employee handled, but normalize missing employee names.

Definitions:
- If employeeName is NULL, treat it as 'Unknown Employee'

Requirements:
- Use at least one NULL-related function (ISNULL or COALESCE)
- Use at least one aggregate function
- Use GROUP BY
- Use aliasing
- Return:
    - EmployeeName
    - TotalOrders
- Sort by TotalOrders descending
========================================================
*/

--1st Try
SELECT 
	(CASE WHEN employeeName IS NULL THEN 'Unknown Employee' ELSE employeeName END) AS EmployeeName,
	COUNT (*) as TotalOrders
FROM WorkingFile
GROUP BY (CASE WHEN employeeName IS NULL THEN 'Unknown Employee' ELSE employeeName END)
ORDER BY TotalOrders DESC

--Alternative, shorter version
SELECT 
	COALESCE (employeeName,'Unknown Employee') AS EmployeeName,
	COUNT (*) as TotalOrders
FROM WorkingFile
GROUP BY COALESCE (employeeName,'Unknown Employee')
ORDER BY TotalOrders DESC


/*
========================================================
Task 13 (Moderate – Numeric functions + CASE + Aggregate)

Return product-level revenue statistics.

Definitions:
- Revenue per row = unitPrice * quantity * (1 - discount)
- Discount is a fraction (e.g. 0.1 = 10%)

RevenueCategory:
- 'High Revenue' if TotalRevenue >= 10000
- 'Medium Revenue' if TotalRevenue BETWEEN 3000 AND 9999.99
- 'Low Revenue' if TotalRevenue < 3000

Requirements:
- Use at least one numeric function (ROUND or ABS)
- Use CASE
- Use at least one aggregate function
- Use GROUP BY
- Return:
    - productID
    - TotalRevenue
    - RevenueCategory
- Sort by TotalRevenue descending
========================================================
*/

SELECT 
	productID,
	ROUND(SUM (UnitPrice_actual*quantity*(1-discount)),2) AS TotalRevenue,
	CASE 
		WHEN ROUND(SUM (UnitPrice_actual*quantity*(1-discount)),2) >=10000 THEN 'High Revenue'
		WHEN ROUND(SUM (UnitPrice_actual*quantity*(1-discount)),2) BETWEEN 3000 AND 9999.99 THEN 'Medium Revenue'
		ELSE 'Low Revenue'
	END AS RevenueCategory
FROM WorkingFile
GROUP BY productID
ORDER BY TotalRevenue DESC



/*
========================================================
Task 14 (Harder – Date functions + Aggregate + Filtering)

Return customers who placed orders in **at least 3 different years**
and whose **average days between OrderDate and ShippedDate**
is **less than 5 days**.

Rules:
- Ignore rows where ShippedDate is NULL
- Year is based on OrderDate

Requirements:
- Use at least one date function
- Use COUNT(DISTINCT ...)
- Use DATEDIFF
- Use AVG
- Use GROUP BY
- Use HAVING
- Return:
    - CustomerID
    - DistinctOrderYears
    - AverageShippingDays
- Sort by AverageShippingDays ascending
========================================================
*/


SELECT 
	customerID,
	COUNT(DISTINCT YEAR(OrderDate)) AS DistinctOrderYears,
	AVG(DATEDIFF(day,OrderDate,ShippedDate)) AS AverageShippingDays
FROM WorkingFile
WHERE ShippedDate IS NOT NULL
GROUP BY customerID
HAVING COUNT(DISTINCT YEAR(OrderDate)) >=3
ORDER BY AverageShippingDays ASC



/*
========================================================
Task 15 (Hard – Top-N per group without window functions)

For each categoryID, return the product that generated the highest total revenue.

Assume:
- Revenue per row = UnitPrice_actual * quantity * (1 - discount)
- Multiple products belong to the same category
- If there is a tie for revenue within a category, return all tied products

Requirements:
-Use GROUP BY
-Use SUM to calculate total revenue per product
-Do NOT use window functions or TOP … WITH TIES
-Use a self-join or anti-join pattern to identify the top product per category
-Return:
    -CategoryID
    -ProductID
    -TotalRevenue
-Sort by CategoryID ascending
========================================================
*/


--Max Revenue per category
SELECT 
	tr.categoryID,
	MAX(tr.TotalRevenue) AS HighestTotalRevenue
FROM
(
SELECT
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) AS TotalRevenue
FROM WorkingFile
GROUP BY categoryID, productID
) tr
GROUP BY tr.categoryID


--Final result
SELECT 
	a.categoryID,
	a.productID,
	mx.HighestTotalRevenue AS TotalRevenue
FROM WorkingFile a
JOIN (
	SELECT 
	tr.categoryID,
	MAX(tr.TotalRevenue) AS HighestTotalRevenue
FROM
(
SELECT
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) AS TotalRevenue
FROM WorkingFile
GROUP BY categoryID, productID
) tr
GROUP BY tr.categoryID
	) AS mx
	
	ON a.categoryID = mx.categoryID
GROUP BY a.categoryID, a.productID, mx.HighestTotalRevenue
HAVING SUM(a.UnitPrice_actual * a.quantity * (1 - a.discount)) = mx.HighestTotalRevenue
ORDER BY a.categoryID


/*
========================================================
Task 16 (Harder – Date logic + CASE + Aggregate)

Objective:
Identify customers whose ordering behavior slowed down over time.

Definition:
For each customer:
-Calculate the average number of days between OrderDate and the next order
	-in their first order year
	-and in their last order year
-A customer is considered “slowed down” if:
	-average gap in last order year > average gap in first order year

Requirements:
-Use at least one date function
-Use at least one aggregate function
-Use a CASE statement
-Use GROUP BY
-Use self-joins (no window functions)
-Use the same dataset
-Return:
	-CustomerID
	-FirstYearAvgGapDays
	-LastYearAvgGapDays
	-BehaviorChangeLabel ('Slowed Down' or 'No Slowdown')
-Only return customers with at least 2 orders in both years
========================================================
*/

--Consecutive orders and days between orders
SELECT
	e.customerID,
	e.OrderDate,
	l.OrderDate AS NextOrderDate,
	DATEDIFF(day, e.OrderDate, l.OrderDate) AS DaysBetweenOrders
FROM WorkingFile e
JOIN WorkingFile l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate
	AND m.OrderDate < l.OrderDate
WHERE m.OrderDate IS NULL;


--First and Last Order Year
SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear,
	MAX(YEAR(OrderDate)) LastOrderYear
FROM WorkingFile
GROUP BY customerID
ORDER BY customerID


--FirstYearAvgGapDays
SELECT
	e.customerID,
	AVG(DATEDIFF(day, e.OrderDate, l.OrderDate)) AS FirstYearAvgGapDays
FROM WorkingFile e
JOIN WorkingFile l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate
	AND m.OrderDate < l.OrderDate
LEFT JOIN (
	SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear,
	MAX(YEAR(OrderDate)) LastOrderYear
	FROM WorkingFile
	GROUP BY customerID
	) AS fl
	ON e.customerID = fl.customerID
WHERE m.OrderDate IS NULL
	AND FirstOrderYear = YEAR(e.OrderDate)
GROUP BY e.customerID
HAVING COUNT(*)>=2

--LastYearAvgGapDays
SELECT
	e.customerID,
	AVG(DATEDIFF(day, e.OrderDate, l.OrderDate)) AS LastYearAvgGapDays
FROM WorkingFile e
JOIN WorkingFile l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate
	AND m.OrderDate < l.OrderDate
LEFT JOIN (
	SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear,
	MAX(YEAR(OrderDate)) LastOrderYear
	FROM WorkingFile
	GROUP BY customerID
	) AS fl
	ON e.customerID = fl.customerID
WHERE m.OrderDate IS NULL
	AND LastOrderYear = YEAR(e.OrderDate)
GROUP BY e.customerID
HAVING COUNT(*)>=2



--FINAL RESULT
----------------------------------------------------------
SELECT
	fy.customerID,
	fy.FirstYearAvgGapDays,
	ly.LastYearAvgGapDays,
	(CASE WHEN ly.LastYearAvgGapDays >	fy.FirstYearAvgGapDays THEN 'Slowed Down' ELSE 'No Slowdown' END) AS BehaviorChangeLabel
FROM 

--First Year Average Gap Days
		(--Consecutive orders and days between orders
		SELECT
			e.customerID,
			AVG(DATEDIFF(day, e.OrderDate, l.OrderDate)) AS FirstYearAvgGapDays
		FROM WorkingFile e
		JOIN WorkingFile l
			ON e.customerID = l.customerID
			AND e.OrderDate < l.OrderDate
		LEFT JOIN WorkingFile m
			ON e.customerID = m.customerID
			AND e.OrderDate < m.OrderDate
			AND m.OrderDate < l.OrderDate
		
		LEFT JOIN 
		
		(--First and Last Order Year
			SELECT 
			customerID,
			MIN(YEAR(OrderDate)) FirstOrderYear
			FROM WorkingFile
			GROUP BY customerID
			) AS fl
			
			ON e.customerID = fl.customerID
		WHERE m.OrderDate IS NULL
			AND FirstOrderYear = YEAR(e.OrderDate)
		GROUP BY e.customerID
		HAVING COUNT(*)>=2
	) AS fy

JOIN 

--Last Year Average Gap Days
		(--Consecutive orders and days between orders
		SELECT
			e.customerID,
			AVG(DATEDIFF(day, e.OrderDate, l.OrderDate)) AS LastYearAvgGapDays
		FROM WorkingFile e
		JOIN WorkingFile l
			ON e.customerID = l.customerID
			AND e.OrderDate < l.OrderDate
		LEFT JOIN WorkingFile m
			ON e.customerID = m.customerID
			AND e.OrderDate < m.OrderDate
			AND m.OrderDate < l.OrderDate
		
		LEFT JOIN 
		(--First and Last Order Year
			SELECT 
			customerID,
			MAX(YEAR(OrderDate)) LastOrderYear
			FROM WorkingFile
			GROUP BY customerID
			) AS fl
			ON e.customerID = fl.customerID
		WHERE m.OrderDate IS NULL
			AND LastOrderYear = YEAR(e.OrderDate)
		GROUP BY e.customerID
		HAVING COUNT(*)>=2
	) AS ly
	
ON fy.customerID = ly.customerID







/*
========================================================
Task 17 – Harder (Revenue trend analysis per customer)

Objective:
For each customer, calculate total revenue in their first order year and last order year, then classify the revenue trend as:
-'Increased' if last year revenue > first year revenue
-'Decreased' if last year revenue < first year revenue
-'Stable' if they are equal

Requirements:
-Use SUM and arithmetic for revenue (UnitPrice_actual * quantity * (1 - discount))
-Use MIN(YEAR(OrderDate)) and MAX(YEAR(OrderDate)) for first and last order years
-Use CASE for trend classification
-Return: CustomerID, FirstYearRevenue, LastYearRevenue, RevenueTrend
-Sort by CustomerID
========================================================
*/


--First and Last Order Year
SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear,
	MAX(YEAR(OrderDate)) LastOrderYear
FROM WorkingFile
GROUP BY customerID
ORDER BY customerID


--First Year Revenue
SELECT
	a.customerID,
	SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS FirstYearRevenue
FROM WorkingFile a
LEFT JOIN (
	SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear
	FROM WorkingFile
	GROUP BY customerID
	) AS fl
	ON a.customerID = fl.customerID
WHERE fl.FirstOrderYear = YEAR(a.OrderDate)
GROUP BY a.customerID
ORDER BY a.customerID


--Last Year Revenue
SELECT
	a.customerID,
	fl.LastOrderYear,
	SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS LastYearRevenue
FROM WorkingFile a
LEFT JOIN (
	SELECT 
	customerID,
	MIN(YEAR(OrderDate)) FirstOrderYear,
	MAX(YEAR(OrderDate)) LastOrderYear
	FROM WorkingFile
	GROUP BY customerID
	) AS fl
	ON a.customerID = fl.customerID
WHERE fl.LastOrderYear = YEAR(a.OrderDate) 
	AND fl.LastOrderYear != fl.FirstOrderYear
GROUP BY a.customerID, fl.LastOrderYear
ORDER BY a.customerID



--FINAL RESULT
--------------------------------------

SELECT
	fyr.customerID, 
	fyr.FirstYearRevenue, 
	lyr.LastYearRevenue,
	CASE
		WHEN lyr.LastYearRevenue IS NULL THEN '1st year customer' 
		WHEN lyr.LastYearRevenue > fyr.FirstYearRevenue THEN 'Increased'
		WHEN lyr.LastYearRevenue < fyr.FirstYearRevenue THEN 'Decreased'
		WHEN lyr.LastYearRevenue = fyr.FirstYearRevenue THEN 'Stable'
	END AS RevenueTrend
FROM
		(
		--First Year Revenue
		SELECT
			a.customerID,
			fl.FirstOrderYear,
			SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS FirstYearRevenue
		FROM WorkingFile a
		LEFT JOIN (
			SELECT 
			customerID,
			MIN(YEAR(OrderDate)) FirstOrderYear
			FROM WorkingFile
			GROUP BY customerID
			) AS fl
			ON a.customerID = fl.customerID
		WHERE fl.FirstOrderYear = YEAR(a.OrderDate)
		GROUP BY a.customerID, fl.FirstOrderYear
		) AS fyr

LEFT JOIN 

		(
		--Last Year Revenue
		SELECT
			a.customerID,
			fl.LastOrderYear,
			SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS LastYearRevenue
		FROM WorkingFile a
		LEFT JOIN (
			SELECT 
			customerID,
			MIN(YEAR(OrderDate)) FirstOrderYear,
			MAX(YEAR(OrderDate)) LastOrderYear
			FROM WorkingFile
			GROUP BY customerID
			) AS fl
			ON a.customerID = fl.customerID
		WHERE fl.LastOrderYear = YEAR(a.OrderDate) 
			AND fl.LastOrderYear != fl.FirstOrderYear
		GROUP BY a.customerID, fl.LastOrderYear
		) AS lyr
	
	ON fyr.customerID = lyr.customerID
	


/*
========================================================
Task 18 (Hard – Category-Level Revenue Trend Across Years)

Objective:
Analyze revenue trends at the category level for each customer: whether their spending in a category has increased, decreased, or stayed stable from their first order year to their last order year.

Requirements:
-Use SUM to compute revenue (UnitPrice_actual * quantity * (1 - discount))
-Compute first year revenue and last year revenue per customer per category
-Use CASE to define trend: 'Increased', 'Decreased', 'Stable', '1st year only'
-Use JOIN or LEFT JOIN to combine first and last year revenue
-Return:
	CustomerID
	CategoryID
	FirstYearRevenue
	LastYearRevenue
	RevenueTrend
-Sort by CustomerID, then CategoryID

This is slightly harder than Task 17 because it adds category-level grouping.
========================================================
*/




SELECT
	fyr.customerID, 
	fyr.categoryID,
	fyr.FirstYearRevenue, 
	lyr.LastYearRevenue,
	CASE
		WHEN lyr.LastYearRevenue IS NULL THEN '1st year only' 
		WHEN lyr.LastYearRevenue > fyr.FirstYearRevenue THEN 'Increased'
		WHEN lyr.LastYearRevenue < fyr.FirstYearRevenue THEN 'Decreased'
		WHEN lyr.LastYearRevenue = fyr.FirstYearRevenue THEN 'Stable'
	END AS RevenueTrend
FROM
		(
		--First Year Revenue
		SELECT
			a.customerID,
			a.categoryID,
			fl.FirstOrderYear,
			SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS FirstYearRevenue
		FROM WorkingFile a
		LEFT JOIN (
			SELECT 
			customerID,
			categoryID,
			MIN(YEAR(OrderDate)) FirstOrderYear
			FROM WorkingFile
			GROUP BY customerID, categoryID
			) AS fl
			ON a.customerID = fl.customerID AND a.categoryID = fl.categoryID
		WHERE fl.FirstOrderYear = YEAR(a.OrderDate)
		GROUP BY a.customerID, a.categoryID, fl.FirstOrderYear
		) AS fyr

LEFT JOIN 

		(
		--Last Year Revenue
		SELECT
			a.customerID,
			a.categoryID,
			fl.LastOrderYear,
			SUM((a.UnitPrice_actual * a.quantity * (1 - a.discount))) AS LastYearRevenue
		FROM WorkingFile a
		LEFT JOIN (
			SELECT 
			customerID,
			categoryID,
			MIN(YEAR(OrderDate)) FirstOrderYear,
			MAX(YEAR(OrderDate)) LastOrderYear
			FROM WorkingFile
			GROUP BY customerID, categoryID
			) AS fl
			ON a.customerID = fl.customerID AND a.categoryID = fl.categoryID
		WHERE fl.LastOrderYear = YEAR(a.OrderDate) 
			AND fl.LastOrderYear != fl.FirstOrderYear
		GROUP BY a.customerID, a.categoryID, fl.LastOrderYear
		) AS lyr
	
	ON fyr.customerID = lyr.customerID AND
	fyr.categoryID = lyr.categoryID
ORDER BY fyr.customerID, fyr.categoryID


/*
========================================================
Task 19 – Top Products by Revenue per Category (Harder – Ranking without window functions)

Objective:
For each categoryID, return the top 2 products by total revenue.

Requirements:
-Use SUM(UnitPrice_actual * quantity * (1 - discount)) for total revenue.
-Use only things you already know (no window functions).
-Return:
	-categoryID
	-productID
	-TotalRevenue
-Sort by categoryID ascending, TotalRevenue descending.
========================================================
*/

SELECT 
	a.categoryID,
	a.productID,
	a.TotalRevenue
FROM 
(
SELECT 
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) TotalRevenue
FROM WorkingFile
GROUP BY categoryID, productID
) AS a

LEFT JOIN 
(
SELECT 
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) TotalRevenue
FROM WorkingFile
GROUP BY categoryID, productID
) AS b

ON a.categoryID = b.categoryID AND 
b.TotalRevenue > a.TotalRevenue
GROUP BY
	a.categoryID,
	a.productID, 
	a.TotalRevenue
HAVING COUNT(b.productID)<2
ORDER BY categoryID ASC, a.TotalRevenue DESC



/*
========================================================
Task 20 — Top-2 Products per Category with Ties, plus a Business Constraint

Objective
For each category, return all products that are among the top 2 revenue ranks, including ties, but only if:
-The product has at least 5 order lines
-Ignore rows where discount = 1 (free items)
-Revenue is calculated as UnitPrice_actual * quantity * (1 - discount)

Definitions
-Products with the same total revenue share the same rank
-If multiple products tie for 2nd place, return all of them
-Do not use:
	Window functions
	TOP
	LIMIT

Expected Output Columns
-categoryID
-productID
-TotalRevenue
-OrderLineCount
-RevenueRank (1 = highest, 2 = second)
========================================================
*/



SELECT
a.categoryID,
a.productID,
a.TotalRevenue,
a.OrderLineCount,
CASE
	WHEN a.TotalRevenue < MAX(b.TotalRevenue) THEN 'second'
	ELSE 'highest'
END AS revrank
FROM
(--Total revenue and >=5 Order Count per product
SELECT 
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) AS TotalRevenue,
	COUNT(*) OrderLineCount
FROM WorkingFile
WHERE discount < 1
GROUP BY categoryID, productID
HAVING COUNT(*) >=5
) AS a

LEFT JOIN 

(--Total revenue and >=5 Order Count per product, self-join
SELECT 
	categoryID,
	productID,
	SUM(UnitPrice_actual * quantity * (1 - discount)) AS TotalRevenue,
	COUNT(*) OrderLineCount
FROM WorkingFile
WHERE discount < 1
GROUP BY categoryID, productID
HAVING COUNT(*) >=5
) AS b

ON a.categoryID = b.categoryID
AND b.TotalRevenue > a.TotalRevenue
GROUP BY 
a.categoryID,
a.productID,
a.TotalRevenue,
a.OrderLineCount
HAVING COUNT(DISTINCT b.TotalRevenue) <2
ORDER BY a.categoryID, a.TotalRevenue DESC




/*
========================================================
Task 21 — NULL-aware date analysis (harder)

Objective
Analyze customer ordering behavior while correctly handling NULL dates.

Requirements
Return one row per customer with the following columns:
-customerID
-FirstOrderDate = Earliest OrderDate
-LastRelevantDate
	If ShippedDate is NOT NULL → use ShippedDate
	If ShippedDate IS NULL → use OrderDate
-ActiveDays = Number of days between FirstOrderDate and LastRelevantDate
-AvgShipDelayDays
	Average days between OrderDate and ShippedDate
	Ignore rows where ShippedDate is NULL
-CustomerStatus
	'Inactive' if LastRelevantDate is more than 180 days ago
	'Active' otherwise

Rules / Constraints
-Use date functions (DATEDIFF, YEAR, etc.)
-Handle NULL explicitly (no accidental exclusion)
-Do not filter out customers with NULL ShippedDate entirely
-Use GROUP BY
-No window functions
-No subqueries that simply restate the same aggregation unless needed logically
========================================================
*/


SELECT
	customerID,
	MIN(OrderDate) AS FirstOrderDate,
	MAX(COALESCE(ShippedDate,OrderDate)) AS LastRelevantDate,
	DATEDIFF(day,MIN(OrderDate),MAX(COALESCE(ShippedDate,OrderDate))) AS ActiveDays,
	AVG(DATEDIFF(day,OrderDate,ShippedDate)) AS AvgShipDelayDays,
	CASE 
		WHEN DATEDIFF(day,MAX(COALESCE(ShippedDate,OrderDate)),GETDATE()) >180 THEN 'Inactive'
		ELSE 'Active'
	END AS CustomerStatus
FROM WorkingFile 
GROUP BY customerID

