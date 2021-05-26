-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2021 at 01:59 PM
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
-- Table structure for table `setting_menus`
--

CREATE TABLE `setting_menus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `MENU_HEADER` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MENU_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MENU_URL` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LEVEL_TMR` tinyint(1) NOT NULL,
  `LEVEL_SPV` tinyint(1) NOT NULL,
  `LEVEL_ATM` tinyint(1) NOT NULL,
  `LEVEL_ADMIN` tinyint(1) NOT NULL,
  `LEVEL_QA` tinyint(1) NOT NULL,
  `LEVEL_SPVQA` tinyint(1) NOT NULL,
  `LEVEL_ADMINISTRATOR` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `setting_menus`
--

INSERT INTO `setting_menus` (`id`, `MENU_HEADER`, `MENU_NAME`, `MENU_URL`, `LEVEL_TMR`, `LEVEL_SPV`, `LEVEL_ATM`, `LEVEL_ADMIN`, `LEVEL_QA`, `LEVEL_SPVQA`, `LEVEL_ADMINISTRATOR`, `created_at`, `updated_at`) VALUES
(1, 'Customer', 'New Customer List', '/new-customer-list', 1, 0, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(2, '', 'Schedule Customer List', '/schedule-customer-list', 1, 0, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(3, '', 'Other Customer List', '/other-customer-list', 1, 0, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(4, '', 'QA Customer List', '/qa-customer-list', 0, 1, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(5, '', 'Recording CALL LOG', '/recording-call-log', 0, 1, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(6, '', 'Report', '/report', 0, 1, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(7, '', 'Print Management', '/print-management', 0, 1, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(8, '', 'Upload And_Distribution Data', '/upload-and-disttribution-data', 0, 1, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(9, '', 'Setting Progressive', '/setting-progressive', 0, 0, 1, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(10, '', 'User Management', '/account', 0, 0, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(11, '', 'Voucher', '/voucher', 0, 1, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(12, '', 'New Data Authorization', '/new-data-authorization', 0, 1, 1, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(13, '', 'Database Maintenance', '/database-maintenance', 0, 1, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(14, '', 'Setting Menu', '/setting-menu', 0, 0, 0, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(15, '', 'Product Setup', '/product-setup', 0, 0, 0, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(16, '', 'Change Password', '/profile', 0, 1, 1, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(17, '', 'Performance Monitoring', '/performance-monitoring', 0, 1, 1, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(18, '', 'Inbound Follow Up List', '/inbound-follow-up-system', 1, 0, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(19, '', 'Inbound Screen', '/inbound-system', 1, 0, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(20, '', 'Dashboard', '/chubblife-dashboard', 0, 1, 1, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(21, '', 'Setting Target', '/setting-target', 0, 0, 0, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(22, '', 'Setting Date', '/setting-date', 0, 0, 0, 1, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(23, '', 'Activity Monitoring', '/activity-monitoring', 0, 1, 1, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(24, '', 'Self Monitoring', '/self-monitoring', 1, 1, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(25, '', 'Setting Paramter', '/setting-parameter', 0, 0, 1, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(26, '', 'SPV Customer LIST', '/spv-customer-list', 0, 1, 0, 0, 0, 0, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(27, '', 'SPV CUSTOMER SEARCH', '/spv-customer-search', 0, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `setting_menus`
--
ALTER TABLE `setting_menus`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `setting_menus`
--
ALTER TABLE `setting_menus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
