-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 03:12 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `catering`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_daftar_paket` (IN `p_id_paket` VARCHAR(225), IN `p_nama_paket` VARCHAR(225), IN `p_harga` INT, IN `p_satuan` VARCHAR(225), IN `p_keterangan` VARCHAR(225))   BEGIN
    INSERT INTO Daftar_Paket (id_paket, nama_paket, Harga, Satuan, keterangan)
    VALUES (p_id_paket, p_nama_paket, p_harga, p_satuan, p_keterangan);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_hitungTotalHargaPesanan1` (`id_pesanan` VARCHAR(10)) RETURNS INT(11)  BEGIN
    DECLARE total_harga INT;

    SELECT SUM(detail_pesanan.Jumlah * daftar_paket.Harga)
    INTO total_harga
    FROM detail_pesanan
    JOIN daftar_paket ON detail_pesanan.id_paket = daftar_paket.id_paket
    WHERE detail_pesanan.id_pesanan = id_pesanan;

    IF total_harga IS NULL THEN
        SET total_harga = 0;
    END IF;

    RETURN total_harga;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `Username` varchar(20) NOT NULL,
  `Password` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`Username`, `Password`) VALUES
('Hayya', 'password2'),
('Heni', 'password1'),
('Sekar', 'password3');

-- --------------------------------------------------------

--
-- Table structure for table `daftar_paket`
--

CREATE TABLE `daftar_paket` (
  `id_paket` varchar(225) NOT NULL,
  `nama_paket` varchar(225) DEFAULT NULL,
  `Harga` int(11) DEFAULT NULL,
  `Satuan` varchar(225) DEFAULT NULL,
  `keterangan` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `daftar_paket`
--

INSERT INTO `daftar_paket` (`id_paket`, `nama_paket`, `Harga`, `Satuan`, `keterangan`) VALUES
('P001', 'Paket A', 15000, 'Box', 'Nasi, Ayam Rica-rica, Oseng Soun, Tumis Kacang Panjang'),
('P002', 'Paket B', 16000, 'Box', 'Nasi, Rendang Ayam, Capcay, Balado Terong, Sambel Ijo'),
('P003', 'Paket C', 25000, 'Box', 'Nasi, Ayam Goreng, Semur Telor, Orek Tempe, Tumis Buncis Bakso, Sambel, Kerupuk'),
('P004', 'Paket D', 33000, 'Box', 'Nasi, Sapi Lada Hitam, Rolade Telur Sosis, Brokoli Saus Tiram, Kwetiaw Goreng, Kerupuk, Buah'),
('P005', 'Paket E', 36000, 'Box', 'Nasi, Empal Gepuk, Cumi Pedas, Oseng Daun Pepaya, Soun Cabe, Sambel, Kerupuk, Buah'),
('P006', 'Paket F', 40000, 'Box', 'Nasi, Nila Bakar, Tahu Tempe Goreng, Kwetiau Goreng Bakso, Sambel, Kerupuk, Buah');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_detail` varchar(225) NOT NULL,
  `id_pesanan` varchar(225) DEFAULT NULL,
  `id_paket` varchar(225) DEFAULT NULL,
  `Jumlah` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id_detail`, `id_pesanan`, `id_paket`, `Jumlah`) VALUES
('DET001', 'PES001', 'P001', 10),
('DET002', 'PES002', 'P005', 30),
('DET003', 'PES003', 'P002', 15),
('DET004', 'PES004', 'P004', 50),
('DET005', 'PES005', 'P003', 5),
('DET006', 'PES001', 'P001', 3);

--
-- Triggers `detail_pesanan`
--
DELIMITER $$
CREATE TRIGGER `update_total_harga` AFTER INSERT ON `detail_pesanan` FOR EACH ROW BEGIN
  DECLARE total_harga INT;

  SELECT SUM(dp.Jumlah * p.Harga)
  INTO total_harga
  FROM detail_pesanan dp
  JOIN daftar_paket p ON dp.id_paket = p.id_paket
  WHERE dp.id_pesanan = NEW.id_pesanan;

  IF total_harga IS NULL THEN
    SET total_harga = 0;
  END IF;

  UPDATE pesanan
  SET Total = total_harga
  WHERE id_pesanan = NEW.id_pesanan;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `konsumen`
--

CREATE TABLE `konsumen` (
  `id_konsumen` varchar(225) NOT NULL,
  `Nama` varchar(225) DEFAULT NULL,
  `Alamat` varchar(225) DEFAULT NULL,
  `jenis_kelamin` varchar(25) DEFAULT NULL,
  `no_hp` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `konsumen`
--

INSERT INTO `konsumen` (`id_konsumen`, `Nama`, `Alamat`, `jenis_kelamin`, `no_hp`) VALUES
('KONS001', 'Agnes', 'Babarsari', 'p', '08547'),
('KONS002', 'Windah', 'Minomartani', 'l', '08213'),
('KONS003', 'Kenneth', 'Manukan', 'l', '08198'),
('KONS004', 'Anisa', 'Sambirejo', 'p', '08782'),
('KONS005', 'Nanda', 'Maguwoharjao', 'p', '08523');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` varchar(225) NOT NULL,
  `Tanggal` date DEFAULT NULL,
  `Total` int(11) DEFAULT NULL,
  `Status` varchar(225) DEFAULT NULL,
  `id_konsumen` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `Tanggal`, `Total`, `Status`, `id_konsumen`) VALUES
('PES001', '2024-07-05', 195000, 'Lunas', 'KONS001'),
('PES002', '2024-07-25', 1080000, 'Pending', 'KONS002'),
('PES003', '2024-07-10', 240000, 'Lunas', 'KONS003'),
('PES004', '2024-07-17', 1650000, 'Pending', 'KONS004'),
('PES005', '2024-07-20', 125000, 'Lunas', 'KONS005');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`Username`);

--
-- Indexes for table `daftar_paket`
--
ALTER TABLE `daftar_paket`
  ADD PRIMARY KEY (`id_paket`);

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_pesanan` (`id_pesanan`),
  ADD KEY `id_paket` (`id_paket`);

--
-- Indexes for table `konsumen`
--
ALTER TABLE `konsumen`
  ADD PRIMARY KEY (`id_konsumen`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_konsumen` (`id_konsumen`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`id_paket`) REFERENCES `daftar_paket` (`id_paket`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_konsumen`) REFERENCES `konsumen` (`id_konsumen`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
