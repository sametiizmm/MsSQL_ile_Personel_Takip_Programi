-- Veritaban� olu�turma
CREATE DATABASE SametCakmak1;
GO

-- Veritaban� kullanma
USE SametCakmak1;
GO

-- Personeller Tablosu Olu�turma
CREATE TABLE tbl_Personeller (
    Pers_ID int IDENTITY(1,1) NOT NULL,
    Pers_Adi nvarchar(10),
    Pers_Soyadi nvarchar(15),
    Pers_DTarihi smalldatetime,
    Pers_Isim AS (Pers_Adi + ' ' + Pers_Soyadi), -- Hesaplama s�tunu
    Pers_Giris_Tarihi smalldatetime,
    Pers_Cikis_Tarihi smalldatetime NULL,
    Pers_Adresi nvarchar(100),
    Pers_Ilcesi nvarchar(20),
    Pers_Ili nvarchar(15),
    Pers_Il_Kodu int,
    Pers_Tel char(10),
    Pers_Cep char(10),
    Pers_Email varchar(50),
    Bolum_ID int,
    Cinsiyet_ID int,
    Unvan_ID int,
    Pers_Maas money,
    Pers_Komisyon_Yuzdesi float,
    Pers_Foto image,
    Pers_SGK_No char(20),
    Pers_TC_No char(11),
    Pers_CV nvarchar(max), 
    Pers_CV_File nvarchar(max), -- PDF dosyas�n�n base64 kodunu i�erecek alan
    Pers_CV_Web nvarchar(max), 
    Pers_Aktif_Mi bit,
    Kaydeden nvarchar(20), 
    Kayit_Tarihi datetime,
    Son_Kaydeden nvarchar(20),
    Son_Kayit_Tarihi datetime,
    CONSTRAINT PK_tbl_Personeller_Pers_ID PRIMARY KEY CLUSTERED (Pers_ID ASC)
);

-- Maa�lar Tablosu Olu�turma
CREATE TABLE tbl_Maaslar (
    Maas_ID int IDENTITY(1,1) NOT NULL,
    Pers_ID int,
    Maas_Tarihi smalldatetime,
    Maas_Komisyonu money,
    Maas_Toplam AS (Maas_Komisyonu + 5000), -- �rnek bir sabit de�erle hesaplama s�tunu
    Ay_ID int,
    Maas_Yili AS (YEAR(Maas_Tarihi)), -- Maas_Tarihi'nden y�l bilgisini alarak hesaplama yap�l�yor
    CONSTRAINT PK_tbl_Maaslar_Maas_ID PRIMARY KEY CLUSTERED (Maas_ID ASC)
);

-- B�l�mler Tablosu Olu�turma
CREATE TABLE tbl_Bolumler (
    Bolum_ID int IDENTITY(1,1) NOT NULL,
    Bolum_Adi nvarchar(50),
    Bolum_Tel char(10),
    Yonetici_ID int,
    CONSTRAINT PK_tbl_Bolumler_Bolum_ID PRIMARY KEY CLUSTERED (Bolum_ID ASC)
);

-- Kullan�c�lar Tablosu Olu�turma
CREATE TABLE tbl_Kullanicilar (
    Kullanici_ID int IDENTITY(1,1) NOT NULL,
    Kullanici_Adi nvarchar(50),
    Kullanici_Sifre nvarchar(50),
    Yetki_ID int,
    CONSTRAINT PK_tbl_Kullanicilar_Kullanici_ID PRIMARY KEY CLUSTERED (Kullanici_ID ASC)
);

-- Kategoriler Tablosu Olu�turma
CREATE TABLE tbl_Kategoriler (
    K_ID int IDENTITY(1,1) NOT NULL,
    Cinsiyet nvarchar(20),
    Unvan nvarchar(50),
    Ilce_Adi nvarchar(50),
    Il_Adi nvarchar(50),
    Ulke nvarchar(50),
    Ay_Adi nvarchar(50),
    Kitap_Turu nvarchar(50),
    Yetki_Turu nvarchar(50),
    CONSTRAINT PK_tbl_Kategoriler_K_ID PRIMARY KEY CLUSTERED (K_ID ASC)
);

-- �li�kileri kurmak i�in FOREIGN KEY ekleme

-- tbl_Maaslar tablosuna FOREIGN KEY ekleme
ALTER TABLE tbl_Maaslar
ADD CONSTRAINT FK_tbl_Maaslar_Personeller FOREIGN KEY (Pers_ID) REFERENCES tbl_Personeller(Pers_ID);

