
-- 1. **book_copies_view:**

DROP VIEW IF EXISTS book_copies_view;

CREATE VIEW book_copies_view AS
SELECT 
    bc.copy_id,
    b.book_id,
    b.title AS book_title,
    a.author_name,
    bc.barcode,
    bc.available,
    (
        SELECT user_id
        FROM transactions t
        WHERE t.copy_id = bc.copy_id AND t.transaction_type = 'Check Out'
        ORDER BY t.transaction_id DESC
        LIMIT 1
    ) AS user_id,
    lbs.status
FROM 
    books b
JOIN 
    authors a ON b.author_id = a.author_id
JOIN 
    book_copies bc ON b.book_id = bc.book_id
LEFT OUTER JOIN 
    latest_book_status lbs ON lbs.copy_id = bc.copy_id;


-- 2. **all_books_info:**
DROP VIEW IF EXISTS all_books_info;

CREATE VIEW all_books_info AS
SELECT
    b.book_id,
    b.title AS book_name,
    a.author_name,
    COUNT(bc.copy_id) AS total_copies,
    SUM(CASE WHEN bc.available THEN 1 ELSE 0 END) AS available,
    SUM(CASE WHEN NOT bc.available THEN 1 ELSE 0 END) AS checked_out
FROM
    books b
JOIN
    authors a ON b.author_id = a.author_id
LEFT JOIN
    book_copies bc ON b.book_id = bc.book_id
GROUP BY
    b.book_id, b.title, a.author_name;


-- 3. **available_books:**
DROP VIEW IF EXISTS available_books;

CREATE VIEW available_books AS
SELECT 
    bc.copy_id, 
    b.title AS book_name, 
    a.author_name, 
    bc.barcode
FROM 
    books b
JOIN 
    authors a ON b.author_id = a.author_id
JOIN 
    book_copies bc ON b.book_id = bc.book_id
WHERE 
    bc.available = TRUE;


-- 4. **checked_out_books:**
DROP VIEW IF EXISTS checked_out_books;

CREATE VIEW checked_out_books AS
SELECT 
    bc.copy_id, 
    b.title AS book_name, 
    a.author_name, 
    bc.barcode,
    t.transaction_date AS checked_out_date,
    t.due_date AS due_date
FROM 
    books b
JOIN 
    authors a ON b.author_id = a.author_id
JOIN 
    book_copies bc ON b.book_id = bc.book_id
JOIN 
    transactions t ON bc.copy_id = t.copy_id 
WHERE 
    bc.available = FALSE;


-- 5. **latest_book_status:**
CREATE OR REPLACE VIEW latest_book_status AS
SELECT 
    copy_id, 
    status, 
    status_date
FROM (
    SELECT 
        copy_id, 
        status, 
        status_date,
        ROW_NUMBER() OVER (PARTITION BY copy_id ORDER BY status_date DESC) AS status_rank
    FROM 
        book_status
) AS ranked_status
WHERE 
    status_rank = 1;


-- 6. **book_status_view:**
DROP VIEW IF EXISTS book_status_view;

CREATE VIEW book_status_view AS
SELECT 
    bc.copy_id,
    b.book_id,
    b.title AS book_title,
    a.author_name,
    bc.barcode,
    bs.status,
    bs.status_date
FROM 
    books b
JOIN 
    authors a ON b.author_id = a.author_id
JOIN 
    book_copies bc ON b.book_id = bc.book_id
JOIN 
    book_status bs ON bs.copy_id = bc.copy_id;


-- 7. **transactions_view:**
DROP VIEW IF EXISTS transactions_view;

CREATE VIEW transactions_view AS
SELECT 
    t.transaction_id, 
    bc.copy_id, 
    u.username, 
    b.title AS book_name, 
    a.author_name, 
    t.transaction_type, 
    t.transaction_date, 
    t.due_date, 
    t.return_date
FROM 
    transactions t
JOIN 
    users u ON t.user_id = u.user_id
JOIN 
    book_copies bc ON t.copy_id = bc.copy_id
JOIN 
    books b ON bc.book_id = b.book_id
JOIN 
    authors a ON b.author_id = a.author_id;