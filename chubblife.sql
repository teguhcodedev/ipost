-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 18, 2021 at 11:40 AM
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
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_user` int(11) NOT NULL,
  `user` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_kegiatan` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jumlah` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `master_user_agents`
--

CREATE TABLE `master_user_agents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `AGENT_USERNAME` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `AGENT_NAME` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AGENT_PWD` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `AGENT_LEVEL` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AGENT_DN` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AGENT_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AGENT_TIME` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GROUP_ID` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LEADER_ID` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SPV_ID` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MANAGER_ID` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LAST_UPDATE` date DEFAULT NULL,
  `STS_AUTODIAL` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STS_AUDITORIAL` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PWD_EXPIRE` date DEFAULT '2021-06-17',
  `RUNNING_STATUS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DATE_JOIN` date DEFAULT NULL,
  `DATE_RESIGN` date DEFAULT NULL,
  `TEAM` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'TEAM 1',
  `CREATE_USER` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'ADMIN',
  `BALANCE_VOUCHER` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  `EXPIRE_DATE` date DEFAULT NULL,
  `AGENT_GROUP` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  `LOGIN_STATUS` tinyint(1) DEFAULT 0,
  `LOCK_STATUS` tinyint(1) DEFAULT 0,
  `APPROVE_VOUCHER` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  `TEAM_QA` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  `CAN_USE_SOFTPHONE` tinyint(1) DEFAULT 0,
  `LAST_ACCESS` datetime DEFAULT NULL,
  `LAST_UPDATED_BY` datetime DEFAULT NULL,
  `IS_DELETED` tinyint(1) DEFAULT 0,
  `AGENT_PHOTO` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LEVEL_TARGET` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ID_MITRA` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ID_MITRA_BNILIFE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CREATE_DATE` date DEFAULT NULL,
  `EDIT_DATE` date DEFAULT NULL,
  `SPONSOR` date DEFAULT NULL,
  `PRODUCT` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LOGIN_IP` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BS_VERSION` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT 'Animates 04',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `master_user_agents`
--

INSERT INTO `master_user_agents` (`id`, `AGENT_USERNAME`, `AGENT_NAME`, `AGENT_PWD`, `AGENT_LEVEL`, `AGENT_DN`, `AGENT_STATUS`, `AGENT_TIME`, `GROUP_ID`, `LEADER_ID`, `SPV_ID`, `MANAGER_ID`, `LAST_UPDATE`, `STS_AUTODIAL`, `STS_AUDITORIAL`, `PWD_EXPIRE`, `RUNNING_STATUS`, `DATE_JOIN`, `DATE_RESIGN`, `TEAM`, `CREATE_USER`, `BALANCE_VOUCHER`, `EXPIRE_DATE`, `AGENT_GROUP`, `LOGIN_STATUS`, `LOCK_STATUS`, `APPROVE_VOUCHER`, `TEAM_QA`, `CAN_USE_SOFTPHONE`, `LAST_ACCESS`, `LAST_UPDATED_BY`, `IS_DELETED`, `AGENT_PHOTO`, `LEVEL_TARGET`, `ID_MITRA`, `ID_MITRA_BNILIFE`, `CREATE_DATE`, `EDIT_DATE`, `SPONSOR`, `PRODUCT`, `LOGIN_IP`, `BS_VERSION`, `created_at`, `updated_at`) VALUES
(1, 'Teguh', 'Teguh Muhammad Harits', '$2y$10$Lna1X.lJGWo3q4iaD73TPuuS6PY65Hcb2LmvA/QpSXs13YtQkO5dK', 'ADMIN', '083135351881', 'ACTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-06-17', NULL, '2021-05-18', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 1, 0, 'NULL', 'NULL', 0, NULL, NULL, 0, 'aries.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '127.0.0.1', 'Animates 04', '2021-05-18 01:08:31', '2021-05-18 08:05:17'),
(2, 'Tofan', 'Tofan Maiki', '$2y$10$qGQWiys8iddd4iFMe4t0.OnDlFACabB/iavovD2VAR/siNFKj73r2', 'SPV', '0831391838191', 'ACTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-17', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 1, 0, 'NULL', 'NULL', 1, NULL, NULL, 0, 'shoes1.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-18 01:14:42', '2021-05-18 01:45:15'),
(3, 'Budi', 'Budi', '$2y$10$o/H1bueGNXgCE4MXy/mX3O6ZC7EjDF8ogERa6HXtZ3B4dVH28Pd8a', 'SPV', '08989898989', 'ACTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-12', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 0, 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-18 01:17:59', '2021-05-18 01:17:59'),
(4, 'Intan', 'Intan 08928983924', '$2y$10$xOePSucJHe8PzQxbrVc6ZOthLKr58krtBi7ZgNZ8Hbcz.ytOiDPUy', 'MANAGER', '0898898989', 'ACTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-09', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 0, 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-18 01:30:14', '2021-05-18 01:30:14'),
(5, 'Gerung', 'Gerung', '$2y$10$WK6CrOZlGADfP4W47Ie9quToAybTys2Jb2q6Bvlyzg8iXq8suihZC', 'TELEMARKETER', '088786876', 'ACTIVE', NULL, NULL, NULL, 'Tofan', 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-20', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 0, 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-18 01:32:09', '2021-05-18 01:32:09'),
(6, 'Busi', '5948934', '$2y$10$uvREXd2dHw050vqWS.2xieVw/RdhZhXAxw4xczn1YIbzaSVlZTbZi', 'SPV', '0859849584938', 'ACTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-17', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 0, 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-18 01:33:36', '2021-05-18 01:33:36');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2020_06_12_133440_create_activity_table', 1),
(5, '2021_05_10_082838_create_master_user_agents_table', 1),
(6, '2021_05_12_044150_create_setting_menus_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting_menus`
--

