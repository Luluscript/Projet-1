-- Marge brut des 5 Flop
CREATE VIEW flop_product_vw AS
(SELECT p.productName,
SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS grossMargin
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productName
ORDER BY grossMargin ASC
LIMIT 5);
