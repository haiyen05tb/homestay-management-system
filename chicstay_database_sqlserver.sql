-- ====================================================================
-- CHICSTAY HOMESTAY MANAGEMENT SYSTEM - MICROSOFT SQL SERVER (T-SQL)
-- Seed giao dich neo theo moc: 21/10/2026 13:42 (UTC+7).
-- DONDATPHONG / PHIEUTHANHTOAN / CHITIETDICHVU / HOADON duoc sinh lai cho khop nghiep vu.
-- Tuong thich: Microsoft SQL Server 2017+, Azure SQL, SQL Server Management Studio (SSMS)
-- ====================================================================

SET NOCOUNT ON;
IF DB_ID(N'CHICSTAY') IS NULL
BEGIN
    CREATE DATABASE CHICSTAY;
END;
GO

USE CHICSTAY;
GO

-- ------------------------------------------------------------
-- XOA CAC BANG THEO DUNG THU TU RANG BUOC KHOA NGOAI
-- ------------------------------------------------------------
IF OBJECT_ID(N'dbo.HOADON', N'U') IS NOT NULL DROP TABLE dbo.HOADON;
IF OBJECT_ID(N'dbo.CHITIETDICHVU', N'U') IS NOT NULL DROP TABLE dbo.CHITIETDICHVU;
IF OBJECT_ID(N'dbo.PHIEUTHANHTOAN', N'U') IS NOT NULL DROP TABLE dbo.PHIEUTHANHTOAN;
IF OBJECT_ID(N'dbo.DONDATPHONG', N'U') IS NOT NULL DROP TABLE dbo.DONDATPHONG;
IF OBJECT_ID(N'dbo.DICHVU', N'U') IS NOT NULL DROP TABLE dbo.DICHVU;
IF OBJECT_ID(N'dbo.KHACHHANG', N'U') IS NOT NULL DROP TABLE dbo.KHACHHANG;
IF OBJECT_ID(N'dbo.NGUOIDUNG', N'U') IS NOT NULL DROP TABLE dbo.NGUOIDUNG;
IF OBJECT_ID(N'dbo.PHONG', N'U') IS NOT NULL DROP TABLE dbo.PHONG;
GO

CREATE TABLE dbo.PHONG (
  MaPhong VARCHAR(10) NOT NULL,
  TenPhong NVARCHAR(100) NOT NULL,
  LoaiPhong NVARCHAR(50) NOT NULL,
  GiaPhong DECIMAL(18,0) NOT NULL,
  SucChua INT NOT NULL,
  TrangThaiPhong NVARCHAR(50) NOT NULL CONSTRAINT DF_PHONG_TrangThai DEFAULT N'Sẵn sàng',
  MoTa NVARCHAR(500) NULL,
  CONSTRAINT PK_PHONG PRIMARY KEY CLUSTERED (MaPhong)
);
GO

CREATE TABLE dbo.NGUOIDUNG (
  MaND VARCHAR(10) NOT NULL,
  HoTen NVARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  VaiTro NVARCHAR(50) NOT NULL,
  MatKhau VARCHAR(255) NOT NULL,
  CONSTRAINT PK_NGUOIDUNG PRIMARY KEY CLUSTERED (MaND)
);
GO

