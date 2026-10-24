--------------------------------
-- Pembuatan schema dan tabel --
--------------------------------
create schema SALAM;

CREATE TABLE SALAM.mahasiswas (
    nim VARCHAR(15) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    semester INT CHECK (semester BETWEEN 1 AND 14)
);

INSERT INTO SALAM.mahasiswas (nim, nama, email, semester)
VALUES
    ('123456789', 'Andi', 'andi@example.com', 5),
    ('123456790', 'Budi', 'budi@example.com', 5);

--------------------
-- uji constraint --
--------------------

-- uji primary key (insert data dengan nim yang sama)
INSERT INTO SALAM.mahasiswas (nim, nama, email, semester)
VALUES ('123456789', 'Citra', 'citra@example.com', 5);

-- uji unique (insert data dengan email yang sama)
INSERT INTO SALAM.mahasiswas (nim, nama, email, semester)
VALUES ('123456791', 'Citra', 'andi@example.com', 5);

-- uji check (insert data dengan nilai semester diluar rentang)
INSERT INTO SALAM.mahasiswas (nim, nama, email, semester)
VALUES ('123456792', 'Dedi', 'dedi@example.com', 20);