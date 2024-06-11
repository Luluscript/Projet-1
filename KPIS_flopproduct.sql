
-- Marge des moins bonnes ventes

CREATE VIEW flop_product_vw AS
SELECT p.productName, 
SUM(od.quantityOrdered) AS totalQuantityOrdered,
SUM(od.priceEach * od.quantityOrdered) AS sales_product,
SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS grossMargin
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productName
ORDER BY sales_product ASC
LIMIT 5;
