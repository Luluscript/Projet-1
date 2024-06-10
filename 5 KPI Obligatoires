----- CA DEUX MEILLEURS VENDEURS MENSUEL AVEC CLASSEMENT

WITH MonthlySales AS (
    SELECT 
        e.employeeNumber, 
        e.lastName AS lastname_employe,
        e.firstname AS firstname_employe,
        YEAR(o.orderDate) AS year, 
        MONTH(o.orderDate) AS mois, 
        SUM(od.quantityOrdered * od.priceEach) AS CA
    FROM employees e
    JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY e.employeeNumber, e.lastName, e.firstname, YEAR(o.orderDate), MONTH(o.orderDate)
),

RankedSales AS (
    SELECT 
        ms.employeeNumber, 
        ms.lastname_employe, 
        ms.firstname_employe,
        ms.year, 
        ms.mois, 
        ms.CA,
        RANK() OVER (PARTITION BY ms.year, ms.mois ORDER BY ms.CA DESC) AS classement
    FROM MonthlySales ms
)

SELECT 
    rs.employeeNumber AS salesRepEmployeeNumber, 
    CONCAT(rs.year, '-', LPAD(rs.mois, 2, '0')) AS mois, 
    rs.lastname_employe,
    rs.firstname_employe,
    rs.CA, 
    rs.classement
FROM RankedSales rs
WHERE rs.classement <= 2
ORDER BY rs.year DESC, rs.mois DESC, rs.classement;

--VENTES GAMME N vs N-1

SELECT 
    p.productLine,
    MONTH(o.orderDate) AS month,
    SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2022,
    SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2023,
    SUM(CASE WHEN YEAR(o.orderDate) = 2024 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2024,
    CASE 
        WHEN COALESCE(SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END), 0) > 0 
        THEN ROUND(
            ((SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END) - 
              SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END)) / 
              SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END)) * 100, 0)
        ELSE 0 
    END AS tauxEvolution_2023,
    CASE 
        WHEN COALESCE(SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END), 0) > 0 
        THEN ROUND(
            ((SUM(CASE WHEN YEAR(o.orderDate) = 2024 THEN od.quantityOrdered ELSE 0 END) - 
              SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END)) / 
              SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END)) * 100, 0)
        ELSE 0 
    END AS tauxEvolution_2024
FROM 
    orderdetails od
JOIN 
    products p ON od.productCode = p.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    p.productLine, MONTH(o.orderDate)
ORDER BY 
    p.productLine, month;


 -- Variation du nombte de vente par catégorie au cours des différents trimestres et années (en utilisant window fonction)
		-- en ajoutant l'évolution

SELECT 
    p.productLine,
    MONTH(o.orderDate) AS month,
    SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2022,
    SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2023,
    SUM(CASE WHEN YEAR(o.orderDate) = 2024 THEN od.quantityOrdered ELSE 0 END) AS totalQuantityOrdered_2024,
    CASE 
        WHEN SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END) > 0 
        THEN ROUND(
            ((SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END) - 
              SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END)) / 
              SUM(CASE WHEN YEAR(o.orderDate) = 2022 THEN od.quantityOrdered ELSE 0 END)) * 100, 0)
        ELSE NULL 
    END AS tauxEvolution_2023,
    CASE 
        WHEN SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END) > 0 
        THEN ROUND(
            ((SUM(CASE WHEN YEAR(o.orderDate) = 2024 THEN od.quantityOrdered ELSE 0 END) - 
              SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END)) / 
              SUM(CASE WHEN YEAR(o.orderDate) = 2023 THEN od.quantityOrdered ELSE 0 END)) * 100, 0)
        ELSE NULL 
    END AS tauxEvolution_2024
FROM 
    orderdetails od
JOIN 
    products p ON od.productCode = p.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    p.productLine, MONTH(o.orderDate)
ORDER BY 
    p.productLine, month;


-- top 5 +  stock en cumulés
SELECT p.productCode, p.productName, p.productLine, p.quantityInStock, SUM(od.quantityOrdered) AS total_ventes
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.productLine, p.quantityInStock
ORDER BY total_ventes DESC
LIMIT 5;


-- CA 5 DERNIERS MOIS PAR PAYS
SELECT 
    c.country,
    YEAR(o.orderDate) AS orderYear,
    MONTH(o.orderDate) AS orderMonth,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
WHERE 
    (YEAR(o.orderDate) = 2024) OR (YEAR(o.orderDate) = 2023 AND MONTH(o.orderDate) >= 10) 
GROUP BY 
    c.country, YEAR(o.orderDate), MONTH(o.orderDate)
ORDER BY 
    c.country, orderYear, orderMonth;

-- IMPAYES

SELECT
    c.customerNumber,
    c.customerName,
    COALESCE(totalOrdersData.totalOrders, 0) AS totalOrders,
    COALESCE(totalOrdersData.totalOrderAmount, 0) AS totalOrderAmount,
    COALESCE(paymentsData.totalPaymentAmount, 0) AS totalPaymentAmount,
    COALESCE(totalOrdersData.totalOrderAmount, 0) - COALESCE(paymentsData.totalPaymentAmount, 0) AS etatDesPaiements,
    c.creditLimit,
    ROUND ((COALESCE(totalOrdersData.totalOrderAmount, 0) - COALESCE(paymentsData.totalPaymentAmount, 0)) / c.creditLimit * 100, 2) AS etatParRapportALimite
FROM
    customers c
LEFT JOIN (
    SELECT
        c.customerNumber,
        COUNT(o.orderNumber) AS totalOrders,
        SUM(od.quantityOrdered * od.priceEach) AS totalOrderAmount
    FROM
        customers c
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY
        c.customerNumber
) AS totalOrdersData ON c.customerNumber = totalOrdersData.customerNumber
LEFT JOIN (
    SELECT
        p.customerNumber,
        SUM(p.amount) AS totalPaymentAmount
    FROM
        payments p
    GROUP BY
        p.customerNumber
) AS paymentsData ON c.customerNumber = paymentsData.customerNumber
ORDER BY
    c.customerNumber;
