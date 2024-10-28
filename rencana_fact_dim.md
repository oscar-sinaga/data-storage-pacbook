## dim_Customer

- customer_id(PK)
- created_at
- updated_at

### Table customer

- customer_id (NK)
- first_name
- last_name
- email

### Table customer_address

- customer_id (relate to customer)
- address_id
- status_id

### Table address

- address_id (relate to customer_address)
- city
- counytry_id (relate to country)

### Table country

- counytry_id (relate to address)
- country_name

## dim_book

- book_id (PK)
- created_at
- updated_at

### table_book

- book_id (NK)
- title
- isbn13
- language_id (relation to language)
- num_pages
- publication_date
- publisher_id (relation to publisher)

### table_Book_author

- book_id (relation to book)
- author_id (relation to author)

### table_author

- author_id (relation to book_author)
- author_name

### table_book_language

- language_id (relation to book)
- language_code
- language_name

### table_Publisher

- publisher_id (relation to book)
- publisher_name

## facts_book_order

- book_order_id (PK)
- customer_id (dd)
- book_id (dd)
- created_at
- updated_at

### table cust_order

- order_id (NK)
- order_date
- customer_id (relate to facts_book_order)
- dest_address_id (relate to address)

### Table order_line

- order_id (relate to facts_book_order)
- book_id (relate to facts_book_order)
- price

## facts_monthly_order

- sk_monthly_order (PK)
- month (relate to cust_order : grouping berdasarkan bulan )
- year (relate to cust_order : grouping berdasarkan bulan )
- total_order (relate to cust_order : grouping berdasarkan bulan )
- customer_id (relate to dim_customer)
- book_id (dd)
- created_at
- updated_at

## facts_repeat_order_time

- sk_repeat_order_time_id
- sk_customer_id (relation to dim_customer)
- nk_customer_id (relation to dim_customer)
- nk_order_id (relation to cust_order)
- order_date (relation to cust_order)
- previous_order_date (relation to cust_order)
- order_time_interval (calculate order_date - previous_date)
- created_at
- updated_at
