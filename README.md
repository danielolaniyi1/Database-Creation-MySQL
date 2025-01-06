
# GreenSpot Retail Database Creation - MySQL
This project showcases the creation and design of a MySQL database for a retail business, Greenspot. A sample of the company’s data via a .csv spreadsheet was provided to create the relational database for Greenspot (a retail business). The database is designed to address data management challenges, improve operational efficiency, and support Greenspot's strategic growth.
The SQL script i wrote for this database creation showcases the technical implementation and can be accessed [here](https://github.com/danielolaniyi1/Database-Creation-MySQL/blob/main/greenspot%20DB.sql) 


## Reason for Database Creation
Greenspot Retail’s growth and a pending merger with a larger retail chain necessitate a shift from spreadsheets to a database system. This report highlights the need for the transition and the advantages of adopting a database. Spreadsheets have served as a foundational tool but present limitations when dealing with interconnected datasets, scalability, and real-time analytics. The merger requires integrating Greenspot’s operations with the acquiring company’s systems. Spreadsheets cannot handle the volume and complexity of interconnected data, while a database ensures consistency and supports efficient integration. Transitioning to a database is essential for Greenspot’s success post-merger. It resolves spreadsheet limitations, supports integration, and enhances scalability and efficiency, ensuring sustained operational excellence.

### Spreadsheet Data Structure Overview
The spreadsheet provided contains 13 columns, namely: Item num, description, quantity on-hand, cost, purchase date, vendor, price, date sold, cust, Quantity, item type, Location, and Unit.

### Data Quality Issues in the CSV File
The sample dataset contained a number of issues that were addressed and cleaned using Microsoft Excel before being imported into the SQL database:

Empty Columns: The cost, purchase date, and vendor columns had numerous missing values.
Combined Fields: The vendor column contained both the vendor’s name and address, which were separated into distinct fields (vendor name and vendor address) during cleaning.
Inconsistent Data: Incomplete or inconsistent entries in columns such as quantity and date sold were cleaned to ensure data reliability.

### Database Design and Tables Created
Upon careful consideration of the dataset’s structure, three tables were created in the MySQL relational database to represent key entities:

**Inventory Table**: Contains the inventory ID (autogenerated), Vendor ID (foreign key), Item ID (primary key), quantity on-hand, cost, purchase date, unit, location, description, and item type.

**Vendors Table**: Contains the Vendor ID (primary key), Vendor Name, and Vendor Address.

**Sales Table**: Contains the Sales ID (autogenerated), price, date sold, quantity sold, Item ID (foreign key), and Customer.

While the dataset made it feasible to extract an Items table, the decision was made to omit it for the following reasons:
**Simplified Schema**: The essential attributes of the Items table (e.g., item description, type, and ID) are already included in the Inventory Table. This avoids redundancy and keeps the database structure straightforward.
**Limited Business Relevance**: For Greenspot’s operational focus, items are primarily managed as part of inventory rather than as a standalone entity. Separating Items into its own table could complicate queries without adding significant business value.
**Optimization for Queries**: By consolidating item attributes into the Inventory Table, queries related to stock levels, item details, and vendor associations can be executed faster and more efficiently.

### Project Summary
The resulting database design organizes Greenspot’s operations into three essential tables—Inventory, Vendors, and Sales—while intentionally omitting the Items table to prioritize simplicity, avoid redundancy, and streamline queries. This decision enhances the database's usability and performance, aligning with Greenspot’s operational focus.

The SQL script i wrote for this database creation showcases the technical implementation and can be accessed [here](https://github.com/danielolaniyi1/Database-Creation-MySQL/blob/main/greenspot%20DB.sql) 

This project not only addresses Greenspot’s immediate data management needs but also prepares the company for smooth integration into the acquiring retail chain’s systems. The database ensures operational efficiency, maintains data integrity, and provides the scalability necessary for Greenspot’s continued growth 

By transitioning from spreadsheets to a relational database, Greenspot Retail has established a robust foundation for long-term success, adaptability, and competitive advantage in a dynamic market.
