-- Name: Nirupama Poojari
-- Professor: Kijung Lee
-- Course: IT2060C
USE RestaurantChain; -- This line is needed to import information from any database

/*
Scenario:
You are a database consultant for a growing restaurant chain.
They have provided you with a simplified database schema and some sample data. 
Your task is to analyze the data and provide insights using SQL queries.
*/

-- Question 1

/*
Write a SQL query to find the top 5 
best-selling menu items across all restaurants.
*/

SELECT *
FROM Restaurant_Menu;

SELECT *
FROM Order_Details;

SELECT *
FROM Orders;

SELECT *
FROM Restaurants;

SELECT *
FROM Menu_Items;

-- Attempt 1
SELECT TOP 5 OrderID, ItemID, Quantity
FROM Order_Details
ORDER BY Quantity DESC;

-- Joining rows from all tables
SELECT *
FROM Order_Details
JOIN Menu_Items ON Order_Details.ItemID = Menu_Items.ItemID;

-- Checking the answers
SELECT TOP 5 od.OrderID, od.ItemID, od.Quantity, mi.*
FROM Order_Details od
JOIN Menu_Items mi ON od.ItemID = mi.ItemID
ORDER BY od.Quantity DESC;


-- Question 2

/*
  Create a query to identify restaurants that don't offer any items in the "Dessert" category.
*/

SELECT *
FROM Restaurant_Menu;

SELECT *
FROM Restaurants;

SELECT *
FROM Menu_Items;

-- Attempt 1
SELECT *
FROM Restaurant_Menu
JOIN Restaurants ON Restaurant_Menu.RestaurantID = Restaurants.RestaurantID
JOIN Menu_Items ON Restaurant_Menu.ItemID = Menu_Items.ItemID;

-- Final Code
SELECT DISTINCT Restaurants.RestaurantID, Restaurants.Name
FROM Restaurants
LEFT JOIN Restaurant_Menu ON Restaurants.RestaurantID = Restaurant_Menu.RestaurantID
LEFT JOIN Menu_Items ON Restaurant_Menu.ItemID = Menu_Items.ItemID AND Menu_Items.Category = 'Dessert'
WHERE Menu_Items.ItemID IS NULL;

-- Fixed code
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    COUNT(DISTINCT mi.Category) AS VarietyOfMenuItems
FROM
    Restaurants r
JOIN
    Restaurant_Menu rm ON r.RestaurantID = rm.RestaurantID
JOIN
    Menu_Items mi ON rm.ItemID = mi.ItemID
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Menu_Items mi2
        WHERE mi2.ItemID = rm.ItemID
        AND mi2.Category = 'Dessert'
    )
GROUP BY
    r.RestaurantID, r.Name
ORDER BY
    VarietyOfMenuItems DESC;
-- Final attempt (Correct answer)
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    r.City,
    r.State
FROM
    Restaurants r
WHERE
    r.RestaurantID NOT IN (
        SELECT DISTINCT rm.RestaurantID
        FROM Restaurant_Menu rm
        JOIN Menu_Items mi ON rm.ItemID = mi.ItemID
        WHERE mi.Category = 'Dessert'
    );



-- Question 3
-- Stuck on this question
/*Write a SQL query to calculate the average order value for each restaurant.*/

SELECT *
FROM Restaurant_Menu;

SELECT *
FROM Order_Details;

SELECT *
FROM Orders;

SELECT *
FROM Restaurants;

SELECT *
FROM Menu_Items;

-- Checks what orders are there for each restaurant
SELECT *
FROM Restaurant_Menu
JOIN Restaurants ON Restaurant_Menu.RestaurantID = Restaurants.RestaurantID
JOIN Order_Details ON Restaurant_Menu.ItemID = Order_Details.ItemID;

-- Final answer
SELECT
    r.RestaurantID,
    r.Name,
    CAST(ROUND(AVG(o.TotalAmount), 4) AS DECIMAL(18, 2)) AS average_order_value
FROM
    Restaurants r
JOIN
    Orders o ON r.RestaurantID = o.RestaurantID
GROUP BY
    r.RestaurantID, r.Name
ORDER BY
    r.RestaurantID;



-- Question 4

/*Develop a query to find the restaurant with the highest total sales in the last month.*/

SELECT *
FROM Restaurant_Menu;

SELECT *
FROM Order_Details;

SELECT *
FROM Orders;

SELECT *
FROM Restaurants;

SELECT *
FROM Menu_Items;

-- The biggest hint was finding the restaraunt with the highest sales
SELECT
    r.RestaurantID,
    r.Name,
    SUM(o.TotalAmount) AS total_sales_last_month
FROM
    Restaurants r
JOIN
    Orders o ON r.RestaurantID = o.RestaurantID
GROUP BY
    r.RestaurantID, r.Name
ORDER BY
    SUM(o.TotalAmount) DESC;


SELECT * 
FROM Orders
JOIN Order_Details on Orders.OrderID = Order_Details.OrderID
JOIN Restaurants on  Orders.RestaurantID = Restaurants.RestaurantID;


