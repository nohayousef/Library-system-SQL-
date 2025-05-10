# 📚 Library Management SQL Project

This project demonstrates the use of SQL queries to manage and analyze data in a library database system. It focuses on querying book availability, loans, and inventory information — using the book *Dracula* as a case study.

## 🗂️ Project Overview

The SQL script performs various operations on a fictional library database. It includes:

- Checking total number of copies of a specific book
- Determining how many copies are currently available (i.e., not loaned out)
- Viewing current loans and historical loan records

## 🧾 Schema Assumptions

This project assumes the existence of at least two tables:

1. **`books`**:
   - `BookID` (Primary Key)
   - `Title`
   - Other book-related metadata

2. **`loans`**:
   - `LoanID` (Primary Key)
   - `BookID` (Foreign Key referencing `books`)
   - `LoanDate`
   - `ReturnedDate` (NULL if the book is not returned)

## 🔍 Sample Queries Included

- **Find total copies of "Dracula"**:
  ```sql
  SELECT title, COUNT(*) AS Number_Of_Copies FROM books
  WHERE Title = 'Dracula';
  ```

- **Find available (not loaned out) copies**:
  ```sql
  SELECT title, COUNT(*) AS available_copies FROM books
  WHERE Title = 'Dracula' AND BookID NOT IN (
      SELECT BookID FROM loans
      WHERE ReturnedDate IS NULL
  );
  ```

- **View loan history**:
  ```sql
  SELECT l.BookID, l.LoanDate, l.ReturnedDate FROM loans l
  JOIN books b ON l.BookID = b.BookID
  WHERE b.Title = 'Dracula';
  ```