CREATE TABLE `setting_menus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `MENU_NAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LEVEL_TMR` tinyint(1) NOT NULL,
  `LEVEL_SPV` tinyint(1) NOT NULL,
  `LEVEL_ATM` tinyint(1) NOT NULL,
  `LEVEL_ADMIN` tinyint(1) NOT NULL,
  `LEVEL_QA` tinyint(1) NOT NULL,
  `LEVEL_SPVQA` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `setting_menus`
--

INSERT INTO `setting_menus` (`id`, `MENU_NAME`, `LEVEL_TMR`, `LEVEL_SPV`, `LEVEL_ATM`, `LEVEL_ADMIN`, `LEVEL_QA`, `LEVEL_SPVQA`, `created_at`, `updated_at`) VALUES
(1, 'New_Customer_List', 1, 0, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(2, 'Schedule_Customer_List', 1, 0, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(3, 'Other_Customer_List', 1, 0, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(4, 'QA_Customer_List', 0, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(5, 'Recording_CALL_LOG', 0, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(6, 'Report', 0, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(7, 'Print_Management', 0, 1, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(8, 'Upload_And_Distribution_Data', 0, 1, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(9, 'Setting_Progressive', 0, 0, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(10, 'User Management', 0, 0, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(11, 'Voucher', 0, 1, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(12, 'New_Data_Authorization', 0, 1, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(13, 'Database_Maintenance', 0, 1, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(14, 'Setting_Menu', 0, 0, 0, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(15, 'Product_Setup', 0, 0, 0, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(16, 'Change_Password', 0, 1, 1, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(17, 'Performance_Monitoring', 0, 1, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(18, 'Inbound_Follow_Up_List', 1, 0, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(19, 'Inbound_Screen', 1, 0, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(20, 'Dashboard', 0, 1, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(21, 'Setting_Target', 0, 0, 0, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(22, 'Setting_Date', 0, 0, 0, 1, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(23, 'Activity_Monitoring', 0, 1, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(24, 'Self_Monitoring', 1, 1, 1, 1, 1, 1, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(25, 'Setting_Paramter', 0, 0, 1, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57'),
(26, 'SPV_Customer_LIST', 0, 1, 0, 0, 0, 0, '2021-05-18 01:12:57', '2021-05-18 01:12:57');

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
(1, 'Teguh', '$2y$10$Vi1RG0iG6sJBmOwo.eowtOI/vDHRhHdYtnFUGiGCzld/Rgs8yHZTG', 'Teguh Muhammad Harits', '127.0.0.1', NULL, 'admin', 0, 'aries.jpg', '2021-06-17', 'A6BuiE7WNzNdmRq4sxl1ixiwCorkSJvGVjjyEB6yHXVmr2bMdnSJAOmQUR71', '2021-05-18 01:08:31', '2021-05-18 08:05:17'),
(2, 'Tofan', '$2y$10$PG3a6egpfNQtb5IMQpKBhO8nuWUeVScL4F.NPgiDtE1CPBIcTsY6q', 'Tofan Maiki', '127.0.0.1', '2021-05-18 08:44:16', 'spv', 0, 'shoes1.jpg', '2021-06-17', '9AiY1SLvLHaNusSrpcQNkgreStOcjwUvLxETraKA2Urj9lS4BQtkt56TPkm9', '2021-05-18 01:14:42', '2021-05-18 01:45:15'),
(3, 'Budi', '$2y$10$WO6wFG9epxqvwdtOraWnAOB/Fci73/AOW2NMvtezyJlK7j4o6mRJy', 'Budi', NULL, NULL, 'spv', 0, 'default.jpg', '2021-06-17', '1KG0XxP5mwsFPolyxkmsFRC8O0w1vDV7uiYry0PMmFd6kk09SLBOUdKV14Mp', '2021-05-18 01:17:59', '2021-05-18 01:17:59'),
(4, 'Intan', '$2y$10$tFhW3BkwERfTJQjRxVJn8uVGtVehoQTPZg.O8.KaeZrfI8P//Z2Mu', 'Intan 08928983924', NULL, NULL, 'manager', 0, 'default.jpg', '2021-06-17', '8JRSJlbuuUa2ofk93stPZgAR9MAzdZCeXc2c3LkZHTv4XqKqiRSgyhEyWj8m', '2021-05-18 01:30:14', '2021-05-18 01:30:14'),
(5, 'Gerung', '$2y$10$cHRP5IBBLYEqKkO9Lth99.v.oSywQwL6ziWKPQQr6Qnj24U9I9s/a', 'Gerung', NULL, NULL, 'telemarketer', 0, 'default.jpg', '2021-06-17', 'XWvhit98y1ShFPVhGnkGQMzv4F0gG3Sqt8NxZImMc7uCFjWn39rgI6QBAvZD', '2021-05-18 01:32:08', '2021-05-18 01:32:08'),
(6, 'Busi', '$2y$10$vgPywtYIVKA3HCeUcVxEjexqz1ixYWStAlPUAEfZ.DsuH23.GtrMm', '5948934', NULL, NULL, 'spv', 0, 'default.jpg', '2021-06-17', 'IbHkl5prTmpJoNDQljNog1nb1DfvvqXNCoCdqUl7khSFW31D2qoO9mfR3XrC', '2021-05-18 01:33:35', '2021-05-18 01:33:35');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `master_user_agents`
--
ALTER TABLE `master_user_agents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `setting_menus`
--
ALTER TABLE `setting_menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_user_agents`
--
ALTER TABLE `master_user_agents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `setting_menus`
--
ALTER TABLE `setting_menus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
