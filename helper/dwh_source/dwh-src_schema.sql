CREATE SCHEMA pacbook_src AUTHORIZATION pg_database_owner;
--
-- Name: address; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.address (
    address_id integer NOT NULL,
    street_number character varying(10),
    street_name character varying(200),
    city character varying(100),
    country_id integer
);
--
-- Name: address_status; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.address_status (
    status_id integer NOT NULL,
    address_status character varying(30)
);
--
-- Name: author; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.author (
    author_id integer NOT NULL,
    author_name character varying(400)
);
--
-- Name: book; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.book (
    book_id integer NOT NULL,
    title character varying(400),
    isbn13 character varying(13),
    language_id integer,
    num_pages integer,
    pacbook_srcation_date date,
    publisher_id integer
);
--
-- Name: book_author; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.book_author (
    book_id integer NOT NULL,
    author_id integer NOT NULL
);
--
-- Name: book_language; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.book_language (
    language_id integer NOT NULL,
    language_code character varying(8),
    language_name character varying(50)
);
--
-- Name: country; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.country (
    country_id integer NOT NULL,
    country_name character varying(200)
);
--
-- Name: cust_order; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.cust_order (
    order_id integer NOT NULL,
    order_date timestamp without time zone,
    customer_id integer,
    shipping_method_id integer,
    dest_address_id integer
);
--
-- Name: cust_order_order_id_seq; Type: SEQUENCE; Schema: pacbook_src; Owner: postgres
--
CREATE SEQUENCE pacbook_src.cust_order_order_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
--
-- Name: cust_order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: pacbook_src; Owner: postgres
--
ALTER SEQUENCE pacbook_src.cust_order_order_id_seq OWNED BY pacbook_src.cust_order.order_id;
--
-- Name: customer; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.customer (
    customer_id integer NOT NULL,
    first_name character varying(200),
    last_name character varying(200),
    email character varying(350)
);
--
-- Name: customer_address; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.customer_address (
    customer_id integer NOT NULL,
    address_id integer NOT NULL,
    status_id integer
);
--
-- Name: order_history; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.order_history (
    history_id integer NOT NULL,
    order_id integer,
    status_id integer,
    status_date timestamp without time zone
);
--
-- Name: order_history_history_id_seq; Type: SEQUENCE; Schema: pacbook_src; Owner: postgres
--
CREATE SEQUENCE pacbook_src.order_history_history_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
--
-- Name: order_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: pacbook_src; Owner: postgres
--
ALTER SEQUENCE pacbook_src.order_history_history_id_seq OWNED BY pacbook_src.order_history.history_id;
--
-- Name: order_line; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.order_line (
    line_id integer NOT NULL,
    order_id integer,
    book_id integer,
    price numeric(5, 2)
);
--
-- Name: order_line_line_id_seq; Type: SEQUENCE; Schema: pacbook_src; Owner: postgres
--
CREATE SEQUENCE pacbook_src.order_line_line_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE pacbook_src.order_line_line_id_seq OWNER TO postgres;
--
-- Name: order_line_line_id_seq; Type: SEQUENCE OWNED BY; Schema: pacbook_src; Owner: postgres
--
ALTER SEQUENCE pacbook_src.order_line_line_id_seq OWNED BY pacbook_src.order_line.line_id;
--
-- Name: order_status; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.order_status (
    status_id integer NOT NULL,
    status_value character varying(20)
);
--
-- Name: publisher; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.publisher (
    publisher_id integer NOT NULL,
    publisher_name character varying(400)
);
--
-- Name: shipping_method; Type: TABLE; Schema: pacbook_src; Owner: postgres
--
CREATE TABLE pacbook_src.shipping_method (
    method_id integer NOT NULL,
    method_name character varying(100),
    cost numeric(6, 2)
);
--
-- Name: cust_order order_id; Type: DEFAULT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.cust_order
ALTER COLUMN order_id
SET DEFAULT nextval('pacbook_src.cust_order_order_id_seq'::regclass);
--
-- Name: order_history history_id; Type: DEFAULT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_history
ALTER COLUMN history_id
SET DEFAULT nextval('pacbook_src.order_history_history_id_seq'::regclass);
--
-- Name: order_line line_id; Type: DEFAULT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_line
ALTER COLUMN line_id
SET DEFAULT nextval('pacbook_src.order_line_line_id_seq'::regclass);
ALTER TABLE ONLY pacbook_src.address_status
ADD CONSTRAINT pk_addr_status PRIMARY KEY (status_id);
--
-- Name: address pk_address; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.address
ADD CONSTRAINT pk_address PRIMARY KEY (address_id);
--
-- Name: author pk_author; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.author
ADD CONSTRAINT pk_author PRIMARY KEY (author_id);
--
-- Name: book pk_book; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book
ADD CONSTRAINT pk_book PRIMARY KEY (book_id);
--
-- Name: book_author pk_bookauthor; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book_author
ADD CONSTRAINT pk_bookauthor PRIMARY KEY (book_id, author_id);
--
-- Name: country pk_country; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.country
ADD CONSTRAINT pk_country PRIMARY KEY (country_id);
--
-- Name: customer_address pk_custaddr; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.customer_address
ADD CONSTRAINT pk_custaddr PRIMARY KEY (customer_id, address_id);
--
-- Name: customer pk_customer; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.customer
ADD CONSTRAINT pk_customer PRIMARY KEY (customer_id);
--
-- Name: cust_order pk_custorder; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.cust_order
ADD CONSTRAINT pk_custorder PRIMARY KEY (order_id);
--
-- Name: book_language pk_language; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book_language
ADD CONSTRAINT pk_language PRIMARY KEY (language_id);
--
-- Name: order_history pk_orderhist; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_history
ADD CONSTRAINT pk_orderhist PRIMARY KEY (history_id);
--
-- Name: order_line pk_orderline; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_line
ADD CONSTRAINT pk_orderline PRIMARY KEY (line_id);
--
-- Name: order_status pk_orderstatus; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_status
ADD CONSTRAINT pk_orderstatus PRIMARY KEY (status_id);
--
-- Name: publisher pk_publisher; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.publisher
ADD CONSTRAINT pk_publisher PRIMARY KEY (publisher_id);
--
-- Name: shipping_method pk_shipmethod; Type: CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.shipping_method
ADD CONSTRAINT pk_shipmethod PRIMARY KEY (method_id);
--
-- Name: address fk_addr_ctry; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.address
ADD CONSTRAINT fk_addr_ctry FOREIGN KEY (country_id) REFERENCES pacbook_src.country(country_id);
--
-- Name: book_author fk_ba_author; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book_author
ADD CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES pacbook_src.author(author_id);
--
-- Name: book_author fk_ba_book; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book_author
ADD CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES pacbook_src.book(book_id);
--
-- Name: book fk_book_lang; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book
ADD CONSTRAINT fk_book_lang FOREIGN KEY (language_id) REFERENCES pacbook_src.book_language(language_id);
--
-- Name: book fk_book_pub; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.book
ADD CONSTRAINT fk_book_pub FOREIGN KEY (publisher_id) REFERENCES pacbook_src.publisher(publisher_id);
--
-- Name: customer_address fk_ca_addr; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.customer_address
ADD CONSTRAINT fk_ca_addr FOREIGN KEY (address_id) REFERENCES pacbook_src.address(address_id);
--
-- Name: customer_address fk_ca_cust; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.customer_address
ADD CONSTRAINT fk_ca_cust FOREIGN KEY (customer_id) REFERENCES pacbook_src.customer(customer_id);
--
-- Name: order_history fk_oh_order; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_history
ADD CONSTRAINT fk_oh_order FOREIGN KEY (order_id) REFERENCES pacbook_src.cust_order(order_id);
--
-- Name: order_history fk_oh_status; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_history
ADD CONSTRAINT fk_oh_status FOREIGN KEY (status_id) REFERENCES pacbook_src.order_status(status_id);
--
-- Name: order_line fk_ol_book; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_line
ADD CONSTRAINT fk_ol_book FOREIGN KEY (book_id) REFERENCES pacbook_src.book(book_id);
--
-- Name: order_line fk_ol_order; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.order_line
ADD CONSTRAINT fk_ol_order FOREIGN KEY (order_id) REFERENCES pacbook_src.cust_order(order_id);
--
-- Name: cust_order fk_order_addr; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.cust_order
ADD CONSTRAINT fk_order_addr FOREIGN KEY (dest_address_id) REFERENCES pacbook_src.address(address_id);
--
-- Name: cust_order fk_order_cust; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.cust_order
ADD CONSTRAINT fk_order_cust FOREIGN KEY (customer_id) REFERENCES pacbook_src.customer(customer_id);
--
-- Name: cust_order fk_order_ship; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.cust_order
ADD CONSTRAINT fk_order_ship FOREIGN KEY (shipping_method_id) REFERENCES pacbook_src.shipping_method(method_id);
--
-- Name: customer_address fkey_status_add; Type: FK CONSTRAINT; Schema: pacbook_src; Owner: postgres
--
ALTER TABLE ONLY pacbook_src.customer_address
ADD CONSTRAINT fkey_status_add FOREIGN KEY (status_id) REFERENCES pacbook_src.address_status(status_id);