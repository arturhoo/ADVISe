-- MySQL dump 10.13  Distrib 5.5.20, for osx10.6 (i386)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	5.5.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `id_ec_atributo_num`
--

DROP TABLE IF EXISTS `id_ec_atributo_num`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_ec_atributo_num` (
  `indice` bigint(20) unsigned NOT NULL,
  `iduniprot` char(6) NOT NULL,
  `data_dep` date NOT NULL,
  `ver_estudo` tinyint(4) unsigned NOT NULL,
  `tipo_mud` tinyint(4) NOT NULL,
  `ec_ant0` smallint(6) NOT NULL,
  `ec_ant1` smallint(6) NOT NULL,
  `ec_ant2` smallint(6) NOT NULL,
  `ec_ant3` smallint(6) NOT NULL,
  `ec_novo0` smallint(6) NOT NULL,
  `ec_novo1` smallint(6) NOT NULL,
  `ec_novo2` smallint(6) NOT NULL,
  `ec_novo3` smallint(6) NOT NULL,
  `prefixo` tinyint(4) NOT NULL,
  `subidas` tinyint(4) NOT NULL,
  `descidas` tinyint(4) NOT NULL,
  `rp_antes` text NOT NULL,
  `oc_antes` text NOT NULL,
  `kw_antes` text NOT NULL,
  `rp_depois` text NOT NULL,
  `oc_depois` text NOT NULL,
  `kw_depois` text NOT NULL,
  PRIMARY KEY (`indice`),
  KEY `ver_estudo+prefixo` (`ver_estudo`,`prefixo`),
  KEY `ver+pre+sub+des+ecant0+ecnovo0` (`ver_estudo`,`prefixo`,`subidas`,`descidas`,`ec_ant0`,`ec_novo0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-04-23  2:01:08
