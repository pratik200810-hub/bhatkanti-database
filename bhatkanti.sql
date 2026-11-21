-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 21, 2026 at 05:11 PM
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
-- Database: `bhatkanti`
--

-- --------------------------------------------------------

--
-- Table structure for table `attractions`
--

CREATE TABLE `attractions` (
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `visit_duration_minutes` int(11) DEFAULT 60
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attractions`
--

INSERT INTO `attractions` (`attraction_id`, `city_id`, `category_id`, `name`, `description`, `latitude`, `longitude`, `address`, `image_path`, `visit_duration_minutes`) VALUES
(1, 1, 1, 'Shaniwar Wada', NULL, NULL, NULL, NULL, NULL, 90),
(2, 1, 1, 'Aga Khan Palace', NULL, NULL, NULL, NULL, NULL, 60),
(3, 1, 2, 'Pashan Lake', NULL, NULL, NULL, NULL, NULL, 60),
(4, 1, 5, 'Raja Dinkar Kelkar Museum', NULL, NULL, NULL, NULL, NULL, 90),
(5, 1, 1, 'Sinhagad Fort', NULL, NULL, NULL, NULL, NULL, 180);

-- --------------------------------------------------------

--
-- Table structure for table `attraction_opening_hours`
--

CREATE TABLE `attraction_opening_hours` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `day_of_week` tinyint(4) NOT NULL COMMENT '0=Sun 6=Sat',
  `opening_time` time DEFAULT NULL,
  `closing_time` time DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attraction_ticket_types`
--

CREATE TABLE `attraction_ticket_types` (
  `ticket_type_id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `ticket_name` varchar(100) NOT NULL,
  `age_group` enum('adult','child','senior','all') DEFAULT 'all',
  `price` decimal(10,2) NOT NULL,
  `currency` varchar(10) DEFAULT 'INR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `booking_reference` varchar(50) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `trip_id` bigint(20) UNSIGNED DEFAULT NULL,
  `curated_trip_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `booking_status` enum('pending','confirmed','cancelled','completed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_items`
--

CREATE TABLE `booking_items` (
  `item_id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `ticket_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `snapshot_price` decimal(10,2) NOT NULL COMMENT 'price at time of booking',
  `seller_status` enum('pending','confirmed','rejected') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_status_history`
--

CREATE TABLE `booking_status_history` (
  `history_id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `icon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `icon`) VALUES
(1, 'Historical', NULL),
(2, 'Nature', NULL),
(3, 'Religious', NULL),
(4, 'Adventure', NULL),
(5, 'Museum', NULL),
(6, 'Food & Market', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`city_id`, `city_name`, `state`, `latitude`, `longitude`, `is_active`) VALUES
(1, 'Pune', 'Maharashtra', NULL, NULL, 1),
(2, 'Mumbai', 'Maharashtra', NULL, NULL, 1),
(3, 'Bangalore', 'Karnataka', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `curated_trips`
--

CREATE TABLE `curated_trips` (
  `curated_trip_id` bigint(20) UNSIGNED NOT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `duration_days` int(11) DEFAULT 1,
  `estimated_budget` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `curated_trip_stops`
--

CREATE TABLE `curated_trip_stops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `curated_trip_id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `stop_order` int(11) NOT NULL,
  `planned_visit_minutes` int(11) DEFAULT 60
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favourites`
--

CREATE TABLE `favourites` (
  `favourite_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `gateway_order_id` varchar(100) DEFAULT NULL,
  `gateway_payment_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('created','paid','failed') DEFAULT 'created',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `account_status` enum('active','blocked','deleted') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_trips`
--

CREATE TABLE `user_trips` (
  `trip_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `travel_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `budget` decimal(10,2) DEFAULT NULL,
  `consider_weather` tinyint(1) DEFAULT 1,
  `consider_traffic` tinyint(1) DEFAULT 1,
  `trip_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trip_snapshot`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_trip_stops`
--

CREATE TABLE `user_trip_stops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `trip_id` bigint(20) UNSIGNED NOT NULL,
  `attraction_id` bigint(20) UNSIGNED NOT NULL,
  `stop_order` int(11) NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `travel_minutes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attractions`
--
ALTER TABLE `attractions`
  ADD PRIMARY KEY (`attraction_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `attraction_opening_hours`
--
ALTER TABLE `attraction_opening_hours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attraction_id` (`attraction_id`);

--
-- Indexes for table `attraction_ticket_types`
--
ALTER TABLE `attraction_ticket_types`
  ADD PRIMARY KEY (`ticket_type_id`),
  ADD KEY `attraction_id` (`attraction_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD UNIQUE KEY `booking_reference` (`booking_reference`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `curated_trip_id` (`curated_trip_id`);

--
-- Indexes for table `booking_items`
--
ALTER TABLE `booking_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `attraction_id` (`attraction_id`),
  ADD KEY `ticket_type_id` (`ticket_type_id`);

--
-- Indexes for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`city_id`);

--
-- Indexes for table `curated_trips`
--
ALTER TABLE `curated_trips`
  ADD PRIMARY KEY (`curated_trip_id`),
  ADD KEY `city_id` (`city_id`);

--
-- Indexes for table `curated_trip_stops`
--
ALTER TABLE `curated_trip_stops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `curated_trip_id` (`curated_trip_id`),
  ADD KEY `attraction_id` (`attraction_id`);

--
-- Indexes for table `favourites`
--
ALTER TABLE `favourites`
  ADD PRIMARY KEY (`favourite_id`),
  ADD UNIQUE KEY `uniq_user_attraction` (`user_id`,`attraction_id`),
  ADD KEY `attraction_id` (`attraction_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_trips`
--
ALTER TABLE `user_trips`
  ADD PRIMARY KEY (`trip_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `city_id` (`city_id`);

--
-- Indexes for table `user_trip_stops`
--
ALTER TABLE `user_trip_stops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `attraction_id` (`attraction_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attractions`
--
ALTER TABLE `attractions`
  MODIFY `attraction_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `attraction_opening_hours`
--
ALTER TABLE `attraction_opening_hours`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attraction_ticket_types`
--
ALTER TABLE `attraction_ticket_types`
  MODIFY `ticket_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_items`
--
ALTER TABLE `booking_items`
  MODIFY `item_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  MODIFY `history_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `city_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `curated_trips`
--
ALTER TABLE `curated_trips`
  MODIFY `curated_trip_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `curated_trip_stops`
--
ALTER TABLE `curated_trip_stops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favourites`
--
ALTER TABLE `favourites`
  MODIFY `favourite_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_trips`
--
ALTER TABLE `user_trips`
  MODIFY `trip_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_trip_stops`
--
ALTER TABLE `user_trip_stops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attractions`
--
ALTER TABLE `attractions`
  ADD CONSTRAINT `attractions_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`),
  ADD CONSTRAINT `attractions_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `attraction_opening_hours`
--
ALTER TABLE `attraction_opening_hours`
  ADD CONSTRAINT `attraction_opening_hours_ibfk_1` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`) ON DELETE CASCADE;

--
-- Constraints for table `attraction_ticket_types`
--
ALTER TABLE `attraction_ticket_types`
  ADD CONSTRAINT `attraction_ticket_types_ibfk_1` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`) ON DELETE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`trip_id`) REFERENCES `user_trips` (`trip_id`),
  ADD CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`curated_trip_id`) REFERENCES `curated_trips` (`curated_trip_id`);

--
-- Constraints for table `booking_items`
--
ALTER TABLE `booking_items`
  ADD CONSTRAINT `booking_items_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_items_ibfk_2` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`),
  ADD CONSTRAINT `booking_items_ibfk_3` FOREIGN KEY (`ticket_type_id`) REFERENCES `attraction_ticket_types` (`ticket_type_id`);

--
-- Constraints for table `booking_status_history`
--
ALTER TABLE `booking_status_history`
  ADD CONSTRAINT `booking_status_history_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE;

--
-- Constraints for table `curated_trips`
--
ALTER TABLE `curated_trips`
  ADD CONSTRAINT `curated_trips_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`);

--
-- Constraints for table `curated_trip_stops`
--
ALTER TABLE `curated_trip_stops`
  ADD CONSTRAINT `curated_trip_stops_ibfk_1` FOREIGN KEY (`curated_trip_id`) REFERENCES `curated_trips` (`curated_trip_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `curated_trip_stops_ibfk_2` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`);

--
-- Constraints for table `favourites`
--
ALTER TABLE `favourites`
  ADD CONSTRAINT `favourites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favourites_ibfk_2` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);

--
-- Constraints for table `user_trips`
--
ALTER TABLE `user_trips`
  ADD CONSTRAINT `user_trips_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `user_trips_ibfk_2` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`);

--
-- Constraints for table `user_trip_stops`
--
ALTER TABLE `user_trip_stops`
  ADD CONSTRAINT `user_trip_stops_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `user_trips` (`trip_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_trip_stops_ibfk_2` FOREIGN KEY (`attraction_id`) REFERENCES `attractions` (`attraction_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
