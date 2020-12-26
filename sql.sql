-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                5.7.29-log - MySQL Community Server (GPL)
-- Server-OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumpar databasstruktur för fivem
CREATE DATABASE IF NOT EXISTS `fivem` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fivem`;

-- Dumpar struktur för tabell fivem.characters_vehicles
CREATE TABLE IF NOT EXISTS `characters_vehicles` (
  `plate` varchar(12) COLLATE utf8mb4_bin NOT NULL,
  `vehicle` longtext COLLATE utf8mb4_bin NOT NULL,
  `owner` varchar(60) COLLATE utf8mb4_bin NOT NULL,
  `currentGarage` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT 'A',
  `impoundedTime` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumpar data för tabell fivem.characters_vehicles: ~0 rows (ungefär)
/*!40000 ALTER TABLE `characters_vehicles` DISABLE KEYS */;
INSERT INTO `characters_vehicles` (`plate`, `vehicle`, `owner`, `currentGarage`, `impoundedTime`) VALUES
	('69420', '{"modSeats":-1,"modDial":-1,"modSideSkirt":-1,"modTank":-1,"modPlateHolder":-1,"modHorns":-1,"modDoorSpeaker":-1,"modDashboard":-1,"modTrimA":-1,"modSteeringWheel":-1,"modFrame":-1,"neonColor":[255,0,255],"tyreSmokeColor":[255,255,255],"health":1000,"modRightFender":-1,"modHood":-1,"pearlescentColor":4,"modFrontWheels":-1,"modAirFilter":-1,"modGrille":-1,"modShifterLeavers":-1,"doors":[false,false,false,false,false,false],"modTurbo":false,"distanceTraveled":1696.6594238281,"modLivery":-1,"modSuspension":-1,"color2":0,"modArmor":-1,"dirtLevel":0.072827115654945,"modVanityPlate":-1,"bodyHealth":1000.0,"modRoof":-1,"wheels":0,"modOrnaments":-1,"color1":1,"plate":"VKR724  ","modWindows":-1,"wheelColor":156,"modSmokeEnabled":1,"modBackWheels":-1,"tyres":[false,false,false,false,false,false,false],"plateIndex":0,"modTrunk":-1,"modSpeakers":-1,"modFender":-1,"engineHealth":1000.0,"neonEnabled":[false,false,false,false],"modStruts":-1,"modTransmission":-1,"modAerials":-1,"modRearBumper":-1,"fuelLevel":71.0,"modArchCover":-1,"modHydrolic":-1,"modEngineBlock":-1,"windows":[false,1,1,false,false,1,1,false,1,false,1,1,1],"modEngine":-1,"modSpoilers":-1,"modXenon":false,"windowTint":-1,"modExhaust":-1,"modTrimB":-1,"modAPlate":-1,"model":108773431,"modFrontBumper":-1,"modBrakes":-1}', '1998-01-01-3011', 'A', ''),
	('VKR724  ', '{"modSeats":-1,"plate":"VKR724  ","modTank":-1,"model":108773431,"pearlescentColor":4,"modGrille":-1,"plateIndex":0,"modTrimB":-1,"modAirFilter":-1,"wheels":0,"modStruts":-1,"modFrontBumper":-1,"neonColor":[255,0,255],"modArmor":-1,"modSmokeEnabled":false,"neonEnabled":[false,false,false,false],"modEngine":-1,"windowTint":-1,"modRearBumper":-1,"modDial":-1,"modDashboard":-1,"modAerials":-1,"modWindows":-1,"modFrontWheels":-1,"engineHealth":1000.0,"modTurbo":false,"modSideSkirt":-1,"modRightFender":-1,"modBackWheels":-1,"dirtLevel":7.0,"modFrame":-1,"doors":[false,false,false,false,false,false],"color2":0,"modBrakes":-1,"modHydrolic":-1,"modRoof":-1,"bodyHealth":1000.0,"modSpoilers":-1,"modVanityPlate":-1,"wheelColor":156,"modXenon":false,"modTrunk":-1,"health":1000,"modArchCover":-1,"modFender":-1,"modSteeringWheel":-1,"modSuspension":-1,"modPlateHolder":-1,"tyreSmokeColor":[255,255,255],"modAPlate":-1,"modHood":-1,"modTransmission":-1,"modExhaust":-1,"windows":[false,1,1,false,false,1,1,1,1,false,1,false,1],"modLivery":-1,"color1":1,"modOrnaments":-1,"fuelLevel":1000.0,"modHorns":-1,"modEngineBlock":-1,"modShifterLeavers":-1,"modSpeakers":-1,"tyres":[false,false,false,false,false,false,false],"modTrimA":-1,"modDoorSpeaker":-1,"distanceTraveled":0.0017013560282066}', '1998-01-01-3011', 'A', '');
/*!40000 ALTER TABLE `characters_vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
