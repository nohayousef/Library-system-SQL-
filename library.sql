use library;
-- find the number of availalbe copies of the book (Dracula)
select * from books;
select * from loans;
select * from patrons;

/*******************************************************/
/* find the number of availalbe copies of the book (Dracula)     
/* check total copies of the book */-- (misunderstand this point)
SELECT COUNT(*) AS Number_Of_Copies FROM books
WHERE Title = 'Dracula';

SELECT b.BookID, b.Title, COUNT(DISTINCT l.LoanID) AS TotalCopies FROM books b
JOIN loans l ON b.BookID = l.BookID
WHERE Title = 'Dracula'
GROUP BY b.BookID, b.Title;
/*******************************************************/
SELECT COUNT(*) FROM loans 
WHERE BookID IN (SELECT BookID FROM books 
WHERE Title = 'Dracula'
) 
AND ReturnedDate IS NULL;

/*******************************************************/
-- /* current total loans of the book */ -- (-- missunderstand3333333333333333333333333333333333333******************************)
SELECT 
    COUNT(*) AS TotalLoans 
FROM 
    loans
WHERE 
    BookID = (
        SELECT 
            BookID 
        FROM 
            books 
        WHERE 
            Title = 'Dracula'
        LIMIT 1
    );



SELECT  l.bookid, l.loandate, l.returneddate FROM loans l
JOIN books b ON l.bookid = b.bookid
WHERE b.title = 'Dracula';

/*******************************************************/
/* total available books of dracula */
-- your code
SELECT COUNT(*) AS available_copies FROM books
WHERE Title = 'Dracula' AND BookID NOT IN (
  SELECT BookID
  FROM loans
  WHERE ReturnedDate IS NULL
);
-- Calculate the total available copies of "Dracula"
WITH TotalCopies AS (
    SELECT COUNT(*) AS total_copies
    FROM books
    WHERE Title = 'Dracula'
),
TotalLoans AS (
    SELECT COUNT(*) AS total_loans
    FROM loans
    JOIN books ON loans.BookID = books.BookID
    WHERE books.Title = 'Dracula' AND loans.ReturnedDate IS NULL
)
SELECT (TotalCopies.total_copies - TotalLoans.total_loans) AS available_copies
FROM TotalCopies, TotalLoans;

/*******************************************************/
/* Add new books to the library    --(miss***************************************************************************333)                    */
/*******************************************************/
-- your code
INSERT INTO books (BookID, Title, Author, Published, Barcode)
VALUES (
    'new book id', 'New Book Title', 'New Book Author', 2023, 'new barcode' 
);
INSERT INTO books (id, title, published_year, isbn) VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, '978-0-06-112008-4');
-- Insert a new book into the library database
INSERT INTO books (BookID, Title, Author, Published, Barcode) VALUES
(66, 'Dracula', 'Bram Stoker', 1897, 9781234567897);

/*******************************************************/
/* Check out Books: books(4043822646, 2855934983) whose patron_email(jvaan@wisdompets.com), loandate=2020-08-25, duedate=2020-09-08, loanid=by_your_choice                            */
SELECT b.* FROM books b 
WHERE b.BookID 
IN (SELECT l.BookID FROM loans l JOIN patrons p ON l.PatronID = p.PatronID 
WHERE p.Email = 'jvaan@wisdompets.com'AND l.LoanDate = '2020-08-25'AND l.DueDate = '2020-09-08'AND l.LoanID = 'by_your_choice');
SELECT 
    b.BookID, 
    b.Title, 
    b.Author, 
    b.Published, 
    b.Barcode, 
    l.LoanDate, 
    l.DueDate,
    l.LoanID
FROM 
    books b
JOIN 
    loans l ON b.BookID = l.BookID
WHERE 
    l.LoanDate = '2020-08-25' AND l.DueDate = '2020-09-08' AND l.LoanID =  'by_your_choice';
/********************************************************/
SELECT 
    b.BookID, 
    b.Title, 
    b.Author, 
    b.Published, 
    b.Barcode 
FROM 
    books b 
JOIN 
    loans l ON b.BookID = l.BookID 
JOIN 
    patrons p ON l.PatronID = p.PatronID 
WHERE 
    p.Email = 'jvaan@wisdompets.com'
    AND l.LoanDate = '2020-08-25'
    AND l.DueDate = '2020-09-08'
    AND l.LoanID = 'by_your_choice'; 
/********************************************************/
/* Check books for Due back                             */
/* generate a report of books due back on July 13, 2020 */
/* with patron contact information                      */
/********************************************************/
SELECT
    b.Title,
    b.Author,
    l.DueDate,
    p.FirstName,
    p.LastName,
    p.Email
FROM
    books b
JOIN
    loans l ON b.BookID = l.BookID
JOIN
    patrons p ON l.PatronID = p.PatronID
WHERE
    l.DueDate = '2020-07-13';

/*******************************************************/
/* Return books to the library (which have barcode=6435968624) and return this book at this date(2020-07-05)                    */
/*******************************************************/
SELECT * FROM loans
WHERE BookID IN (SELECT BookID FROM books WHERE Barcode = 6435968624)
AND ReturnedDate IS NULL;

UPDATE loans
SET ReturnedDate = '2020-07-05'
WHERE BookID IN (SELECT BookID FROM books 
WHERE Barcode = 6435968624);


/*******************************************************/
/* Encourage Patrons to check out books                */
/* generate a report of showing 10 patrons who have
checked out the fewest books.                          */
/*******************************************************/
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
SELECT b.Title, COUNT(l.BookID) AS checkout_count FROM loans l
JOIN books b ON l.BookID = b.BookID
GROUP BY b.Title
ORDER BY checkout_count DESC
LIMIT 5;