-- tbl_Bolumler tablosuna FOREIGN KEY ekleme
ALTER TABLE tbl_Bolumler
ADD CONSTRAINT FK_tbl_Bolumler_Yonetici FOREIGN KEY (Yonetici_ID) REFERENCES tbl_Personeller(Pers_ID);

-- tbl_Kullanicilar tablosuna FOREIGN KEY ekleme ve g�ncelleme

-- �lk olarak yanl�� FOREIGN KEY k�s�tlamas�n� ekleme
ALTER TABLE tbl_Kullanicilar
ADD CONSTRAINT FK_tbl_Kullanicilar_Kategoriler FOREIGN KEY (Kullanici_ID) REFERENCES tbl_Kategoriler(K_ID);

-- Yanl�� FOREIGN KEY k�s�tlamas�n� kald�rma
ALTER TABLE tbl_Kullanicilar
DROP CONSTRAINT FK_tbl_Kullanicilar_Kategoriler;

-- Do�ru FOREIGN KEY k�s�tlamas�n� ekleme
ALTER TABLE tbl_Kullanicilar
ADD CONSTRAINT FK_tbl_Kullanicilar_Kategoriler FOREIGN KEY (Yetki_ID) REFERENCES tbl_Kategoriler(K_ID);

-- tbl_Personeller tablosuna FOREIGN KEY ekleme ve do�rulama

-- FOREIGN KEY k�s�tlamas�n� ekleme
ALTER TABLE [dbo].[tbl_Personeller] WITH CHECK ADD CONSTRAINT [FK_tbl_Personeller_tbl_Kategoriler] FOREIGN KEY([Unvan_ID])
REFERENCES [dbo].[tbl_Kategoriler] ([K_ID])
GO

-- FOREIGN KEY k�s�tlamas�n� do�rulama
ALTER TABLE [dbo].[tbl_Personeller] CHECK CONSTRAINT [FK_tbl_Personeller_tbl_Kategoriler]
GO

-- Veri giri�i
-- Kategoriler tablosuna veri ekleme
INSERT INTO tbl_Kategoriler (Cinsiyet, Unvan, Ilce_Adi, Il_Adi, Ulke, Ay_Adi, Kitap_Turu, Yetki_Turu)
VALUES 
('Erkek', 'VT Y�neticisi', '�stanbul', 'Kad�k�y', 'T�rkiye', 'Ocak', 'Bilim', 'Y�netici'),
('Erkek', 'Sat�� Eleman�', 'Ankara', '�ankaya', 'T�rkiye', '�ubat', 'Roman', 'Personel'),
('Kad�n', 'Pazarlamac�', '�zmir', 'Bornova', 'T�rkiye', 'Mart', 'Bilim-Kurgu', 'Personel'),
('Kad�n', 'Ofis Y�neticisi', 'Bursa', 'Osmangazi', 'T�rkiye', 'Nisan', 'Tarih', 'Y�netici'),
('Erkek', 'CIO', 'Antalya', 'Muratpa�a', 'T�rkiye', 'May�s', 'Kurgu', 'Y�netici'),
('Erkek', 'CEO', 'Adana', 'Seyhan', 'T�rkiye', 'Haziran', 'Drama', 'Y�netici');