SELECT
    r.RestaurantID,
    r.Name,
    SUM(o.TotalAmount) AS total_sales_last_month
FROM
    Restaurants r
JOIN
    Orders o ON r.RestaurantID = o.RestaurantID
WHERE
    o.OrderDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CAST('2024-07-05 10:30:00' AS smalldatetime)) - 1, 0)  -- Beginning of last month before '2019-07-15 10:30:00'
GROUP BY
    r.RestaurantID, r.Name
ORDER BY
    SUM(o.TotalAmount) DESC;


-- Question 5

/*5 Create a view that shows each restaurant's most popular item (by quantity sold).*/

-- Attempt 1
-- View 1: Total Quantity Sold per Item

-- step 1, execute commands, then access view
-- View 1: Total Quantity Sold per Item
CREATE VIEW ItemSales AS
SELECT
    ItemID,
    SUM(Quantity) AS TotalQuantitySold
FROM
    Order_Details
GROUP BY
    ItemID;

SELECT *
FROM ItemSales;

DROP VIEW MostPopularItems;
-- Final Code for Question 5
CREATE VIEW MostPopularItems AS
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    ISNULL(mi.ItemID, 0) AS MostPopularItemID,
    ISNULL(mi.Name, 'Unknown') AS MostPopularItemName,
    ISNULL(mi.Category, 'Unknown') AS MostPopularItemCategory,
    ISNULL(mi.Price, 0) AS MostPopularItemUnitPrice,
    ISNULL(s.TotalQuantitySold, 0) AS MostPopularItemTotalQuantity
FROM
    Restaurants r
LEFT JOIN (
    SELECT
        rm.RestaurantID,
        rm.ItemID,
        SUM(od.Quantity) AS TotalQuantitySold
    FROM
        Restaurant_Menu rm
    JOIN
        Order_Details od ON rm.ItemID = od.ItemID
    JOIN
        Orders o ON od.OrderID = o.OrderID
    GROUP BY
        rm.RestaurantID,
        rm.ItemID
    HAVING
        SUM(od.Quantity) > 4
) AS s ON r.RestaurantID = s.RestaurantID
LEFT JOIN
    Menu_Items mi ON s.ItemID = mi.ItemID;


SELECT *
FROM MostPopularItems;


-- Question 6

/*
6.	Write a stored procedure that takes a restaurant ID as input
and returns its monthly sales for the past year.
*/

/*Monthly sales code*/

SELECT *
FROM Orders;
DROP PROCEDURE GetMonthlySalesForRestaurant;
-- Create the stored procedure

CREATE PROCEDURE GetMonthlySalesForRestaurant
    @restaurant_id INT
AS
BEGIN
    DECLARE @StartDate DATE = '2023-07-01'; -- Start date of the previous year from the specific date range
    DECLARE @EndDate DATE = '2024-07-05';   -- End date of the specific date range

    SELECT
        YEAR(DATEADD(YEAR, -1, o.OrderDate)) AS [Year],
        MONTH(DATEADD(MONTH, -1, o.OrderDate)) AS [Month],
        SUM(o.TotalAmount) AS MonthlySales
    FROM
        Orders o
        JOIN Order_Details od ON o.OrderID = od.OrderID
        JOIN Menu_Items mi ON od.ItemID = mi.ItemID
    WHERE
        o.RestaurantID = @restaurant_id
        AND o.OrderDate >= @StartDate
        AND o.OrderDate <= @EndDate
    GROUP BY
        YEAR(DATEADD(YEAR, -1, o.OrderDate)),
        MONTH(DATEADD(MONTH, -1, o.OrderDate))
    ORDER BY
        [Year] DESC,
        [Month] DESC;
END;

EXEC GetMonthlySalesForRestaurant @restaurant_id = 2;


-- Question 7

-- Code can list out available orders

-- Final Code
SELECT *
FROM Restaurant_Menu
JOIN Restaurants ON Restaurant_Menu.RestaurantID = Restaurants.RestaurantID
JOIN Menu_Items ON Restaurant_Menu.ItemID = Menu_Items.ItemID
JOIN Order_Details ON Restaurant_Menu.ItemID = Order_Details.ItemID;

-- Query to get the total number of restaurants
SELECT COUNT(DISTINCT RestaurantID) AS TotalRestaurants
FROM Restaurants;

-- Query to identify menu items offered in all restaurants (Fail)
SELECT
    mi.ItemID,
    mi.Name AS MenuItemName,
    mi.Category,
    mi.Price
FROM
    Menu_Items mi
WHERE
    EXISTS (
        SELECT DISTINCT rm.RestaurantID
        FROM Restaurant_Menu rm
        WHERE rm.ItemID = mi.ItemID
        GROUP BY rm.ItemID
        HAVING COUNT(DISTINCT rm.RestaurantID) = (SELECT COUNT(DISTINCT RestaurantID) FROM Restaurants)
    );

	-- Attempt 2
	-- Query to identify menu items offered in all restaurants