CREATE TABLE dbo.KHACHHANG (
  MaKH VARCHAR(10) NOT NULL,
  HoTen NVARCHAR(100) NOT NULL,
  SoDienThoai VARCHAR(15) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  CCCD VARCHAR(20) NOT NULL,
  DiaChi NVARCHAR(255) NOT NULL,
  GhiChu NVARCHAR(500) NULL,
  CONSTRAINT PK_KHACHHANG PRIMARY KEY CLUSTERED (MaKH),
  CONSTRAINT CHK_KH_HoTen CHECK (LEN(HoTen) > 0 AND HoTen = LTRIM(RTRIM(HoTen))),
  CONSTRAINT CHK_KH_SoDienThoai CHECK (SoDienThoai LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT CHK_KH_Email CHECK (Email LIKE '_%@_%._%' AND Email NOT LIKE '% %'),
  CONSTRAINT CHK_KH_CCCD CHECK (LEN(CCCD) = 12 AND CCCD NOT LIKE '%[^0-9]%'),
  CONSTRAINT CHK_KH_DiaChi CHECK (LEN(LTRIM(RTRIM(DiaChi))) > 0)
);
GO
CREATE UNIQUE NONCLUSTERED INDEX UQ_KHACHHANG_CCCD ON dbo.KHACHHANG (CCCD);
GO

CREATE TABLE dbo.DICHVU (
  MaDV VARCHAR(10) NOT NULL,
  TenDichVu NVARCHAR(100) NOT NULL,
  NhomDichVu NVARCHAR(50) NOT NULL,
  DonViTinh NVARCHAR(20) NOT NULL,
  DonGia DECIMAL(18,0) NOT NULL,
  ThoiDiemApDung NVARCHAR(20) NOT NULL,
  TrangThai NVARCHAR(30) NOT NULL CONSTRAINT DF_DICHVU_TrangThai DEFAULT N'Đang hoạt động',
  CONSTRAINT PK_DICHVU PRIMARY KEY CLUSTERED (MaDV)
);
GO

CREATE TABLE dbo.DONDATPHONG (
  MaDon VARCHAR(15) NOT NULL,
  MaND VARCHAR(10) NOT NULL,
  MaKH VARCHAR(10) NOT NULL,
  MaPhong VARCHAR(10) NOT NULL,
  NgayNhanPhong DATE NOT NULL,
  NgayTraPhong DATE NOT NULL,
  SoKhach INT NOT NULL,
  SoDem INT NOT NULL,
  TienPhong DECIMAL(18,0) NOT NULL,
  TienCocYeuCau DECIMAL(18,0) NOT NULL,
  TienDichVu DECIMAL(18,0) NOT NULL CONSTRAINT DF_DONDATPHONG_TienDichVu DEFAULT 0,
  TongTien DECIMAL(18,0) NOT NULL,
  DaThu DECIMAL(18,0) NOT NULL CONSTRAINT DF_DONDATPHONG_DaThu DEFAULT 0,
  ConLai DECIMAL(18,0) NOT NULL CONSTRAINT DF_DONDATPHONG_ConLai DEFAULT 0,
  TrangThaiDon NVARCHAR(30) NOT NULL,
  ThoiGianTaoDon DATETIME NOT NULL,
  ThoiGianCheckInThucTe DATETIME NULL,
  ThoiGianCheckOutThucTe DATETIME NULL,
  YeuCauDacBiet NVARCHAR(500) NULL,
  CONSTRAINT PK_DONDATPHONG PRIMARY KEY CLUSTERED (MaDon),
  CONSTRAINT FK_Don_NguoiDung FOREIGN KEY (MaND) REFERENCES dbo.NGUOIDUNG (MaND),
  CONSTRAINT FK_Don_KhachHang FOREIGN KEY (MaKH) REFERENCES dbo.KHACHHANG (MaKH),
  CONSTRAINT FK_Don_Phong FOREIGN KEY (MaPhong) REFERENCES dbo.PHONG (MaPhong)
);
GO

CREATE TABLE dbo.PHIEUTHANHTOAN (
  MaPhieu VARCHAR(15) NOT NULL,
  MaDon VARCHAR(15) NOT NULL,
  LoaiPhieu NVARCHAR(20) NOT NULL,
  SoTien DECIMAL(18,0) NOT NULL,
  PhuongThuc NVARCHAR(20) NOT NULL,
  MaGiaoDichNganHang VARCHAR(50) NULL,
  TrangThaiThanhToan NVARCHAR(30) NOT NULL,
  NgayLap DATETIME NOT NULL,
  NguoiLap VARCHAR(10) NOT NULL,
  GhiChu NVARCHAR(255) NULL,
  CONSTRAINT PK_PHIEUTHANHTOAN PRIMARY KEY CLUSTERED (MaPhieu),
  CONSTRAINT FK_Phieu_Don FOREIGN KEY (MaDon) REFERENCES dbo.DONDATPHONG (MaDon),
  CONSTRAINT FK_Phieu_NguoiDung FOREIGN KEY (NguoiLap) REFERENCES dbo.NGUOIDUNG (MaND)
);
GO

CREATE TABLE dbo.CHITIETDICHVU (
  MaChiTiet VARCHAR(15) NOT NULL,
  MaDon VARCHAR(15) NOT NULL,
  MaDV VARCHAR(10) NOT NULL,
  SoLuong INT NOT NULL,
  DonGiaTaiThoiDiem DECIMAL(18,0) NOT NULL,
  ThanhTien DECIMAL(18,0) NOT NULL,
  GiaiDoan NVARCHAR(20) NOT NULL CONSTRAINT DF_CHITIETDICHVU_GiaiDoan DEFAULT N'In-house',
  ThoiDiemThem DATETIME NOT NULL,
  GhiChu NVARCHAR(255) NULL,
  CONSTRAINT PK_CHITIETDICHVU PRIMARY KEY CLUSTERED (MaChiTiet),
  CONSTRAINT FK_CTDV_Don FOREIGN KEY (MaDon) REFERENCES dbo.DONDATPHONG (MaDon),
  CONSTRAINT FK_CTDV_DichVu FOREIGN KEY (MaDV) REFERENCES dbo.DICHVU (MaDV)
);
GO

CREATE TABLE dbo.HOADON (
  MaHoaDon VARCHAR(15) NOT NULL,
  MaDon VARCHAR(15) NOT NULL,
  TienPhong DECIMAL(18,0) NOT NULL,
  TienDichVu DECIMAL(18,0) NOT NULL CONSTRAINT DF_HOADON_TienDichVu DEFAULT 0,
  TienCocDaTra DECIMAL(18,0) NOT NULL,
  TienThanhToanKhiCheckOut DECIMAL(18,0) NOT NULL,
  TongTienDaThanhToan DECIMAL(18,0) NOT NULL,
  PhuongThuc NVARCHAR(20) NOT NULL,
  NgayXuat DATETIME NOT NULL,
  NguoiXuat VARCHAR(10) NOT NULL,
  GhiChu NVARCHAR(255) NULL,
  CONSTRAINT PK_HOADON PRIMARY KEY CLUSTERED (MaHoaDon),
  CONSTRAINT UK_HoaDon_Don UNIQUE (MaDon),
  CONSTRAINT FK_HoaDon_Don FOREIGN KEY (MaDon) REFERENCES dbo.DONDATPHONG (MaDon),
  CONSTRAINT FK_HoaDon_NguoiDung FOREIGN KEY (NguoiXuat) REFERENCES dbo.NGUOIDUNG (MaND)
);
GO
-- ============================
-- 1. INSERT: dbo.PHONG (12)
-- ============================

INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P101', N'Phòng 101', N'Standard', 450000, 2, N'Sẵn sàng', N'Phòng Standard tầng 1, phù hợp cặp đôi / công tác');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P102', N'Phòng 102', N'Standard', 450000, 2, N'Sẵn sàng', N'Phòng Standard tầng 1, gần sảnh');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P103', N'Phòng 103', N'Standard', 480000, 2, N'Sẵn sàng', N'Phòng Standard có cửa sổ lớn');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P104', N'Phòng 104', N'Standard', 480000, 2, N'Sẵn sàng', N'Phòng Standard yên tĩnh');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P201', N'Phòng 201', N'Deluxe', 650000, 2, N'Sẵn sàng', N'Phòng Deluxe có ban công, view đẹp');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P202', N'Phòng 202', N'Deluxe', 650000, 2, N'Sẵn sàng', N'Phòng Deluxe tầng 2');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P203', N'Phòng 203', N'Deluxe', 680000, 2, N'Sẵn sàng', N'Phòng Deluxe tầng cao, yên tĩnh');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P204', N'Phòng 204', N'Deluxe', 700000, 2, N'Sẵn sàng', N'Phòng Deluxe góc, view toàn cảnh');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P301', N'Phòng 301', N'Family', 850000, 4, N'Sẵn sàng', N'Phòng Family 2 giường, phù hợp gia đình');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P302', N'Phòng 302', N'Family', 880000, 4, N'Sẵn sàng', N'Phòng Family rộng, có ghế sofa');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P303', N'Phòng 303', N'Family', 900000, 4, N'Sẵn sàng', N'Phòng Family tầng cao, view đẹp');
INSERT INTO dbo.PHONG (MaPhong, TenPhong, LoaiPhong, GiaPhong, SucChua, TrangThaiPhong, MoTa) VALUES (N'P401', N'Bungalow 01', N'Bungalow', 950000, 3, N'Sẵn sàng', N'Bungalow riêng biệt, có sân BBQ, không gian riêng');
GO
-- ============================
-- 2. INSERT: dbo.NGUOIDUNG (1)
-- ============================

INSERT INTO dbo.NGUOIDUNG (MaND, HoTen, Email, VaiTro, MatKhau) VALUES (N'ND001', N'Nguyễn Minh Châu', 'minh.quanly@chicstay.com', N'Quản lý', '1234567');
GO
-- ============================
-- 3. INSERT: dbo.KHACHHANG (45)
-- ============================

INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH001', N'Bùi Thị An', '0946913810', 'bui.thi.an18@gmail.com', '034832269481', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH002', N'Đặng Quốc Bình', '0913999315', 'dang.binh@gmail.com', '034050052120', N'Quảng Ninh', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH003', N'Võ Thanh Hương', '0966306997', 'vo.thanh.huong76@gmail.com', '034253050256', N'Hà Nội', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH004', N'Hồ Minh Tâm', '0955667651', 'ho.minh.tam28@gmail.com', '034629821539', N'Nha Trang', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH005', N'Trần Quốc Dũng', '0958181396', 'tran.quoc.dung78@gmail.com', '034899371430', N'Hà Nội', N'Khách quen');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH006', N'Vũ Thị Hồng Dũng', '0960806024', 'vu.hongdung@gmail.com', '034304820142', N'Nha Trang', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH007', N'Phạm Thị Bình', '0998753260', 'pham.thi.binh38@gmail.com', '034130840140', N'Hải Phòng', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH008', N'Trần Quốc Nam', '0970855700', 'tran.quoc.nam47@gmail.com', '034425519849', N'Nha Trang', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH009', N'Bùi Hữu Cường', '0991756179', 'bui.huu.cuong69@gmail.com', '034419548116', N'Đà Nẵng', N'Yêu cầu giường đôi');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH010', N'Phan Hữu Hương', '0939476249', 'phan.huu.huong99@gmail.com', '034462436409', N'Hải Phòng', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH011', N'Nguyễn Đức Sơn', '0945935572', 'nguyen.ducson@gmail.com', '034680801999', N'Hải Phòng', N'Khách quen');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH012', N'Vũ Quốc Uyên', '0929175900', 'vu.quoc.uyen32@gmail.com', '034380026649', N'Đà Lạt', N'Có trẻ nhỏ');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH013', N'Đỗ Thị Lan Tâm', '0988320463', 'do.thi.lan.tam29@gmail.com', '034939878788', N'Vũng Tàu', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH014', N'Hồ Văn Dũng', '0930514014', 'ho.van.dung88@gmail.com', '034648192232', N'TP. Hồ Chí Minh', N'Yêu cầu giường đôi');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH015', N'Phan Thị Lan Uyên', '0981016525', 'phan.thi.lan.uyen71@gmail.com', '034373620112', N'TP. Hồ Chí Minh', N'Khách quen');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH016', N'Dương Thị Hồng Nam', '0996028436', 'duong.thi.hong.nam38@gmail.com', '034665994394', N'Vũng Tàu', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH017', N'Đỗ Hữu Yến', '0933978249', 'do.huu.yen14@gmail.com', '034933616150', N'Cần Thơ', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH018', N'Bùi Thị Hồng Trang', '0936697396', 'bui.hongtrang@gmail.com', '034368618081', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH019', N'Dương Thị Hồng An', '0990388981', 'duong.thi.hong.an3@gmail.com', '034472520493', N'Hải Phòng', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH020', N'Phạm Thị Lan Cường', '0921496211', 'pham.thi.lan.cuong9@gmail.com', '034424066816', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH021', N'Lê Minh Vân', '0983793389', 'le.minhvan@gmail.com', '034461768998', N'Hải Phòng', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH022', N'Hồ Thanh Oanh', '0963551839', 'ho.thanh.oanh84@gmail.com', '034640166001', N'Đà Lạt', N'Yêu cầu giường đôi');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH023', N'Trần Thanh Mai', '0918593410', 'tran.thanh.mai76@gmail.com', '034487177987', N'Quảng Ninh', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH024', N'Nguyễn Thị Bình', '0940728046', 'nguyen.thibinh@gmail.com', '034728590908', N'Đà Lạt', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH025', N'Hoàng Anh Lan', '0982374753', 'hoang.anhlan@gmail.com', '034812803930', N'Vũng Tàu', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH026', N'Hồ Anh Tâm', '0935556386', 'ho.anhtam@gmail.com', '034276711930', N'Nha Trang', N'Yêu cầu giường đôi');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH027', N'Phan Anh Bình', '0997705310', 'phan.anh.binh13@gmail.com', '034641960943', N'Nha Trang', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH028', N'Ngô Thị Mai', '0935714784', 'ngo.thimai@gmail.com', '034250635901', N'Huế', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH029', N'Hoàng Anh Mai', '0920117988', 'hoang.anh.mai71@gmail.com', '034960122341', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH030', N'Nguyễn Thị Mai', '0932321899', 'nguyen.thi.mai62@gmail.com', '034640463568', N'Huế', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH031', N'Phan Hữu Uyên', '0948285503', 'phan.huu.uyen94@gmail.com', '034268767101', N'Đà Lạt', N'Khách quen');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH032', N'Đỗ Anh Hà', '0935487660', 'do.anh.ha8@gmail.com', '034941412032', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH033', N'Đỗ Đức Bình', '0916729990', 'do.duc.binh65@gmail.com', '034079861243', N'Hà Nội', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH034', N'Trần Minh Cường', '0989864260', 'tran.minhcuong@gmail.com', '034399523052', N'Huế', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH035', N'Dương Thị Lan Mai', '0987701200', 'duong.thi.lan.mai80@gmail.com', '034913616724', N'Quảng Ninh', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH036', N'Võ Đức Nam', '0937415205', 'vo.duc.nam41@gmail.com', '034787957213', N'Huế', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH037', N'Bùi Hữu Uyên', '0952436584', 'bui.huu.uyen10@gmail.com', '034551183219', N'Quảng Ninh', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH038', N'Trần Thị Hương', '0938609087', 'tran.thi.huong17@gmail.com', '034260407870', N'TP. Hồ Chí Minh', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH039', N'Huỳnh Hữu Hùng', '0968812137', 'huynh.huu.hung91@gmail.com', '034314199398', N'Đà Lạt', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH040', N'Bùi Thị Hồng Oanh', '0999038526', 'bui.hongoanh@gmail.com', '034800414661', N'Cần Thơ', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH041', N'Dương Thị Hương', '0930863865', 'duong.thi.huong78@gmail.com', '034883662637', N'Nha Trang', N'Thích phòng yên tĩnh');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH042', N'Bùi Hữu Yến', '0975569635', 'bui.huu.yen7@gmail.com', '034181120841', N'Huế', NULL);
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH043', N'Hoàng Văn An', '0954769200', 'hoang.van.an82@gmail.com', '034971008994', N'Đà Nẵng', N'Khách quen');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH044', N'Vũ Thị Hồng Tâm', '0985283645', 'vu.hongtam@gmail.com', '034707157168', N'Đà Nẵng', N'Dị ứng hải sản');
INSERT INTO dbo.KHACHHANG (MaKH, HoTen, SoDienThoai, Email, CCCD, DiaChi, GhiChu) VALUES (N'KH045', N'Nguyễn Đức Linh', '0984158663', 'nguyen.duclinh@gmail.com', '034497047298', N'Cần Thơ', N'Có trẻ nhỏ');
GO
-- ============================
-- 4. INSERT: dbo.DICHVU (12)
-- ============================

INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D001', N'Dịch vụ giặt ủi', N'Tiện ích & Vệ sinh', N'Cân', 20000, N'Chỉ In-house', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D002', N'Đưa đón sân bay Liên Khương', N'Di chuyển & Phương tiện', N'Lượt', 350000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D003', N'Đưa đón bến xe Đà Lạt', N'Di chuyển & Phương tiện', N'Lượt', 150000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D004', N'Ăn sáng tại phòng', N'Ăn uống & Tiện ích', N'Suất', 80000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D005', N'Thuê xe máy (xe số/Tay ga)', N'Di chuyển & Phương tiện', N'Ngày', 150000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D006', N'Giường phụ (Extra Bed)', N'Tiện nghi phòng', N'Đêm', 150000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D007', N'Set BBQ ngoài trời', N'Ăn uống & Trải nghiệm', N'Set', 450000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D008', N'Phụ thu nhận phòng sớm', N'Phụ thu thời gian', N'Lượt', 150000, N'Chỉ Pre-stay', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D009', N'Phụ thu trả phòng muộn', N'Phụ thu thời gian', N'Lượt', 150000, N'Chỉ In-house', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D010', N'Set up Romantic Date', N'Trải nghiệm theo Vibe', N'Gói', 350000, N'Chỉ Pre-stay', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D011', N'Thuê máy chiếu HD / Galaxy Chill', N'Giải trí tại phòng', N'Lượt', 100000, N'Cả hai', N'Đang hoạt động');
INSERT INTO dbo.DICHVU (MaDV, TenDichVu, NhomDichVu, DonViTinh, DonGia, ThoiDiemApDung, TrangThai) VALUES (N'D012', N'Minibar (Nước ngọt + Đồ ăn nhẹ)', N'Minibar', N'Set', 30000, N'Chỉ In-house', N'Đang hoạt động');
GO
-- ============================
-- 5. INSERT: dbo.DONDATPHONG (50)
-- Moc: 2026-10-21 13:42. 15 hoan thanh | 8 check-in | 10 xac nhan | 5 cho coc | 8 huy | 4 no-show
-- ============================
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260001', N'ND001', N'KH001', N'P101', '2026-08-02', '2026-08-04', 2, 2, 900000, 270000, 190000, 1090000, 1090000, 0, N'Đã hoàn thành', N'2026-07-20T09:30:00', N'2026-08-02T14:30:00', N'2026-08-04T11:10:00', N'Cần thêm gối');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260002', N'ND001', N'KH005', N'P201', '2026-08-05', '2026-08-08', 2, 3, 1950000, 585000, 450000, 2400000, 2400000, 0, N'Đã hoàn thành', N'2026-07-22T10:00:00', N'2026-08-05T14:15:00', N'2026-08-08T11:00:00', NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260003', N'ND001', N'KH012', N'P301', '2026-08-10', '2026-08-13', 4, 3, 2550000, 765000, 520000, 3070000, 3070000, 0, N'Đã hoàn thành', N'2026-07-28T08:40:00', N'2026-08-10T15:05:00', N'2026-08-13T10:40:00', N'Có trẻ nhỏ');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260004', N'ND001', N'KH008', N'P102', '2026-08-15', '2026-08-17', 2, 2, 900000, 270000, 0, 900000, 900000, 0, N'Đã hoàn thành', N'2026-08-01T11:20:00', N'2026-08-15T14:45:00', N'2026-08-17T11:20:00', N'Thích phòng yên tĩnh');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260005', N'ND001', N'KH022', N'P204', '2026-08-18', '2026-08-21', 2, 3, 2100000, 630000, 450000, 2550000, 2550000, 0, N'Đã hoàn thành', N'2026-08-05T09:00:00', N'2026-08-18T16:10:00', N'2026-08-21T11:05:00', N'Kỷ niệm ngày cưới');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260006', N'ND001', N'KH014', N'P401', '2026-08-22', '2026-08-25', 3, 3, 2850000, 855000, 900000, 3750000, 3750000, 0, N'Đã hoàn thành', N'2026-08-08T14:00:00', N'2026-08-22T15:00:00', N'2026-08-25T11:30:00', N'Cần giường phụ và BBQ');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260007', N'ND001', N'KH021', N'P103', '2026-09-01', '2026-09-03', 1, 2, 960000, 288000, 150000, 1110000, 1110000, 0, N'Đã hoàn thành', N'2026-08-18T10:15:00', N'2026-09-01T11:20:00', N'2026-09-03T11:05:00', N'Nhận phòng sớm');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260008', N'ND001', N'KH011', N'P202', '2026-09-05', '2026-09-08', 2, 3, 1950000, 585000, 350000, 2300000, 2300000, 0, N'Đã hoàn thành', N'2026-08-20T16:30:00', N'2026-09-05T14:25:00', N'2026-09-08T10:50:00', N'Đón sân bay Liên Khương');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260009', N'ND001', N'KH015', N'P303', '2026-09-12', '2026-09-15', 3, 3, 2700000, 810000, 930000, 3630000, 3630000, 0, N'Đã hoàn thành', N'2026-08-30T09:45:00', N'2026-09-12T15:20:00', N'2026-09-15T11:15:00', N'Đi cùng gia đình');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260010', N'ND001', N'KH028', N'P104', '2026-09-18', '2026-09-20', 2, 2, 960000, 288000, 210000, 1170000, 1170000, 0, N'Đã hoàn thành', N'2026-09-05T13:10:00', N'2026-09-18T14:40:00', N'2026-09-20T15:20:00', NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260011', N'ND001', N'KH024', N'P201', '2026-09-22', '2026-09-24', 2, 2, 1300000, 390000, 0, 1300000, 1300000, 0, N'Đã hoàn thành', N'2026-09-10T08:00:00', N'2026-09-22T14:10:00', N'2026-09-24T11:40:00', N'Thích phòng yên tĩnh');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260012', N'ND001', N'KH045', N'P302', '2026-09-25', '2026-09-28', 4, 3, 2640000, 792000, 60000, 2700000, 2700000, 0, N'Đã hoàn thành', N'2026-09-12T15:30:00', N'2026-09-25T16:00:00', N'2026-09-28T10:30:00', N'Có trẻ nhỏ');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260013', N'ND001', N'KH033', N'P101', '2026-10-02', '2026-10-04', 2, 2, 900000, 270000, 100000, 1000000, 1000000, 0, N'Đã hoàn thành', N'2026-09-18T11:00:00', N'2026-10-02T14:55:00', N'2026-10-04T11:25:00', NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260014', N'ND001', N'KH043', N'P203', '2026-10-08', '2026-10-11', 2, 3, 2040000, 612000, 610000, 2650000, 2650000, 0, N'Đã hoàn thành', N'2026-09-25T09:20:00', N'2026-10-08T15:35:00', N'2026-10-11T11:10:00', N'Khách quen');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260015', N'ND001', N'KH006', N'P102', '2026-10-15', '2026-10-17', 2, 2, 900000, 270000, 0, 900000, 900000, 0, N'Đã hoàn thành', N'2026-10-02T10:40:00', N'2026-10-15T14:20:00', N'2026-10-17T11:00:00', N'Dị ứng hải sản');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260016', N'ND001', N'KH018', N'P101', '2026-10-20', '2026-10-23', 2, 3, 1350000, 405000, 30000, 1380000, 405000, 975000, N'Đã check-in', N'2026-10-08T09:00:00', N'2026-10-20T14:40:00', NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260017', N'ND001', N'KH009', N'P201', '2026-10-19', '2026-10-22', 2, 3, 1950000, 585000, 160000, 2110000, 585000, 1525000, N'Đã check-in', N'2026-10-07T14:20:00', N'2026-10-19T15:10:00', NULL, N'Yêu cầu giường đôi');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260018', N'ND001', N'KH016', N'P301', '2026-10-18', '2026-10-24', 4, 6, 5100000, 1530000, 920000, 6020000, 1530000, 4490000, N'Đã check-in', N'2026-10-05T08:30:00', N'2026-10-18T14:05:00', NULL, N'Đi cùng gia đình');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260019', N'ND001', N'KH003', N'P401', '2026-10-21', '2026-10-24', 3, 3, 2850000, 855000, 150000, 3000000, 855000, 2145000, N'Đã check-in', N'2026-10-10T11:15:00', N'2026-10-21T11:20:00', NULL, N'Nhận phòng sớm');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260020', N'ND001', N'KH026', N'P204', '2026-10-17', '2026-10-22', 2, 5, 3500000, 1050000, 140000, 3640000, 1050000, 2590000, N'Đã check-in', N'2026-10-04T16:45:00', N'2026-10-17T16:00:00', NULL, N'Yêu cầu giường đôi');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260021', N'ND001', N'KH038', N'P103', '2026-10-20', '2026-10-22', 2, 2, 960000, 288000, 0, 960000, 288000, 672000, N'Đã check-in', N'2026-10-09T13:00:00', N'2026-10-20T14:55:00', NULL, N'Thích phòng yên tĩnh');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260022', N'ND001', N'KH007', N'P303', '2026-10-19', '2026-10-23', 3, 4, 3600000, 1080000, 450000, 4050000, 1080000, 2970000, N'Đã check-in', N'2026-10-06T10:10:00', N'2026-10-19T15:00:00', NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260023', N'ND001', N'KH041', N'P104', '2026-10-20', '2026-10-23', 2, 3, 1440000, 432000, 0, 1440000, 432000, 1008000, N'Đã check-in', N'2026-10-11T09:50:00', N'2026-10-20T14:20:00', NULL, N'Thích phòng yên tĩnh');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260024', N'ND001', N'KH011', N'P102', '2026-10-22', '2026-10-25', 2, 3, 1350000, 405000, 350000, 1700000, 405000, 1295000, N'Đã xác nhận', N'2026-10-10T09:30:00', NULL, NULL, N'Đón sân bay Liên Khương');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260025', N'ND001', N'KH022', N'P202', '2026-10-24', '2026-10-26', 2, 2, 1300000, 390000, 350000, 1650000, 390000, 1260000, N'Đã xác nhận', N'2026-10-12T15:00:00', NULL, NULL, N'Kỷ niệm ngày cưới');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260026', N'ND001', N'KH019', N'P203', '2026-10-25', '2026-10-28', 2, 3, 2040000, 612000, 0, 2040000, 612000, 1428000, N'Đã xác nhận', N'2026-10-13T08:20:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260027', N'ND001', N'KH013', N'P302', '2026-10-22', '2026-10-26', 3, 4, 3520000, 1056000, 320000, 3840000, 1056000, 2784000, N'Đã xác nhận', N'2026-10-09T11:40:00', NULL, NULL, N'Có trẻ nhỏ');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260028', N'ND001', N'KH030', N'P101', '2026-11-02', '2026-11-04', 2, 2, 900000, 270000, 0, 900000, 270000, 630000, N'Đã xác nhận', N'2026-10-14T10:00:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260029', N'ND001', N'KH034', N'P201', '2026-10-28', '2026-10-31', 1, 3, 1950000, 585000, 0, 1950000, 585000, 1365000, N'Đã xác nhận', N'2026-10-15T14:10:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260030', N'ND001', N'KH020', N'P401', '2026-11-05', '2026-11-08', 2, 3, 2850000, 855000, 450000, 3300000, 855000, 2445000, N'Đã xác nhận', N'2026-10-16T09:15:00', NULL, NULL, N'Đặt trước set BBQ');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260031', N'ND001', N'KH004', N'P204', '2026-10-26', '2026-10-29', 2, 3, 2100000, 630000, 0, 2100000, 630000, 1470000, N'Đã xác nhận', N'2026-10-14T16:30:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260032', N'ND001', N'KH015', N'P303', '2026-11-01', '2026-11-04', 4, 3, 2700000, 810000, 450000, 3150000, 810000, 2340000, N'Đã xác nhận', N'2026-10-17T08:45:00', NULL, NULL, N'Đi cùng gia đình');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260033', N'ND001', N'KH002', N'P104', '2026-10-28', '2026-10-30', 2, 2, 960000, 288000, 150000, 1110000, 288000, 822000, N'Đã xác nhận', N'2026-10-18T13:25:00', NULL, NULL, N'Đón bến xe Đà Lạt');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260034', N'ND001', N'KH027', N'P103', '2026-11-06', '2026-11-08', 2, 2, 960000, 288000, 0, 960000, 0, 960000, N'Chờ đặt cọc', N'2026-10-20T20:30:00', NULL, NULL, N'Muốn phòng tầng cao');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260035', N'ND001', N'KH035', N'P301', '2026-11-10', '2026-11-13', 4, 3, 2550000, 765000, 0, 2550000, 0, 2550000, N'Chờ đặt cọc', N'2026-10-21T10:20:00', NULL, NULL, N'Đi cùng gia đình');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260036', N'ND001', N'KH040', N'P202', '2026-11-08', '2026-11-10', 2, 2, 1300000, 390000, 0, 1300000, 0, 1300000, N'Chờ đặt cọc', N'2026-10-21T11:35:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260037', N'ND001', N'KH017', N'P102', '2026-11-12', '2026-11-14', 1, 2, 900000, 270000, 0, 900000, 0, 900000, N'Chờ đặt cọc', N'2026-10-21T12:40:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260038', N'ND001', N'KH025', N'P401', '2026-11-15', '2026-11-17', 2, 2, 1900000, 570000, 0, 1900000, 0, 1900000, N'Chờ đặt cọc', N'2026-10-21T13:10:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260039', N'ND001', N'KH032', N'P104', '2026-08-08', '2026-08-10', 2, 2, 960000, 288000, 0, 960000, 0, 0, N'Đã hủy', N'2026-07-25T09:00:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260040', N'ND001', N'KH036', N'P203', '2026-09-02', '2026-09-05', 2, 3, 2040000, 612000, 0, 2040000, 0, 0, N'Đã hủy', N'2026-08-15T08:30:00', NULL, NULL, N'Thích phòng yên tĩnh');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260041', N'ND001', N'KH039', N'P302', '2026-10-05', '2026-10-08', 3, 3, 2640000, 792000, 0, 2640000, 0, 0, N'Đã hủy', N'2026-09-20T10:00:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260042', N'ND001', N'KH042', N'P101', '2026-10-25', '2026-10-27', 2, 2, 900000, 270000, 0, 900000, 0, 0, N'Đã hủy', N'2026-10-10T16:00:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260043', N'ND001', N'KH010', N'P202', '2026-08-12', '2026-08-14', 2, 2, 1300000, 390000, 0, 1300000, 390000, 0, N'Đã hủy', N'2026-08-01T09:40:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260044', N'ND001', N'KH044', N'P301', '2026-09-20', '2026-09-22', 2, 2, 1700000, 510000, 0, 1700000, 510000, 0, N'Đã hủy', N'2026-09-10T14:00:00', NULL, NULL, N'Dị ứng hải sản');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260045', N'ND001', N'KH037', N'P204', '2026-10-01', '2026-10-03', 2, 2, 1400000, 420000, 0, 1400000, 420000, 0, N'Đã hủy', N'2026-09-20T11:20:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260046', N'ND001', N'KH029', N'P103', '2026-10-10', '2026-10-12', 1, 2, 960000, 288000, 0, 960000, 288000, 0, N'Đã hủy', N'2026-10-05T08:10:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260047', N'ND001', N'KH005', N'P102', '2026-09-08', '2026-09-10', 2, 2, 900000, 270000, 0, 900000, 270000, 0, N'No-show', N'2026-08-25T10:30:00', NULL, NULL, N'Khách quen');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260048', N'ND001', N'KH023', N'P201', '2026-10-05', '2026-10-07', 2, 2, 1300000, 390000, 0, 1300000, 390000, 0, N'No-show', N'2026-09-20T15:40:00', NULL, NULL, NULL);
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260049', N'ND001', N'KH031', N'P303', '2026-10-08', '2026-10-10', 2, 2, 1800000, 540000, 0, 1800000, 540000, 0, N'No-show', N'2026-09-25T09:00:00', NULL, NULL, N'Khách quen');
INSERT INTO dbo.DONDATPHONG (MaDon, MaND, MaKH, MaPhong, NgayNhanPhong, NgayTraPhong, SoKhach, SoDem, TienPhong, TienCocYeuCau, TienDichVu, TongTien, DaThu, ConLai, TrangThaiDon, ThoiGianTaoDon, ThoiGianCheckInThucTe, ThoiGianCheckOutThucTe, YeuCauDacBiet) VALUES (N'DP20260050', N'ND001', N'KH043', N'P104', '2026-10-12', '2026-10-14', 2, 2, 960000, 288000, 0, 960000, 288000, 0, N'No-show', N'2026-09-28T13:15:00', NULL, NULL, N'Khách quen');
GO