-- tbl_Personeller tablosuna veri ekleme
INSERT INTO tbl_Personeller (Pers_Adi, Pers_Soyadi, Pers_DTarihi, Pers_Giris_Tarihi, Pers_Adresi, Pers_Ilcesi, Pers_Ili, Pers_Il_Kodu, Pers_Tel, Pers_Cep, Pers_Email, Bolum_ID, Cinsiyet_ID, Unvan_ID, Pers_Maas, Pers_Komisyon_Yuzdesi, Pers_SGK_No, Pers_TC_No, Pers_Aktif_Mi, Kaydeden, Kayit_Tarihi, Son_Kaydeden, Son_Kayit_Tarihi)
VALUES 
('Ali', 'Y�lmaz', '1980-05-10', '2024-05-10', '�rnek Adres', '�rnek �l�e', '�rnek �l', 12345, '1234567890', '9876543210', 'ali@example.com', 1, 1, 1, 5000, 0.1, '1234567890', '12345678901', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Ay�e', 'Kaya', '1992-08-20', '2023-09-15', 'Ba�ka Adres', 'Ba�ka �l�e', 'Ba�ka �l', 54321, '0987654321', '6789054321', 'ayse@example.com', 2, 2, 2, 6000, 0.15, '9876543210', '10987654321', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Mehmet', '�elik', '1985-02-11', '2023-03-01', 'Adres 1', '�l�e 1', '�l 1', 11111, '1111111111', '1111222222', 'mehmet@example.com', 1, 1, 2, 5500, 0.12, '1111222233', '11112233444', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Fatma', 'Demir', '1988-06-14', '2022-07-20', 'Adres 2', '�l�e 2', '�l 2', 22222, '2222222222', '2222333333', 'fatma@example.com', 2, 2, 1, 7000, 0.18, '2222333344', '22223344555', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Ahmet', 'Y�ld�z', '1990-09-21', '2021-12-05', 'Adres 3', '�l�e 3', '�l 3', 33333, '3333333333', '3333444444', 'ahmet@example.com', 3, 1, 3, 6200, 0.14, '3333444455', '33334455666', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Elif', 'Kara', '1982-11-30', '2020-01-15', 'Adres 4', '�l�e 4', '�l 4', 44444, '4444444444', '4444555555', 'elif@example.com', 4, 2, 2, 4800, 0.1, '4444555566', '44445566777', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Murat', 'Arslan', '1987-03-05', '2023-04-20', 'Adres 5', '�l�e 5', '�l 5', 55555, '5555555555', '5555666666', 'murat@example.com', 5, 1, 1, 7500, 0.2, '5555666677', '55556677888', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Zeynep', '�ahin', '1989-07-22', '2022-08-10', 'Adres 6', '�l�e 6', '�l 6', 66666, '6666666666', '6666777777', 'zeynep@example.com', 6, 2, 3, 5300, 0.13, '6666777788', '66667788999', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Hakan', 'Ko�', '1983-10-16', '2021-11-25', 'Adres 7', '�l�e 7', '�l 7', 77777, '7777777777', '7777888888', 'hakan@example.com', 7, 1, 2, 6700, 0.16, '7777888899', '77778899000', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Seda', 'Ayd�n', '1991-12-01', '2023-02-15', 'Adres 8', '�l�e 8', '�l 8', 88888, '8888888888', '8888999999', 'seda@example.com', 8, 2, 1, 5800, 0.12, '8888999900', '88889900111', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Osman', 'Er', '1984-01-10', '2020-03-30', 'Adres 9', '�l�e 9', '�l 9', 99999, '9999999999', '9999000000', 'osman@example.com', 9, 1, 3, 6900, 0.17, '9999000011', '99990011222', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Esra', 'Demirci', '1986-04-15', '2019-06-20', 'Adres 10', '�l�e 10', '�l 10', 10101, '1010101010', '1010111111', 'esra@example.com', 10, 2, 2, 6100, 0.15, '1010111122', '10101122333', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Kemal', 'Uzun', '1993-05-25', '2024-06-30', 'Adres 11', '�l�e 11', '�l 11', 11111, '1111111111', '1111222222', 'kemal@example.com', 1, 1, 1, 7000, 0.2, '1111222233', '11112233444', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Nur', 'Alt�n', '1994-07-18', '2023-08-05', 'Adres 12', '�l�e 12', '�l 12', 12121, '1212121212', '1212131313', 'nur@example.com', 2, 2, 2, 6500, 0.18, '1212131323', '12121324455', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Ali', 'G�ne�', '1995-09-11', '2022-09-20', 'Adres 13', '�l�e 13', '�l 13', 13131, '1313131313', '1313141414', 'ali@example.com', 3, 1, 3, 6000, 0.16, '1313141424', '13131435566', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Sevil', 'Y�ld�r�m', '1981-11-22', '2021-10-30', 'Adres 14', '�l�e 14', '�l 14', 14141, '1414141414', '1414151515', 'sevil@example.com', 4, 2, 1, 7200, 0.22, '1414151525', '14141546677', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Emre', 'Y�lmaz', '1980-12-13', '2020-12-10', 'Adres 15', '�l�e 15', '�l 15', 15151, '1515151515', '1515161616', 'emre@example.com', 5, 1, 2, 5400, 0.1, '1515161626', '15151657788', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Derya', 'K�l��', '1983-02-17', '2019-01-25', 'Adres 16', '�l�e 16', '�l 16', 16161, '1616161616', '1616171717', 'derya@example.com', 6, 2, 3, 5900, 0.14, '1616171727', '16161768899', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Can', 'Bayram', '1985-04-28', '2018-05-15', 'Adres 17', '�l�e 17', '�l 17', 17171, '1717171717', '1717181818', 'can@example.com', 7, 1, 1, 6800, 0.19, '1717181828', '17171879900', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Sibel', '�elik', '1986-06-06', '2017-07-05', 'Adres 18', '�l�e 18', '�l 18', 18181, '1818181818', '1818191919', 'sibel@example.com', 8, 2, 2, 7200, 0.21, '1818191929', '18181990011', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Onur', 'Durmaz', '1987-08-14', '2016-09-25', 'Adres 19', '�l�e 19', '�l 19', 19191, '1919191919', '1919202020', 'onur@example.com', 9, 1, 3, 6400, 0.17, '1919202030', '19192001122', 1, 'admin', GETDATE(), 'admin', GETDATE()),
('Buse', 'Kar', '1988-10-23', '2015-11-15', 'Adres 20', '�l�e 20', '�l 20', 20202, '2020202020', '2020212121', 'buse@example.com', 10, 2, 1, 5000, 0.1, '2020212131', '20202112233', 1, 'admin', GETDATE(), 'admin', GETDATE());

