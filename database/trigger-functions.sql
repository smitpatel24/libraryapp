-- Trigger to automatically add a book copy to the status table when a new book is added to BookCopies
CREATE OR REPLACE FUNCTION add_book_status()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO book_status (copy_id, status, status_date)
    VALUES (NEW.copy_id, 'Active', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_book_status_trigger
AFTER INSERT ON book_copies
FOR EACH ROW EXECUTE FUNCTION add_book_status();



-- Create a trigger function to update BookCopies table
CREATE OR REPLACE FUNCTION update_bookcopies()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the transaction type is 'Check Out' (1)
    IF NEW.transaction_type = 'Check Out' THEN
        -- Update the corresponding BookCopies entry to set available to False
        UPDATE book_copies
        SET available = FALSE
        WHERE copy_id = NEW.copy_id;
    
    -- Check if the transaction type is 'Return' (2)
    ELSIF NEW.transaction_type = 'Return' THEN
        -- Update the corresponding BookCopies entry to set available to True
        UPDATE book_copies
        SET available = TRUE
        WHERE copy_id = NEW.copy_id;
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;



-- Create a trigger to execute the trigger function after an INSERT operation on the Transactions table
CREATE TRIGGER transactions_after_insert_trigger
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_bookcopies();

