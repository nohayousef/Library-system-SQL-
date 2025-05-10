use library;
/******************* In the Library *********************/

/*******************************************************/
/* find the number of availalbe copies of the book (Dracula)      */
/*******************************************************/
-- your code
SELECT title, COUNT(*) AS Number_Of_Copies FROM books
WHERE Title = 'Dracula';

-- Find the number of available copies of "Dracula"
SELECT title, COUNT(*) AS available_copies FROM books
WHERE Title = 'Dracula' AND BookID NOT IN (
SELECT BookID FROM loans
WHERE ReturnedDate IS NULL
);

/* check total copies of the book */
-- your code
SELECT b.BookID, b.Title, COUNT(DISTINCT l.LoanID) AS TotalCopies FROM books b
JOIN loans l ON b.BookID = l.BookID
WHERE Title = 'Dracula'
GROUP BY b.BookID, b.Title;
-- OR******
SELECT  l.bookid, l.loandate, l.returneddate FROM loans l
JOIN books b ON l.bookid = b.bookid
WHERE b.title = 'Dracula';



/* current total loans of the book */
-- your code
SELECT COUNT(b.BookID) AS notAvailableCopies FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
WHERE b.Title = 'Dracula'
AND l.ReturnedDate IS NULL;

/* total available books of dracula */
-- your code
SELECT title, COUNT(*) AS Number_Of_Copies FROM books
WHERE Title = 'Dracula';

WITH DraculaBooks AS (
SELECT BookID FROM books 
WHERE Title = 'Dracula'
),

ActiveLoans AS (
SELECT BookID FROM loans
WHERE ReturnedDate IS NULL
)

SELECT COUNT(b.BookID) AS AvailableCopies FROM books b
LEFT JOIN ActiveLoans al ON b.BookID = al.BookID
WHERE b.BookID IN (SELECT BookID FROM DraculaBooks)
AND al.BookID IS NULL;

/*******************************************************/
/* Add new books to the library                        */
/*******************************************************/
-- your code
INSERT INTO books (bookid, title, author, published, barcode) VALUES
(201,'The Great Gatsby', 'F. Scott Fitzgerald', '1925', '9780743273565')
;
select bookid, title, author, published, barcode from books
where bookid = 201 ;
/*******************************************************/
/* Check out Books: books(4043822646, 2855934983) whose patron_email(jvaan@wisdompets.com), loandate=2020-08-25, duedate=2020-09-08, loanid=by_your_choice                            */
/*******************************************************/
SELECT *
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
JOIN Patrons p ON l.PatronID = p.PatronID
WHERE p.Email = 'jvaan@wisdompets.com'
  AND l.LoanDate = '2020-08-25'
  AND l.DueDate = '2020-09-08';
-- your code

select * from books
where barcode = 4043822646 and 2855934983;
-- ******
SELECT * FROM books
WHERE BookID IN (
SELECT b.BookID FROM loans l 
JOIN books b ON l.BookID = b.BookID 
WHERE l.PatronID = (
SELECT PatronID FROM patrons 
WHERE Email = 'jvaan@wisdompets.com') 
AND l.LoanDate = '2020-08-25' 
AND l.DueDate = '2020-09-08'
);

/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/
-- your code
SELECT b.Title, b.Author, l.DueDate, p.FirstName, p.LastName, p.Email  FROM books b
JOIN loans l ON b.BookID = l.BookID
JOIN patrons p ON l.PatronID = p.PatronID
WHERE l.DueDate = '2020-07-13';
/*******************************************************/
/* Return books to the library (which have barcode=6435968624) and return this book at this date(2020-07-05)                    */
/*******************************************************/
SELECT BookID
FROM books
WHERE Barcode = 6435968624;
SELECT LoanID
FROM loans
WHERE BookID = (SELECT BookID FROM books WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL;

UPDATE loans
SET ReturnedDate = '2020-07-05'
WHERE LoanID = 
(SELECT LoanID FROM loans
WHERE BookID = 
(SELECT BookID FROM books WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL);
-- your code
SELECT * FROM loans
WHERE BookID = (SELECT BookID FROM books 
WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL;

UPDATE loans
SET ReturnedDate = '2020-07-05'
WHERE BookID = (SELECT BookID FROM books WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL;

/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/
-- your code
SELECT p.FirstName, p.LastName, COUNT(l.LoanID) AS TotalLoans FROM patrons p
LEFT JOIN loans l ON p.PatronID = l.PatronID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalLoans ASC
LIMIT 10;

/*******************************************************/
/* Find books to feature for an event                  
 create a list of books from 1890s that are
 currently available                                    */
/*******************************************************/
-- your code
SELECT b.BookID, b.Title, b.Published FROM books AS b 
WHERE b.Published BETWEEN 1890 AND 1899 AND b.BookID 
NOT IN (SELECT l.BookID FROM loans AS l 
WHERE l.ReturnedDate IS NULL
);

/*******************************************************/
/* Book Statistics 
/* create a report to show how many books were 
published each year.                                    */
/*******************************************************/
SELECT Published, COUNT(DISTINCT(Title)) AS TotalNumberOfPublishedBooks
FROM Books
GROUP BY Published
ORDER BY TotalNumberOfPublishedBooks DESC;


/*************************************************************/
/* Book Statistics                                           */
/* create a report to show 5 most popular Books to check out */
/*************************************************************/
SELECT b.Title, b.Author, b.Published, COUNT(b.Title) AS TotalTimesOfLoans
FROM Books b
JOIN Loans l
ON b.BookID = l.BookID
GROUP BY b.Title
ORDER BY 4 DESC
LIMIT 5;
/*************************************************************/
-- solved by me .
SELECT b.Title, COUNT(l.BookID) AS checkout_count FROM loans l
JOIN books b ON l.BookID = b.BookID
GROUP BY b.Title
ORDER BY checkout_count DESC
LIMIT 5;
