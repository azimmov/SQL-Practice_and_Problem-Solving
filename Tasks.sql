
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



