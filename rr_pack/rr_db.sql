-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Czas generowania: 24 Maj 2024, 07:40
-- Wersja serwera: 8.0.36-0ubuntu0.22.04.1
-- Wersja PHP: 8.1.2-1ubuntu2.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `rr_db`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `addon_account`
--

CREATE TABLE `addon_account` (
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `shared` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_unemployed', 'Bezrobotny', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `addon_account_data`
--

CREATE TABLE `addon_account_data` (
  `id` int NOT NULL,
  `account_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `money` int NOT NULL,
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(1, 'society_unemployed', 0, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `addon_inventory`
--

CREATE TABLE `addon_inventory` (
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `shared` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_unemployed', 'Bezrobotny', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `addon_inventory_items`
--

CREATE TABLE `addon_inventory_items` (
  `id` int NOT NULL,
  `inventory_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `count` int NOT NULL,
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `datastore`
--

CREATE TABLE `datastore` (
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `shared` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('society_unemployed', 'Bezrobotny', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `datastore_data`
--

CREATE TABLE `datastore_data` (
  `id` int NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data` longtext COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(1, 'society_unemployed', NULL, '{}');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `items`
--

CREATE TABLE `items` (
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `weight` int NOT NULL DEFAULT '1',
  `rare` tinyint NOT NULL DEFAULT '0',
  `can_remove` tinyint NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `whitelisted` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('unemployed', 'Bezrobotny', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `job_grades`
--

CREATE TABLE `job_grades` (
  `id` int NOT NULL,
  `job_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `grade` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `salary` int NOT NULL,
  `skin_male` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `skin_female` longtext COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Zasiłek', 200, '{}', '{}');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `licenses`
--

CREATE TABLE `licenses` (
  `type` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(60) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `multicharacter_mugshots`
--

CREATE TABLE `multicharacter_mugshots` (
  `identifier` varchar(48) COLLATE utf8mb4_general_ci NOT NULL,
  `url` longtext COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `multicharacter_slots`
--

CREATE TABLE `multicharacter_slots` (
  `identifier` varchar(48) COLLATE utf8mb4_general_ci NOT NULL,
  `slots` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `owned_vehicles`
--

CREATE TABLE `owned_vehicles` (
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `plate` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `vehicle` longtext COLLATE utf8mb4_general_ci,
  `type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'car',
  `job` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stored` tinyint(1) NOT NULL DEFAULT '0',
  `glovebox` longtext COLLATE utf8mb4_general_ci,
  `trunk` longtext COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ox_doorlock`
--

CREATE TABLE `ox_doorlock` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `data` longtext COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ox_inventory`
--

CREATE TABLE `ox_inventory` (
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `data` longtext COLLATE utf8mb4_general_ci,
  `lastupdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `player_outfits`
--

CREATE TABLE `player_outfits` (
  `id` int NOT NULL,
  `citizenid` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `outfitname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `model` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `props` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `components` varchar(1500) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `player_outfit_codes`
--

CREATE TABLE `player_outfit_codes` (
  `id` int NOT NULL,
  `outfitid` int NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `society_moneywash`
--

CREATE TABLE `society_moneywash` (
  `id` int NOT NULL,
  `identifier` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `society` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `amount` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `identifier` varchar(48) COLLATE utf8mb4_general_ci NOT NULL,
  `firstname` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lastname` varchar(16) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `disabled` tinyint(1) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `play_time` bigint DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'user',
  `sex` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dateofbirth` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `height` int DEFAULT NULL,
  `position` longtext COLLATE utf8mb4_general_ci,
  `is_dead` tinyint(1) DEFAULT '0',
  `job` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'unemployed',
  `job_grade` int DEFAULT '0',
  `accounts` longtext COLLATE utf8mb4_general_ci,
  `inventory` longtext COLLATE utf8mb4_general_ci,
  `loadout` longtext COLLATE utf8mb4_general_ci,
  `metadata` longtext COLLATE utf8mb4_general_ci,
  `skin` longtext COLLATE utf8mb4_general_ci,
  `status` longtext COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `user_licenses`
--

CREATE TABLE `user_licenses` (
  `id` int NOT NULL,
  `type` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` varchar(48) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `addon_account`
--
ALTER TABLE `addon_account`
  ADD PRIMARY KEY (`name`);

--
-- Indeksy dla tabeli `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  ADD KEY `index_addon_account_data_account_name` (`account_name`),
  ADD KEY `owner` (`owner`);

--
-- Indeksy dla tabeli `addon_inventory`
--
ALTER TABLE `addon_inventory`
  ADD PRIMARY KEY (`name`);

--
-- Indeksy dla tabeli `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  ADD KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  ADD KEY `index_addon_inventory_inventory_name` (`inventory_name`);

--
-- Indeksy dla tabeli `datastore`
--
ALTER TABLE `datastore`
  ADD PRIMARY KEY (`name`);

--
-- Indeksy dla tabeli `datastore_data`
--
ALTER TABLE `datastore_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  ADD KEY `index_datastore_data_name` (`name`);

--
-- Indeksy dla tabeli `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Indeksy dla tabeli `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Indeksy dla tabeli `job_grades`
--
ALTER TABLE `job_grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `job_name` (`job_name`);

--
-- Indeksy dla tabeli `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`type`);

--
-- Indeksy dla tabeli `multicharacter_mugshots`
--
ALTER TABLE `multicharacter_mugshots`
  ADD PRIMARY KEY (`identifier`);

--
-- Indeksy dla tabeli `multicharacter_slots`
--
ALTER TABLE `multicharacter_slots`
  ADD PRIMARY KEY (`identifier`) USING BTREE,
  ADD KEY `slots` (`slots`) USING BTREE;

--
-- Indeksy dla tabeli `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`),
  ADD KEY `owner` (`owner`);

--
-- Indeksy dla tabeli `ox_doorlock`
--
ALTER TABLE `ox_doorlock`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `ox_inventory`
--
ALTER TABLE `ox_inventory`
  ADD UNIQUE KEY `owner` (`owner`,`name`);

--
-- Indeksy dla tabeli `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indeksy dla tabeli `player_outfit_codes`
--
ALTER TABLE `player_outfit_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_player_outfit_codes_player_outfits` (`outfitid`);

--
-- Indeksy dla tabeli `society_moneywash`
--
ALTER TABLE `society_moneywash`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`);

--
-- Indeksy dla tabeli `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `addon_account_data`
--
ALTER TABLE `addon_account_data`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `datastore_data`
--
ALTER TABLE `datastore_data`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `job_grades`
--
ALTER TABLE `job_grades`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `ox_doorlock`
--
ALTER TABLE `ox_doorlock`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `player_outfit_codes`
--
ALTER TABLE `player_outfit_codes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `society_moneywash`
--
ALTER TABLE `society_moneywash`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `user_licenses`
--
ALTER TABLE `user_licenses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `addon_account_data`
--
ALTER TABLE `addon_account_data`
  ADD CONSTRAINT `addon_account_data_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `job_grades`
--
ALTER TABLE `job_grades`
  ADD CONSTRAINT `job_grades_ibfk_1` FOREIGN KEY (`job_name`) REFERENCES `jobs` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `multicharacter_mugshots`
--
ALTER TABLE `multicharacter_mugshots`
  ADD CONSTRAINT `multicharacter_mugshots_ibfk_1` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
  ADD CONSTRAINT `owned_vehicles_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `ox_inventory`
--
ALTER TABLE `ox_inventory`
  ADD CONSTRAINT `ox_inventory_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD CONSTRAINT `player_outfits_ibfk_1` FOREIGN KEY (`citizenid`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `player_outfit_codes`
--
ALTER TABLE `player_outfit_codes`
  ADD CONSTRAINT `player_outfit_codes_ibfk_1` FOREIGN KEY (`outfitid`) REFERENCES `player_outfits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `user_licenses`
--
ALTER TABLE `user_licenses`
  ADD CONSTRAINT `user_licenses_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