SELECT mi.ItemID, mi.Name, mi.Category, mi.Price
FROM Menu_Items mi
WHERE EXISTS (
    SELECT 1
    FROM Restaurants r
    WHERE NOT EXISTS (
        SELECT 1
        FROM Restaurant_Menu rm
        WHERE rm.ItemID = mi.ItemID
          AND rm.RestaurantID = r.RestaurantID
    )
);
/*------*/
-- Query to identify menu items offered in all restaurants
-- Success, but needs restaurants

SELECT mi.ItemID, mi.Name, mi.Category, mi.Price
FROM Menu_Items mi
JOIN Restaurant_Menu rm ON mi.ItemID = rm.ItemID
JOIN Restaurants r ON rm.RestaurantID = r.RestaurantID
WHERE EXISTS (
    SELECT 1
    FROM Restaurants r2
    WHERE NOT EXISTS (
        SELECT 1
        FROM Restaurant_Menu rm2
        WHERE rm2.ItemID = mi.ItemID
          AND rm2.RestaurantID = r2.RestaurantID
    )
)
AND EXISTS (
    SELECT 1
    FROM Order_Details od
    WHERE od.ItemID = mi.ItemID
);
-- Last attempt

SELECT
    mi.ItemID,
    mi.Name AS MenuItemName,
    mi.Category,
    mi.Price,
    r.Name AS RestaurantName
FROM
    Menu_Items mi
JOIN
    Restaurant_Menu rm ON mi.ItemID = rm.ItemID
JOIN
    Restaurants r ON rm.RestaurantID = r.RestaurantID
WHERE
    EXISTS (
        -- Ensure the item exists in at least one restaurant
        SELECT 1
        FROM Restaurant_Menu rm2
        WHERE rm2.ItemID = mi.ItemID
    )
    AND EXISTS (
        -- Ensure the item has been ordered at least once
        SELECT 1
        FROM Order_Details od
        WHERE od.ItemID = mi.ItemID
    );


-- Question 8

/*8. Create a trigger that updates the TotalAmount in the Orders table whenever a new item is added to Order_Details.*/
SELECT *
FROM Order_Details;

SELECT *
FROM Orders;

DROP TRIGGER UpdateTotalAmountOnOrderDetailsInsert;
-- Create the trigger
CREATE TRIGGER UpdateTotalAmountOnOrderDetailsInsert
ON Order_Details
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update TotalAmount in Orders table for affected OrderIDs
    UPDATE o
    SET TotalAmount = (
        SELECT SUM(od.Quantity * mi.Price)
        FROM Order_Details od
        JOIN Menu_Items mi ON od.ItemID = mi.ItemID
        WHERE od.OrderID = o.OrderID
    )
    FROM Orders o
    WHERE o.OrderID IN (SELECT OrderID FROM inserted);

END;


-- Removing recently added
DELETE FROM Order_Details
WHERE OrderID = 10
  AND ItemID = 4
  AND Quantity = 5;

DELETE FROM Order_Details
WHERE OrderID = 10
  AND ItemID = 5
  AND Quantity = 2;


-- Testing Trigger
INSERT INTO Order_Details (OrderID, ItemID, Quantity)
VALUES (10, 4, 5), (10, 5, 2);

-- Question 9

/*9.	Write a query to find pairs of menu items that are frequently ordered together.*/

-- Query to find pairs of menu items frequently ordered together
SELECT
    od1.ItemID AS ItemID1,
    mi1.Name AS ItemName1,
    od2.ItemID AS ItemID2,
    mi2.Name AS ItemName2,
    COUNT(*) AS Frequency
FROM
    Order_Details od1
JOIN
    Order_Details od2 ON od1.OrderID = od2.OrderID
                    AND od1.ItemID < od2.ItemID  -- Ensure ItemID1 < ItemID2 to avoid counting duplicates
JOIN
    Menu_Items mi1 ON od1.ItemID = mi1.ItemID
JOIN
    Menu_Items mi2 ON od2.ItemID = mi2.ItemID
GROUP BY
    od1.ItemID, mi1.Name, od2.ItemID, mi2.Name
HAVING
    COUNT(*) > 1  -- Adjust as needed to filter for pairs that are frequently ordered together
ORDER BY
    Frequency DESC;


-- Question 10

/*10.	Develop a query to rank restaurants by the variety of menu items they offer (number of distinct categories).*/

-- Query to rank restaurants by the variety of menu items they offer (distinct categories)
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    COUNT(DISTINCT mi.Category) AS VarietyOfMenuItems
FROM
    Restaurants r
JOIN
    Restaurant_Menu rm ON r.RestaurantID = rm.RestaurantID
JOIN
    Menu_Items mi ON rm.ItemID = mi.ItemID
GROUP BY
    r.RestaurantID, r.Name
ORDER BY
    VarietyOfMenuItems DESC;
