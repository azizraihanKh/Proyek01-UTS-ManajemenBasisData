--===========================
-- Pembuatan User Database --
--===========================

create user backend_dev with password 'backend123';
create user bi_dev with password 'bi123';
create user data_engineer with password 'engineer123';

------------------------
-- Mengatur Hak Akses --
------------------------

-- User backend_dev (CRUD semua tabel)
grant usage on schema SALAM to backend_dev;

grant select, insert, update, delete
on all tables in schema SALAM
to backend_dev;

GRANT USAGE, SELECT
ON SEQUENCE salam.riwayat_mahasiswas_id_riwayat_seq
TO backend_dev;

-- User bi_dev (Only Read)
grant usage on schema SALAM to bi_dev;

grant select on all tables in schema SALAM
to bi_dev;

-- User data_engineer
grant usage, create on schema SALAM to data_engineer;

grant select, insert, update, delete
on all tables in schema SALAM
to data_engineer;

GRANT USAGE, SELECT
ON SEQUENCE salam.riwayat_mahasiswas_id_riwayat_seq
TO data_engineer;


-- pemindahan kepemilikan objek ke data_engineer
alter schema SALAM owner to data_engineer;
alter table SALAM.mahasiswas owner to data_engineer;
alter table SALAM.riwayat_mahasiswas owner to data_engineer;
alter view SALAM.v_kelengkapan_data owner to data_engineer;
alter function SALAM.catat_perubahan_semester() owner to data_engineer;



-- ========================
-- PENGUJIAN HAK AKSES USER
-- ========================

-- Pengujian backend_dev
-- Uji SELECT (seharusnya berhasil)
SELECT *
FROM salam.mahasiswas;

-- Uji INSERT (seharusnya berhasil)
INSERT INTO salam.mahasiswas
    (nim, nama, email, semester)
VALUES
    ('999000001', 'Uji Backend', 'backend_uji@example.com', 5);

-- Uji UPDATE (seharusnya berhasil)
UPDATE salam.mahasiswas
SET nama = 'Uji Backend Diubah'
WHERE nim = '999000001';

-- Uji DELETE (seharusnya berhasil)
DELETE FROM salam.mahasiswas
WHERE nim = '999000001';

--======================================
-- Pengujian bi_dev
-- Uji SELECT (seharusnya berhasil)
SELECT * FROM salam.mahasiswas;

SELECT * FROM salam.v_kelengkapan_data;

-- Uji INSERT (seharusnya ditolak)
INSERT INTO salam.mahasiswas
    (nim, nama, email, semester)
VALUES
    ('999000002', 'Uji BI', 'bi_uji@example.com', 5);


--======================== 
-- Pengujian data_engineer
-- Uji CREATE, ALTER, CRUD, dan DROP
-- Contoh objek uji yang sebelumnya digunakan
CREATE TABLE salam.uji_objek_engineer (
    id INT PRIMARY KEY,
    keterangan VARCHAR(100)
);

ALTER TABLE salam.uji_objek_engineer
ADD COLUMN dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

INSERT INTO salam.uji_objek_engineer (id, keterangan)
VALUES (1, 'Uji data engineer');

SELECT *
FROM salam.uji_objek_engineer;

UPDATE salam.uji_objek_engineer
SET keterangan = 'Data berhasil diubah'
WHERE id = 1;

DELETE FROM salam.uji_objek_engineer
WHERE id = 1;

DROP TABLE salam.uji_objek_engineer;