-- ============================
-- 6. INSERT: dbo.PHIEUTHANHTOAN (64)
-- ============================
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260001', N'DP20260001', N'Cọc', 270000, N'VietQR', N'VQR100001', N'Đã đặt cọc', N'2026-07-20T13:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260002', N'DP20260001', N'Tất toán', 820000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-08-04T11:10:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260003', N'DP20260002', N'Cọc', 585000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-07-22T14:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260004', N'DP20260002', N'Tất toán', 1815000, N'VietQR', N'VQR100004', N'Đã thanh toán', N'2026-08-08T11:00:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260005', N'DP20260003', N'Cọc', 765000, N'VietQR', N'VQR100005', N'Đã đặt cọc', N'2026-07-28T12:40:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260006', N'DP20260003', N'Tất toán', 2305000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-08-13T10:40:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260007', N'DP20260004', N'Cọc', 270000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-08-01T15:20:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260008', N'DP20260004', N'Tất toán', 630000, N'VietQR', N'VQR100008', N'Đã thanh toán', N'2026-08-17T11:20:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260009', N'DP20260005', N'Cọc', 630000, N'VietQR', N'VQR100009', N'Đã đặt cọc', N'2026-08-05T13:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260010', N'DP20260005', N'Tất toán', 1920000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-08-21T11:05:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260011', N'DP20260006', N'Cọc', 855000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-08-08T18:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260012', N'DP20260006', N'Tất toán', 2895000, N'VietQR', N'VQR100012', N'Đã thanh toán', N'2026-08-25T11:30:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260013', N'DP20260007', N'Cọc', 288000, N'VietQR', N'VQR100013', N'Đã đặt cọc', N'2026-08-18T14:15:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260014', N'DP20260007', N'Tất toán', 822000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-09-03T11:05:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260015', N'DP20260008', N'Cọc', 585000, N'VietQR', N'VQR100015', N'Đã đặt cọc', N'2026-08-20T20:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260016', N'DP20260008', N'Tất toán', 1715000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-09-08T10:50:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260017', N'DP20260009', N'Cọc', 810000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-08-30T13:45:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260018', N'DP20260009', N'Tất toán', 2820000, N'VietQR', N'VQR100018', N'Đã thanh toán', N'2026-09-15T11:15:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260019', N'DP20260010', N'Cọc', 288000, N'VietQR', N'VQR100019', N'Đã đặt cọc', N'2026-09-05T17:10:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260020', N'DP20260010', N'Tất toán', 882000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-09-20T15:20:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260021', N'DP20260011', N'Cọc', 390000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-09-10T12:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260022', N'DP20260011', N'Tất toán', 910000, N'VietQR', N'VQR100022', N'Đã thanh toán', N'2026-09-24T11:40:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260023', N'DP20260012', N'Cọc', 792000, N'VietQR', N'VQR100023', N'Đã đặt cọc', N'2026-09-12T19:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260024', N'DP20260012', N'Tất toán', 1908000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-09-28T10:30:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260025', N'DP20260013', N'Cọc', 270000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-09-18T15:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260026', N'DP20260013', N'Tất toán', 730000, N'VietQR', N'VQR100026', N'Đã thanh toán', N'2026-10-04T11:25:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260027', N'DP20260014', N'Cọc', 612000, N'VietQR', N'VQR100027', N'Đã đặt cọc', N'2026-09-25T13:20:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260028', N'DP20260014', N'Tất toán', 2038000, N'Tiền mặt', NULL, N'Đã thanh toán', N'2026-10-11T11:10:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260029', N'DP20260015', N'Cọc', 270000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-02T14:40:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260030', N'DP20260015', N'Tất toán', 630000, N'VietQR', N'VQR100030', N'Đã thanh toán', N'2026-10-17T11:00:00', N'ND001', N'Tất toán khi check-out');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260031', N'DP20260016', N'Cọc', 405000, N'VietQR', N'VQR100031', N'Đã đặt cọc', N'2026-10-08T13:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260032', N'DP20260017', N'Cọc', 585000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-07T18:20:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260033', N'DP20260018', N'Cọc', 1530000, N'VietQR', N'VQR100033', N'Đã đặt cọc', N'2026-10-05T12:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260034', N'DP20260019', N'Cọc', 855000, N'VietQR', N'VQR100034', N'Đã đặt cọc', N'2026-10-10T15:15:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260035', N'DP20260020', N'Cọc', 1050000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-04T20:45:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260036', N'DP20260021', N'Cọc', 288000, N'VietQR', N'VQR100036', N'Đã đặt cọc', N'2026-10-09T17:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260037', N'DP20260022', N'Cọc', 1080000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-06T14:10:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260038', N'DP20260023', N'Cọc', 432000, N'VietQR', N'VQR100038', N'Đã đặt cọc', N'2026-10-11T13:50:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260039', N'DP20260024', N'Cọc', 405000, N'VietQR', N'VQR100039', N'Đã đặt cọc', N'2026-10-10T13:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260040', N'DP20260025', N'Cọc', 390000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-12T19:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260041', N'DP20260026', N'Cọc', 612000, N'VietQR', N'VQR100041', N'Đã đặt cọc', N'2026-10-13T12:20:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260042', N'DP20260027', N'Cọc', 1056000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-09T15:40:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260043', N'DP20260028', N'Cọc', 270000, N'VietQR', N'VQR100043', N'Đã đặt cọc', N'2026-10-14T14:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260044', N'DP20260029', N'Cọc', 585000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-15T18:10:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260045', N'DP20260030', N'Cọc', 855000, N'VietQR', N'VQR100045', N'Đã đặt cọc', N'2026-10-16T13:15:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260046', N'DP20260031', N'Cọc', 630000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-14T20:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260047', N'DP20260032', N'Cọc', 810000, N'VietQR', N'VQR100047', N'Đã đặt cọc', N'2026-10-17T12:45:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260048', N'DP20260033', N'Cọc', 288000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-18T17:25:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260049', N'DP20260039', N'Cọc', 288000, N'VietQR', N'VQR100049', N'Đã đặt cọc', N'2026-07-25T13:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260050', N'DP20260039', N'Hoàn cọc', 288000, N'VietQR', N'HOAN100050', N'Đã hoàn tiền', N'2026-08-05T10:00:00', N'ND001', N'Hoàn cọc do hủy trước 48 giờ');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260051', N'DP20260040', N'Cọc', 612000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-08-15T12:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260052', N'DP20260040', N'Hoàn cọc', 612000, N'Tiền mặt', NULL, N'Đã hoàn tiền', N'2026-08-28T11:00:00', N'ND001', N'Hoàn cọc do hủy trước 48 giờ');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260053', N'DP20260041', N'Cọc', 792000, N'VietQR', N'VQR100053', N'Đã đặt cọc', N'2026-09-20T14:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260054', N'DP20260041', N'Hoàn cọc', 792000, N'VietQR', N'HOAN100054', N'Đã hoàn tiền', N'2026-10-01T15:00:00', N'ND001', N'Hoàn cọc do hủy trước 48 giờ');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260055', N'DP20260042', N'Cọc', 270000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-10T20:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260056', N'DP20260042', N'Hoàn cọc', 270000, N'Tiền mặt', NULL, N'Đã hoàn tiền', N'2026-10-18T09:30:00', N'ND001', N'Hoàn cọc do hủy trước 48 giờ');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260057', N'DP20260043', N'Cọc', 390000, N'VietQR', N'VQR100057', N'Đã đặt cọc', N'2026-08-01T13:40:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260058', N'DP20260044', N'Cọc', 510000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-09-10T18:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260059', N'DP20260045', N'Cọc', 420000, N'VietQR', N'VQR100059', N'Đã đặt cọc', N'2026-09-20T15:20:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260060', N'DP20260046', N'Cọc', 288000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-10-05T12:10:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260061', N'DP20260047', N'Cọc', 270000, N'VietQR', N'VQR100061', N'Đã đặt cọc', N'2026-08-25T14:30:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260062', N'DP20260048', N'Cọc', 390000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-09-20T19:40:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260063', N'DP20260049', N'Cọc', 540000, N'VietQR', N'VQR100063', N'Đã đặt cọc', N'2026-09-25T13:00:00', N'ND001', N'Đặt cọc 30% tiền phòng');
INSERT INTO dbo.PHIEUTHANHTOAN (MaPhieu, MaDon, LoaiPhieu, SoTien, PhuongThuc, MaGiaoDichNganHang, TrangThaiThanhToan, NgayLap, NguoiLap, GhiChu) VALUES (N'PT20260064', N'DP20260050', N'Cọc', 288000, N'Tiền mặt', NULL, N'Đã đặt cọc', N'2026-09-28T17:15:00', N'ND001', N'Đặt cọc 30% tiền phòng');
GO