-- tbl_Bolumler tablosuna veri ekleme
INSERT INTO tbl_Bolumler (Bolum_Adi, Bolum_Tel, Yonetici_ID)
VALUES 
('Bili�im Sistemleri', '2124440001', 1),
('Pazarlama', '2124440002', 2),
('Sat��', '2124440003', 3),
('Muhasebe', '2124440004', 4),
('Finans', '2124440005', 5),
('Y�netim', '2124440006', 6);

-- tbl_Maaslar tablosuna veri ekleme
INSERT INTO tbl_Maaslar (Pers_ID, Maas_Tarihi, Maas_Komisyonu, Ay_ID)
VALUES 
(1, '2024-01-01', 500, 1),
(1, '2024-02-01', 450, 2),
(2, '2024-01-01', 600, 1),
(2, '2024-02-01', 650, 2),
(3, '2024-01-01', 550, 1),
(3, '2024-02-01', 500, 2),
(4, '2024-01-01', 700, 1),
(4, '2024-02-01', 750, 2),
(5, '2024-01-01', 620, 1),
(5, '2024-02-01', 640, 2),
(6, '2024-01-01', 480, 1),
(6, '2024-02-01', 490, 2),
(7, '2024-01-01', 750, 1),
(7, '2024-02-01', 770, 2),
(8, '2024-01-01', 530, 1),
(8, '2024-02-01', 540, 2),
(9, '2024-01-01', 670, 1),
(9, '2024-02-01', 680, 2),
(10, '2024-01-01', 580, 1),
(10, '2024-02-01', 590, 2),
(11, '2024-01-01', 690, 1),
(11, '2024-02-01', 700, 2),
(12, '2024-01-01', 610, 1),
(12, '2024-02-01', 620, 2),
(13, '2024-01-01', 700, 1),
(13, '2024-02-01', 710, 2),
(14, '2024-01-01', 650, 1),
(14, '2024-02-01', 660, 2),
(15, '2024-01-01', 600, 1),
(15, '2024-02-01', 610, 2),
(16, '2024-01-01', 720, 1),
(16, '2024-02-01', 730, 2),
(17, '2024-01-01', 540, 1),
(17, '2024-02-01', 550, 2),
(18, '2024-01-01', 590, 1),
(18, '2024-02-01', 600, 2),
(19, '2024-01-01', 680, 1),
(19, '2024-02-01', 690, 2),
(20, '2024-01-01', 500, 1),
(20, '2024-02-01', 510, 2);

-- tbl_Kullanicilar tablosuna veri ekleme
INSERT INTO tbl_Kullanicilar (Kullanici_Adi, Kullanici_Sifre, Yetki_ID)
VALUES 
('admin', 'admin123', 1),
('user', 'user123', 2);

-- Veri g�r�nt�leme
SELECT * FROM tbl_Personeller;
SELECT * FROM tbl_Bolumler;
SELECT * FROM tbl_Maaslar;
SELECT * FROM tbl_Kullanicilar;
SELECT * FROM tbl_Kategoriler;

GO