-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2021 at 01:48 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chubblife`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_banned` tinyint(1) NOT NULL DEFAULT 0,
  `foto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PWD_EXPIRE` date DEFAULT '2021-06-17',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullname`, `ip_address`, `last_login`, `role`, `is_banned`, `foto`, `PWD_EXPIRE`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Teguh', '$2y$10$Vi1RG0iG6sJBmOwo.eowtOI/vDHRhHdYtnFUGiGCzld/Rgs8yHZTG', 'Teguh Muhammad Harits', '127.0.0.1', '2021-05-26 18:35:43', 'admin', 0, 'aries.jpg', '2021-06-17', 'M583whs8yzkEF6ydW1Uf5ng9dcoHbLkHTr8JNpxmSPDcRdLLSMrkUiiKZklS', '2021-05-18 01:08:31', '2021-05-26 11:37:00'),
(2, 'Tofan', '$2y$10$PG3a6egpfNQtb5IMQpKBhO8nuWUeVScL4F.NPgiDtE1CPBIcTsY6q', 'Tofan Maiki', '127.0.0.1', '2021-05-26 18:01:06', 'spv', 0, 'shoes1.jpg', '2021-06-17', 'vISAXDiXoiXO6aDGw9Oz0OR07ZWeTGXnnPpG2x450nXg5gcpU93JUeLItxCf', '2021-05-18 01:14:42', '2021-05-26 11:01:06'),
(3, 'Budi', '$2y$10$WO6wFG9epxqvwdtOraWnAOB/Fci73/AOW2NMvtezyJlK7j4o6mRJy', 'Budi', '127.0.0.1', '2021-05-26 18:00:06', 'spv', 0, 'default.jpg', '2021-06-17', 'cmuXNa8oDbaHXmpUZ3MQP68hR67ytZCv3Di6iWeYaXnoYsivZurIjsFGekHw', '2021-05-18 01:17:59', '2021-05-26 11:00:06'),
(4, 'Intan', '$2y$10$tFhW3BkwERfTJQjRxVJn8uVGtVehoQTPZg.O8.KaeZrfI8P//Z2Mu', 'Intan 08928983924', '127.0.0.1', '2021-05-26 18:20:46', 'manager', 0, 'default.jpg', '2021-06-17', 'TqnHlHsG8Xo9xDqQlELqfwFXSwpatVb44yciXdXZDdXAM2tJFzIgWNBYkIrz', '2021-05-18 01:30:14', '2021-05-26 11:20:46'),
(5, 'Gerung', '$2y$10$cHRP5IBBLYEqKkO9Lth99.v.oSywQwL6ziWKPQQr6Qnj24U9I9s/a', 'Gerung', '127.0.0.1', NULL, 'telemarketer', 0, 'default.jpg', '2021-06-17', 'XWvhit98y1ShFPVhGnkGQMzv4F0gG3Sqt8NxZImMc7uCFjWn39rgI6QBAvZD', '2021-05-18 01:32:08', '2021-05-26 11:00:17'),
(6, 'Busi', '$2y$10$vgPywtYIVKA3HCeUcVxEjexqz1ixYWStAlPUAEfZ.DsuH23.GtrMm', '5948934', '127.0.0.1', '2021-05-24 14:05:30', 'admin', 0, 'default.jpg', '2021-06-17', 'rpvUQ4V8u7dU7aeJ59FnfJPcq73S0cihcaaHEH3lOyseltn9DKBxKiEcUtuh', '2021-05-18 01:33:35', '2021-05-24 07:05:30'),
(7, 'MUNGGI', '$2y$10$Vi1RG0iG6sJBmOwo.eowtOI/vDHRhHdYtnFUGiGCzld/Rgs8yHZTG', 'munggi', '127.0.0.1', '2021-05-26 18:14:55', 'administrator', 0, 'aries.jpg', '2021-06-17', 'bfDbvRfCMToJ0GVwCN1yqz7cxCMunyWwbSDNbmNTYWB7Fj2mPQ3SvxhAA3nb', '2021-05-18 01:08:31', '2021-05-26 11:14:55'),
(8, 'Roni', '$2y$10$2v9QkSMI8dTsKBktxngRSusXJ3Ob8md/RASBkLZ3sMb2V.dod6hmO', 'Roni', '127.0.0.1', '2021-05-26 18:36:45', 'qa', 0, 'rog.jpg', '2021-06-17', 'oeQVWn0N9pUeVmko5m1j9WY8JwAapJodfpsVDbX5o91qgdf327ZiraNF9ZYc', '2021-05-18 01:08:31', '2021-05-26 11:36:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