-- ============================
-- 7. INSERT: dbo.CHITIETDICHVU (33)
-- ============================
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260001', N'DP20260001', N'D004', 2, 80000, 160000, N'In-house', N'2026-08-02T17:30:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260002', N'DP20260001', N'D012', 1, 30000, 30000, N'In-house', N'2026-08-02T19:30:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260003', N'DP20260002', N'D005', 3, 150000, 450000, N'In-house', N'2026-08-05T17:15:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260004', N'DP20260003', N'D004', 6, 80000, 480000, N'In-house', N'2026-08-10T18:05:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260005', N'DP20260003', N'D001', 2, 20000, 40000, N'In-house', N'2026-08-10T20:05:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260006', N'DP20260005', N'D010', 1, 350000, 350000, N'Pre-stay', N'2026-08-05T15:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260007', N'DP20260005', N'D011', 1, 100000, 100000, N'In-house', N'2026-08-18T19:10:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260008', N'DP20260006', N'D006', 3, 150000, 450000, N'In-house', N'2026-08-22T18:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260009', N'DP20260006', N'D007', 1, 450000, 450000, N'In-house', N'2026-08-22T20:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260010', N'DP20260007', N'D008', 1, 150000, 150000, N'Pre-stay', N'2026-09-01T11:20:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260011', N'DP20260008', N'D002', 1, 350000, 350000, N'Pre-stay', N'2026-08-20T22:30:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260012', N'DP20260009', N'D004', 6, 80000, 480000, N'In-house', N'2026-09-12T18:20:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260013', N'DP20260009', N'D005', 3, 150000, 450000, N'In-house', N'2026-09-12T20:20:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260014', N'DP20260010', N'D009', 1, 150000, 150000, N'In-house', N'2026-09-18T17:40:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260015', N'DP20260010', N'D012', 2, 30000, 60000, N'In-house', N'2026-09-18T19:40:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260016', N'DP20260012', N'D001', 3, 20000, 60000, N'In-house', N'2026-09-25T19:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260017', N'DP20260013', N'D011', 1, 100000, 100000, N'In-house', N'2026-10-02T17:55:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260018', N'DP20260014', N'D005', 3, 150000, 450000, N'In-house', N'2026-10-08T18:35:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260019', N'DP20260014', N'D004', 2, 80000, 160000, N'In-house', N'2026-10-08T20:35:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260020', N'DP20260016', N'D012', 1, 30000, 30000, N'In-house', N'2026-10-20T17:40:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260021', N'DP20260017', N'D004', 2, 80000, 160000, N'In-house', N'2026-10-19T18:10:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260022', N'DP20260018', N'D005', 4, 150000, 600000, N'In-house', N'2026-10-18T17:05:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260023', N'DP20260018', N'D004', 4, 80000, 320000, N'In-house', N'2026-10-18T19:05:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260024', N'DP20260019', N'D008', 1, 150000, 150000, N'Pre-stay', N'2026-10-21T11:20:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260025', N'DP20260020', N'D011', 1, 100000, 100000, N'In-house', N'2026-10-17T19:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260026', N'DP20260020', N'D001', 2, 20000, 40000, N'In-house', N'2026-10-17T21:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260027', N'DP20260022', N'D007', 1, 450000, 450000, N'In-house', N'2026-10-19T18:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260028', N'DP20260024', N'D002', 1, 350000, 350000, N'Pre-stay', N'2026-10-10T15:30:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260029', N'DP20260025', N'D010', 1, 350000, 350000, N'Pre-stay', N'2026-10-12T21:00:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260030', N'DP20260027', N'D004', 4, 80000, 320000, N'Pre-stay', N'2026-10-09T17:40:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260031', N'DP20260030', N'D007', 1, 450000, 450000, N'Pre-stay', N'2026-10-16T15:15:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260032', N'DP20260032', N'D005', 3, 150000, 450000, N'Pre-stay', N'2026-10-17T14:45:00', NULL);
INSERT INTO dbo.CHITIETDICHVU (MaChiTiet, MaDon, MaDV, SoLuong, DonGiaTaiThoiDiem, ThanhTien, GiaiDoan, ThoiDiemThem, GhiChu) VALUES (N'CT20260033', N'DP20260033', N'D003', 1, 150000, 150000, N'Pre-stay', N'2026-10-18T19:25:00', NULL);
GO

