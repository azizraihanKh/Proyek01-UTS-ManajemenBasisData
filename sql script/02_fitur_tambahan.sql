-- Membuat fitur tambahan --

--========================================
-- Fitur 1 : Riwayat perubahan semester --
--========================================

-- membuat tabel riwayat semester
create table SALAM.riwayat_mahasiswas(
	id_riwayat SERIAL primary key,
	nim VARCHAR(15) not null,
	semester_lama int,
	semester_baru int,
	waktu_perubahan TIMESTAMP default CURRENT_TIMESTAMP
);

-- membuat function untuk mencatat perubahan semester
CREATE OR REPLACE FUNCTION salam.catat_perubahan_semester()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.semester IS DISTINCT FROM NEW.semester THEN
        INSERT INTO salam.riwayat_mahasiswas (
            nim,
            semester_lama,
            semester_baru
        )
        VALUES (
            OLD.nim,
            OLD.semester,
            NEW.semester
        );
    END IF;

    RETURN NEW;
END;
$$;

-- membuat trigger untuk menjalankan function
create trigger trg_catat_perubahan_semester
after update on SALAM.mahasiswas
for each row
execute function SALAM.catat_perubahan_semester();

-- -----------------------------------
-- PENGUJIAN FITUR 1: RIWAYAT SEMESTER
-- -----------------------------------

-- mengubah semester mahasiswa dengan nim '123456789' dari 5 menjadi 6
update SALAM.mahasiswas
set semester = 6
where nim = '123456789';

-- memeriksa riwayat perubahan semester
select * from SALAM.riwayat_mahasiswas
order by waktu_perubahan desc;



--===================================
-- Fitur 2 : Skor Kelengkapan Data --
--===================================

-- Membuat view kelengkapan data mahasiswa
create view SALAM.v_kelengkapan_data as
select
	nim, nama, email, semester,
	(
		(case when nullif(trim(nama), ' ') is not null then 1 else 0 end) +
		(case when nullif(trim(email), ' ') is not null then 1 else 0 end) +
		(case when semester is not null then 1 else 0 end)
	) as jumlah_data_terisi,
	round(
		(
			(
				(CASE WHEN NULLIF(TRIM(nama), '') IS NOT NULL THEN 1 ELSE 0 END) +
                (CASE WHEN NULLIF(TRIM(email), '') IS NOT NULL THEN 1 ELSE 0 END) +
                (CASE WHEN semester IS NOT NULL THEN 1 ELSE 0 END)
			) * 100.0 / 3
		) :: numeric,
		2
	) as persentase_kelengkapan
from SALAM.mahasiswas;

-- ----------------------------------------
-- PENGUJIAN FITUR 2: Skor Kelengkapan Data
-- ----------------------------------------

select *
from SALAM.v_kelengkapan_data
order by persentase_kelengkapan asc;