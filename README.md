# Sales_Order_PostgreSQL
This project demonstrates a well-designed relational database using PostgreSQL for managing sales orders with an emphasis on data integrity, consistency, and the application of various SQL concepts to interact with and retrieve meaningful information from the database.

## Database Structure:
### Tables:
•	Products: Stores information about various products, including a unique product code, product line, and price.

•	Customers: Manages customer details such as customer ID, name, contact information and address.

•	Sales_order: Captures sales order data, including order number, quantity ordered, pricing, order date, status. 

	qtr_id, month_id, and year_id columns in the Sales_order table to track the quarter and month of each order providing temporal context to the data and references to specific products and customers.

	Deal Size Classification: Implemented a deal_size column in the Sales_order table with a check constraint to classify orders into 'Small', 'Medium', or 'Large' based on predefined criteria.

## SQL Commands Used:
The project incorporates key SQL concepts, including Data Definition Language (DDL) for table creation, Data Manipulation Language (DML) for data manipulation, Transaction Control Language (TCL) for managing transactions, and Data Query Language (DQL) for retrieving information.
Clause and Functions used:

•	Common Table Expressions (CTE)/WITH Clause: To create temporary result sets within queries. CTEs can enhance the readability and reusability of complex queries.

•	Subqueries: Integrated subqueries within SELECT, WHERE and FROM clauses to retrieve or filter data based on the results of another query.

•	Joins: Utilized JOIN operations to combine data from multiple tables. This enables the retrieval of comprehensive information by linking related records.

•	Aggregate Functions: Applied aggregate functions such as AVG, SUM, and COUNT to calculate summary statistics and derive insights from the data.


# Sales_Order_SQL