-- ============================
-- 8. INSERT: dbo.HOADON (15)
-- ============================
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260001', N'DP20260001', 900000, 190000, 270000, 820000, 1090000, N'Tiền mặt', N'2026-08-04T11:10:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260002', N'DP20260002', 1950000, 450000, 585000, 1815000, 2400000, N'VietQR', N'2026-08-08T11:00:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260003', N'DP20260003', 2550000, 520000, 765000, 2305000, 3070000, N'Tiền mặt', N'2026-08-13T10:40:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260004', N'DP20260004', 900000, 0, 270000, 630000, 900000, N'VietQR', N'2026-08-17T11:20:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260005', N'DP20260005', 2100000, 450000, 630000, 1920000, 2550000, N'Tiền mặt', N'2026-08-21T11:05:00', N'ND001', N'Gói set up romantic');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260006', N'DP20260006', 2850000, 900000, 855000, 2895000, 3750000, N'VietQR', N'2026-08-25T11:30:00', N'ND001', N'Có set BBQ');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260007', N'DP20260007', 960000, 150000, 288000, 822000, 1110000, N'Tiền mặt', N'2026-09-03T11:05:00', N'ND001', N'Có phụ thu nhận phòng sớm');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260008', N'DP20260008', 1950000, 350000, 585000, 1715000, 2300000, N'Tiền mặt', N'2026-09-08T10:50:00', N'ND001', N'Có đưa đón sân bay');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260009', N'DP20260009', 2700000, 930000, 810000, 2820000, 3630000, N'VietQR', N'2026-09-15T11:15:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260010', N'DP20260010', 960000, 210000, 288000, 882000, 1170000, N'Tiền mặt', N'2026-09-20T15:20:00', N'ND001', N'Có phụ thu trả phòng muộn');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260011', N'DP20260011', 1300000, 0, 390000, 910000, 1300000, N'VietQR', N'2026-09-24T11:40:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260012', N'DP20260012', 2640000, 60000, 792000, 1908000, 2700000, N'Tiền mặt', N'2026-09-28T10:30:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260013', N'DP20260013', 900000, 100000, 270000, 730000, 1000000, N'VietQR', N'2026-10-04T11:25:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260014', N'DP20260014', 2040000, 610000, 612000, 2038000, 2650000, N'Tiền mặt', N'2026-10-11T11:10:00', N'ND001', N'Hóa đơn check-out');
INSERT INTO dbo.HOADON (MaHoaDon, MaDon, TienPhong, TienDichVu, TienCocDaTra, TienThanhToanKhiCheckOut, TongTienDaThanhToan, PhuongThuc, NgayXuat, NguoiXuat, GhiChu) VALUES (N'HD20260015', N'DP20260015', 900000, 0, 270000, 630000, 900000, N'VietQR', N'2026-10-17T11:00:00', N'ND001', N'Hóa đơn check-out');
GO

-- ----------------------------
-- KIEM TRA TOAN VEN
-- ----------------------------
SELECT name AS TenBang FROM sys.tables ORDER BY name;
SELECT 
  (SELECT COUNT(*) FROM dbo.PHONG) AS SoPhong,
  (SELECT COUNT(*) FROM dbo.DICHVU) AS SoDichVu,
  (SELECT COUNT(*) FROM dbo.KHACHHANG) AS SoKhach,
  (SELECT COUNT(*) FROM dbo.DONDATPHONG) AS SoDon,
  (SELECT COUNT(*) FROM dbo.PHIEUTHANHTOAN) AS SoPhieuThu,
  (SELECT COUNT(*) FROM dbo.CHITIETDICHVU) AS SoChiTietDV,
  (SELECT COUNT(*) FROM dbo.HOADON) AS SoHoaDon;
GO
