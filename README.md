# SQL Projects

This repository is for basic, intermediate and advanced SQL projects. I've used advanced concepts like window functions, CTEs and subqueries too. 

The DB is **PostgreSQL** version 16 and all queries are performed using DBeaver Community Edition tool. 

# Advantages of PostgreSQL:

(1) Open-source

(2) Supports all kind of advanced database and DWH operations like recursive queries, common table expressions (CTEs), subqueries, complicated SQL queries, and window functions. Additionally, it supports user-defined functions (UDFs), triggers, and stored procedures **in a number of programming languages.**

(3) Customizability and Extensibility: Thanks to PostgreSQL's design, programmers can add new custom data types, operators, and functions to the database to expand its capability. It is also helpful for managing particular data types or developing domain-specific features because of its extensibility.

I've imported all data from Web (In form of CSVs). 

# Hurdles and Learnings:

When importing CSVs to database, I faced few hurdles. Learnings from them are documented here.

(1) If CSV is too large(More than 1,00,000 records), it can't be imported in one go. It is better to break it down in chunks and import them one by one. The restriction is there because of community edition software. Full-fledged license edition won't have it.

(2) CSVs won't have keys(Primary and foreign keys). **ALWAYS** generate them by leveraging database features. Put other constraints like **NOT NULL, DEFAULT, CHECK** also.

(3) CSVs are semi-structured data but database is purely structured data. CSVs are bound to have errors like wrong format (Dates and Currencies), multiple formats etc. Hence **Data Cleaning** is an essential part of every Data Analytics project. 

I've realized that cleaning starts from CSV(Excel) itself. Few learnings:

  => Character data would generally take anything. **ALWAYS** check minimum and maximum length before pushing to database so that correct data types can be applied.
  
  => Dates can be in various formats like MM/DD/YY or DD/MM/YYYY or DD-MM-YY. **ALWAYS** convert them to one single format. **Before converting, check whether your target database supports that date format or not.** Dates can contain N/A or NA too. It's up to Data Analyst to decide what does that mean. You need to have context and domain knowledge in place for this.
  
  => Numeric data can have errors like division by 0(In case of decimals), different formats, outliers(One number is way too large or way too small in compare to others) etc. Excel can detect this easily. Numbers can also have N/A. It's up to Data Analyst to decide whether it means 0 or Not Available.

(4) In case of large CSVs, **ALWAYS** perform **Sampling**. 

# Modules

(1) Olympics Data Analysis
(2) Study Performance Analysis

You can find details of each module in respective folder.
