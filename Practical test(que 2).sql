-- Create the table
--BrandCommission TABLE
CREATE TABLE BrandCommission (
    Brand NVARCHAR(50) NOT NULL PRIMARY KEY,
    FixedCommission NVARCHAR(10) NOT NULL,
    ClassA_Commission DECIMAL(5, 2) NOT NULL,
    ClassB_Commission DECIMAL(5, 2) NOT NULL,
    ClassC_Commission DECIMAL(5, 2) NOT NULL,
    ConditionDescription NVARCHAR(100)
);

INSERT INTO BrandCommission (Brand, FixedCommission, ClassA_Commission, ClassB_Commission, ClassC_Commission, ConditionDescription)
VALUES
    ('Audi', '800$', 8.00, 6.00, 4.00, 'If Car Model Price above 25000$'),
    ('Jaguar', '750$', 6.00, 5.00, 3.00, 'If Car Model Price above 35000$'),
    ('Land Rover', '850$', 7.00, 5.00, 4.00, 'If Car Model Price above 30000$'),
    ('Renault', '400$', 5.00, 3.00, 2.00, 'If Car Model Price above 20000$');

--MonthlySales table
CREATE TABLE MonthlySales (
    Salesman NVARCHAR(50) NOT NULL,
    Class CHAR(1) NOT NULL CHECK (Class IN ('A', 'B', 'C')),
    Cars_Sold_Audi INT NOT NULL DEFAULT 0 CHECK (Cars_Sold_Audi >= 0),
    Cars_Sold_Jaguar INT NOT NULL DEFAULT 0 CHECK (Cars_Sold_Jaguar >= 0),
    Cars_Sold_LandRover INT NOT NULL DEFAULT 0 CHECK (Cars_Sold_LandRover >= 0),
    Cars_Sold_Renault INT NOT NULL DEFAULT 0 CHECK (Cars_Sold_Renault >= 0)
);
INSERT INTO MonthlySales (Salesman, Class, Cars_Sold_Audi, Cars_Sold_Jaguar, Cars_Sold_LandRover, Cars_Sold_Renault)
VALUES
    ('Salesman 1', 'A', 1, 3, 0, 6),
    ('Salesman 1', 'B', 2, 4, 2, 2),
    ('Salesman 1', 'C', 3, 6, 1, 1),
    ('Salesman 2', 'A', 0, 5, 5, 3),
    ('Salesman 2', 'B', 0, 4, 2, 2),
    ('Salesman 2', 'C', 2, 1, 1, 6),
    ('Salesman 3', 'A', 4, 2, 1, 6),
    ('Salesman 3', 'B', 2, 7, 2, 3),
    ('Salesman 3', 'C', 0, 1, 3, 1);


-- SalesmanTotalSales table
CREATE TABLE SalesmanTotalSales (
    Salesman NVARCHAR(50) NOT NULL PRIMARY KEY,
    LastYearTotalSales DECIMAL(12, 2) NOT NULL CHECK (LastYearTotalSales >= 0)
);
INSERT INTO SalesmanTotalSales (Salesman, LastYearTotalSales)
VALUES
    ('Salesman1', 600000.00),
    ('Salesman2', 450000.00),
    ('Salesman3', 550000.00);


select * from BrandCommission	
select * from SalesmanTotalSales
select * from MonthlySales


--Query for Salesman Comission Report
	SELECT 
    ms.Salesman,    
    SUM(
        ms.Cars_Sold_Audi * bc.ClassA_Commission +
        ms.Cars_Sold_Jaguar * bc.ClassB_Commission +
        ms.Cars_Sold_LandRover * bc.ClassC_Commission +
        ms.Cars_Sold_Renault * bc.ClassC_Commission
    ) AS Total_Commission,

    CASE 
        WHEN st.LastYearTotalSales > 500000 THEN 
            SUM(ms.Cars_Sold_Audi * bc.ClassA_Commission) * 0.02
        ELSE 0
    END AS Additional_Commission,

    SUM(
        ms.Cars_Sold_Audi * bc.ClassA_Commission +
        ms.Cars_Sold_Jaguar * bc.ClassB_Commission +
        ms.Cars_Sold_LandRover * bc.ClassC_Commission +
        ms.Cars_Sold_Renault * bc.ClassC_Commission
    ) +
    CASE 
        WHEN st.LastYearTotalSales > 500000 THEN 
            SUM(ms.Cars_Sold_Audi * bc.ClassA_Commission) * 0.02
        ELSE 0
    END AS Final_Commission

FROM 
    MonthlySales ms
LEFT JOIN 
    BrandCommission bc 
    ON (bc.Brand = 'Audi' AND ms.Cars_Sold_Audi > 0)
    OR (bc.Brand = 'Jaguar' AND ms.Cars_Sold_Jaguar > 0)
    OR (bc.Brand = 'Land Rover' AND ms.Cars_Sold_LandRover > 0)
    OR (bc.Brand = 'Renault' AND ms.Cars_Sold_Renault > 0)
LEFT JOIN 
    SalesmanTotalSales st 
    ON ms.Salesman = st.Salesman

GROUP BY 
    ms.Salesman, 
    st.LastYearTotalSales;

