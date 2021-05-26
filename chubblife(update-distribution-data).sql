-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 22, 2021 at 09:15 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 7.4.1

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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertmasterdatacard` (IN `in_cust_id` VARCHAR(100), IN `in_name` VARCHAR(100), IN `in_jeniskartu` VARCHAR(100))  BEGIN 
	insert into `master_data_card`(`CIF_NUMBER`,`CARD_NAME`,`CARD_TYPE`,`CARD_NO`,`LAST_UPDATE`,`CUST_APPID`)
			values(in_cust_id,
			in_name,
			in_jeniskartu,
			in_cust_id,
             NOW(),
           (SELECT CUST_APPID FROM MASTER_CUSTOMER ORDER BY CUST_APPID DESC LIMIT 1));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPreview` (IN `in_cust_id` VARCHAR(100), IN `in_name` VARCHAR(100), IN `in_mphone` VARCHAR(100), IN `in_bphone` VARCHAR(100), IN `in_hphone` VARCHAR(100), IN `in_sex` VARCHAR(100), IN `in_age` VARCHAR(100), IN `in_zipcode` VARCHAR(100), IN `in_jeniskartu` VARCHAR(100))  BEGIN 
  IF ((IFNULL(in_cust_id,'') <> '') 
				OR (IFNULL(in_name,'') <> '') 
				OR (IFNULL(in_mphone,'') <> '')
				OR (IFNULL(in_bphone,'') <> '')
				OR (IFNULL(in_hphone,'') <> '')
				OR (IFNULL(in_sex,'') <> '')
				OR (IFNULL(in_age,'') <> '')
				OR (IFNULL(in_zipcode,'') <> '')
				OR (IFNULL(in_jeniskartu,'') <> '')
				)
	THEN
	insert into `temp_preview_customers`(`cust_id`,`name`,`mphone`,`bphone`,`hphone`,`sex`,`agenow`,`zipcode`,`jenis_kartu`)
			values(
			in_cust_id,
			in_name,
			in_mphone,
			in_bphone,
			in_hphone,
			in_sex,
			in_age,
			in_zipcode,
			in_jeniskartu);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spComboboxDistribution` (IN `in_criteria` VARCHAR(255), IN `in_user` VARCHAR(225), IN `in_product_group` VARCHAR(225), IN `in_campaign_name` VARCHAR(500))  BEGIN
DECLARE vLevel varchar(255);
DECLARE vWhere  varchar(500);
DECLARE vQuery varchar(1000);
 /*---------------------------------------get product group--------------------------------------------------*/ 
		
	IF (in_criteria='product_group_distribution') 
    	THEN 
			(SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
          IF ((vLevel = 'ADMINISTRATOR') OR (vLevel = 'ADMIN'))
    		THEN
			set vWhere = " AND ((DATA_MGR ='')OR(DATA_MGR is NULL)) AND ((DATA_SPV = '')OR(DATA_SPV IS NULL)) ";
		ELSEIF vLevel = 'MANAGER' 	
			THEN
			set vWhere = CONCAT(" AND DATA_MGR = '",in_user,"' AND ((DATA_SPV = '')OR(DATA_SPV IS NULL)) ");
		ELSEIF vLevel = 'SPV'
        	THEN
			set vWhere = CONCAT(" AND DATA_SPV = '",in_user,"' ");
		END  IF;
        
       		SET vQuery =  CONCAT("SELECT DISTINCT JENIS_CUSTOMER from master_customer WHERE 1=1 ",vWhere," ;");
       
           	PREPARE stmt1 FROM vQuery;
	  		EXECUTE stmt1; 
	   		DEALLOCATE PREPARE stmt1; 

    END IF ;


 /*-----------------------------------------get nama campaign------------------------------------------------*/ 
    
	IF (in_criteria='campaign_name_distribution') 
    	THEN 
			(SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
          IF ((vLevel = 'ADMINISTRATOR') OR (vLevel = 'ADMIN'))
    		THEN
			set vWhere = " AND ((DATA_MGR ='')OR(DATA_MGR is NULL)) AND ((DATA_SPV = '')OR(DATA_SPV IS NULL)) ";
		ELSEIF vLevel = 'MANAGER' 	
			THEN
			set vWhere = CONCAT(" AND DATA_MGR = '",in_user,"' AND ((DATA_SPV = '')OR(DATA_SPV IS NULL)) ");
		ELSEIF vLevel = 'SPV'
        	THEN
			set vWhere = CONCAT(" AND DATA_SPV = '",in_user,"' ");
		END  IF;
        
        SET vQuery =  CONCAT("SELECT DISTINCT CAMPAIGN_NAME FROM MASTER_CUSTOMER WHERE 
							 DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(), '%Y-%m-%d') 
                             AND ((AGENT_USERNAME = '')OR(AGENT_USERNAME IS NULL)) 
                             AND (IFNULL(RESULT,'') NOT IN ('Interested','Block')) AND JENIS_CUSTOMER = '",  								     							in_product_group,"' ",vWhere," ORDER BY CAMPAIGN_NAME DESC ;"); 
      
      PREPARE stmt1 FROM vQuery;
	  EXECUTE stmt1; 
	  DEALLOCATE PREPARE stmt1; 

    END IF ;

 /*--------------------------------getstatusdata------------------------------------------------*/ 
 
    	IF (in_criteria='CAMPAIGN_DISTRIBUTION_STATUSDATA') 
    	THEN
       (SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
          IF ((vLevel = 'ADMINISTRATOR') OR (vLevel = 'ADMIN'))
    		THEN
			set vWhere = " AND ((A.DATA_MGR ='')OR(A.DATA_MGR is NULL)) AND ((A.DATA_SPV = '')OR(A.DATA_SPV IS NULL)) ";
		ELSEIF vLevel = 'MANAGER' 	
			THEN
			set vWhere = CONCAT(" AND A.DATA_MGR = '",in_user,"' AND ((A.DATA_SPV = '')OR(A.DATA_SPV IS NULL)) ");
		ELSEIF vLevel = 'SPV'
        	THEN
			set vWhere = CONCAT(" AND A.DATA_SPV = '",in_user,"' ");
		END  IF;
        
        SET vQuery =  CONCAT(" SELECT '---ALL---' AS CBO 
                             UNION ALL 
                             SELECT DISTINCT 
							CASE 
			                   WHEN IFNULL(A.DIAL_STATUS,'')  = '' AND IFNULL(A.RESULT_DETAIL,'') = '' THEN 'Fresh Data'
							   ELSE IFNULL(A.DIAL_STATUS,'')  + '|' + 
				 					CASE 
										WHEN IFNULL(A.DIAL_STATUS,'')  = '' THEN ''
										ELSE IFNULL(A.RESULT_DETAIL,'')
									END  
							END	as CBO		
							FROM MASTER_CUSTOMER as A 
                           WHERE DATE_FORMAT(A.EXPIRE_DATE, '%Y-%m-%d')>= DATE_FORMAT(NOW(), '%Y-%m-%d') 
          					AND ((A.AGENT_USERNAME = '')OR(A.AGENT_USERNAME IS NULL))  AND  (IFNULL(A.RESULT,'') NOT IN ('Interested','Block')) 
                            AND A.CAMPAIGN_NAME = '",in_campaign_name,"' ",vWhere," ;"); 
                  
      
      PREPARE stmt1 FROM vQuery;
	  EXECUTE stmt1; 
	  DEALLOCATE PREPARE stmt1; 

    END IF ;
 /*----------------------------------------------cek filter gender---------------------------------------------------------------*/  
 
 IF (in_criteria='Filter Gender') 
    	THEN
			SELECT DISTINCT(CUST_GENDER)  AS CBO 
            FROM MASTER_CUSTOMER WHERE CAMPAIGN_NAME = in_campaign_name
			AND IFNULL(RESULT,'') NOT IN ('INTERESTED','NOT INTERESTED');

    END IF ;
  /*-------------------------------------------------cek Filter Type Of Card-------------------------------------------------------*/  
  
 
 IF (in_criteria='Filter Type Of Card') 
    	THEN
			SELECT DISTINCT(PRODUCT_NAME)  AS CBO 
            FROM MASTER_CUSTOMER WHERE CAMPAIGN_NAME = in_campaign_name
			AND IFNULL(RESULT,'') NOT IN ('INTERESTED','NOT INTERESTED');

    END IF ;
  /*---------------------------------------------------------------------------------------------------------*/
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetDistribution_Detail` (IN `in_criteria` VARCHAR(255), IN `in_campaign_name` VARCHAR(500), IN `in_user` VARCHAR(225), IN `in_statusdata1` VARCHAR(225), IN `in_statusdata2` VARCHAR(225), IN `in_filter_group` VARCHAR(225), IN `in_value1` VARCHAR(225), IN `in_value2` VARCHAR(225), IN `in_type_card` VARCHAR(225), IN `in_zipcode` VARCHAR(225), IN `in_gender` VARCHAR(225))  BEGIN
DECLARE vLevel varchar(255);
DECLARE vWhere  varchar(500);
DECLARE vWhere2 varchar(500);
DECLARE vWhere3 varchar(100);
DECLARE OrderBy varchar(50);
DECLARE vQuery varchar(1000);

IF (in_criteria='CAMPAIGN_DISTRIBUTION_STATUSDATA_SUMMARY') 
    	THEN
	   (SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
       
          IF ((vLevel = 'ADMINISTRATOR') OR (vLevel = 'ADMIN'))
    		THEN
			set vWhere = " AND ((DATA_MGR ='')OR(DATA_MGR is NULL)) AND ((DATA_SPV = '')OR(DATA_SPV IS NULL)) ";
		  ELSEIF vLevel = 'MANAGER' 	
			THEN
			set vWhere = CONCAT(" AND DATA_MGR = '",in_user,"' AND ((DATA_SPV = '') OR (DATA_SPV IS NULL)) ");
		  ELSEIF vLevel = 'SPV'
        	THEN
			set vWhere = CONCAT(" AND DATA_SPV = '",in_user,"' ");
		  END  IF;
        
       IF in_statusdata1 = '---ALL---'
				THEN
				set vWhere2 = CONCAT(" AND CAMPAIGN_NAME = '",in_campaign_name,"' ");
			ELSEIF in_statusdata1 = 'Fresh Data'
				THEN
					set vWhere2 = CONCAT(" AND CAMPAIGN_NAME = '",in_campaign_name,
															"' AND IFNULL(DIAL_STATUS,'') = '' AND IFNULL(RESULT_DETAIL,'') = '' ");
			ELSE
				set vWhere2 = CONCAT(" AND CAMPAIGN_NAME = '",in_campaign_name,
															"' AND IFNULL(DIAL_STATUS,'') = '",in_statusdata1,
															 "' AND IFNULL(RESULT_DETAIL,'') = '",in_statusdata2,"' ");
	    END  IF;
        
        
        
		IF in_filter_group = '---ALL---'
			THEN
				SET vWhere3 =" ";
		ELSE
			IF in_filter_group ='Age' 
					THEN
						SET vWhere3 =CONCAT(" AND CONVERT(IFNULL(CUST_AGE,0),INT) BETWEEN ",in_value1," AND ",in_value2," ");  
				ELSEIF in_filter_group ='Type Of Card'
					THEN
		
						SET vWhere3 =CONCAT(" AND PRODUCT_NAME = '",in_type_card,"' ");
        ELSEIF in_filter_group ='Zipcode'
					THEN
						SET vWhere3 =CONCAT(" AND CUST_ZIPCODE LIKE '%",in_zipcode,"%' ");
				ELSEIF in_filter_group ='Gender'
					THEN
						SET vWhere3 = CONCAT(" AND CUST_GENDER = '",in_gender,"' ");

			 END IF ;   
         END IF ;
             			
						SET vQuery = CONCAT("SELECT COUNT(*) AS TOTAL_DATA FROM MASTER_CUSTOMER ", 
																" WHERE DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ", 
																" AND IFNULL(AGENT_USERNAME,'') = '' ", 
																 " AND IFNULL(RESULT,'') NOT IN ('Interested','Block') "
																 ,vWhere2,
																 vWhere,
															    vWhere3,
																	" ;"
                             );
			
			
			
			
      	PREPARE stmt1 FROM vQuery;
	  	EXECUTE stmt1; 
	  	DEALLOCATE PREPARE stmt1; 

    END IF ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetDistribution_List` (IN `in_criteria` VARCHAR(255), IN `in_user` VARCHAR(225), IN `in_selected_level` VARCHAR(225), IN `in_campaign_name` VARCHAR(225))  BEGIN

/* test call spGetDistribution_List('DISTRIBUTION','Intan', 'AGENT', 'test')*/
DECLARE vLevel varchar(255);
DECLARE vWhere  varchar(500);
DECLARE vWhere2 varchar(500);
DECLARE vWhere3 varchar(100);
DECLARE OrderBy varchar(50);
DECLARE vQuery varchar(1000);
   (SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
   
   IF in_criteria = 'DISTRIBUTION'
   THEN
   
  		IF vLevel = 'ADMINISTRATOR' OR  @vLevel = 'ADMIN'
        	THEN
				set vWhere2 = ' ' ;
				If in_selected_level = 'AGENT'
					THEN
						set vWhere = " IFNULL(AGENT_USERNAME,'') = master_user_agents.AGENT_USERNAME ";
						set OrderBy = " ORDER BY MANAGER_ID, SPV_ID, AGENT_USERNAME ";
				ELSEIF  in_selected_level = 'SPV'
    				THEN
						set vWhere = " IFNULL(DATA_SPV,'') = master_user_agents.AGENT_USERNAME ";
						set OrderBy = " ORDER BY MANAGER_ID, AGENT_USERNAME ";
    			ELSEIF in_selected_level = 'MANAGER'
					THEN
						set vWhere = " IFNULL(DATA_MGR,'') = master_user_agents.AGENT_USERNAME ";
						set OrderBy = " ORDER BY AGENT_USERNAME ";
			     END IF ;
   
    	ELSEIF vLevel = 'MANAGER'
			THEN
				set vWhere2 = CONCAT(" AND IFNULL(MANAGER_ID,'') = '",in_user, "' ");

				If in_selected_level = 'AGENT'
					THEN
						set vWhere = " IFNULL(AGENT_USERNAME,'') = master_user_agents.AGENT_USERNAME ";
						set OrderBy = " ORDER BY SPV_ID, AGENT_USERNAME ";
				ELSEIF in_selected_level = 'SPV'
					THEN
						set vWhere = " IFNULL(DATA_SPV,'') = master_user_agents.AGENT_USERNAME ";
						set OrderBy = " ORDER BY AGENT_USERNAME ";
				END IF ;
        ELSEIF vLevel = 'SPV'
    		THEN
				IF in_selected_level = 'AGENT'
					THEN
					set vWhere = " IFNULL(AGENT_USERNAME,'') = master_user_agents.AGENT_USERNAME ";
					set vWhere2 = CONCAT(" AND IFNULL(SPV_ID,'') = '",in_user,"' ");	
					set OrderBy = " ORDER BY AGENT_USERNAME ";
			END IF ;

        END IF;

    
     SET vQuery =  CONCAT(" SELECT AGENT_USERNAME ",
                          " ,AGENT_NAME ",
                          " ,0 AS TOTAL_DIST ",
                           ",(SELECT COUNT(*) FROM MASTER_CUSTOMER ",
                           " WHERE CAMPAIGN_NAME = '",in_campaign_name,"' ", 
													 " AND ", vWhere,
                           " AND  DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
													 ") AS LEAD_DATA ",
													"	,SPV_ID AS SPV_ID ",
                          " ,MANAGER_ID AS MANAGER_ID FROM master_user_agents ",
													" WHERE AGENT_LEVEL = '",in_selected_level,
                          "' AND AGENT_STATUS = 'ACTIVE' AND IS_DELETED ='N' ",
                           vWhere2,OrderBy,
													 " ;"
					  ); 
      
      PREPARE stmt1 FROM vQuery;
	  EXECUTE stmt1; 
	  DEALLOCATE PREPARE stmt1; 

   
   END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSaveData_Upload` (IN `in_cust_name_id` VARCHAR(500), IN `in_cust_name` VARCHAR(500), IN `in_cust_phone1` VARCHAR(500), IN `in_cust_phone2` VARCHAR(500), IN `in_cust_phone3` VARCHAR(500), IN `in_cust_gender` VARCHAR(500), IN `in_cust_age` VARCHAR(500), IN `in_cust_zipcode` VARCHAR(500), IN `in_product_name` VARCHAR(500), IN `in_sponsor` VARCHAR(500), IN `in_jenis_customer` VARCHAR(500), IN `in_customer_type` VARCHAR(500), IN `in_customer_type_detail` VARCHAR(500), IN `in_data_card_type` VARCHAR(500), IN `in_campaign_name` VARCHAR(500), IN `in_unlimitexpdate` VARCHAR(500), IN `in_cek_dup_Campaign` VARCHAR(500), IN `in_username` VARCHAR(500), IN `in_id_previewdata` BIGINT, IN `in_bypass_dup_data` VARCHAR(500))  BEGIN
	DECLARE pExist VARCHAR(500);
    DECLARE RangeDupData INT;
    DECLARE CUST_APPID_EXIST VARCHAR(50);
    DECLARE StatusUpload VARCHAR(500);
    DECLARE ExpDataUpload INT;
    DECLARE in_data_mgr VARCHAR(500);
       SET pExist = '';
 
 
    IF (in_cek_dup_Campaign='TRUE') 
     THEN
       IF (EXISTS (select `CUST_APPID` from `master_customer` where CAMPAIGN_NAME=in_campaign_name LIMIT 1))
        		AND in_bypass_dup_data <> 'TRUE'
        THEN
        	SET pExist = 'Exist';
            SET StatusUpload = 'Campaign Name already exist!!';   
			CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									);
        END IF;
    END IF;
    
 	(SELECT MANAGER_ID FROM master_user_agents WHERE AGENT_USERNAME=in_username LIMIT 1) INTO in_data_mgr;

    IF (pExist = '')
      THEN
           SET RangeDupData = 90;
           SET CUST_APPID_EXIST = (SELECT CUST_APPID FROM MASTER_CUSTOMER
								WHERE JENIS_CUSTOMER = in_jenis_customer AND
										DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(), '%Y-%m-%d') AND
										DATEDIFF(NOW(),UPLOAD_DATE) <= RangeDupData
										AND CUST_PHONE1 = in_cust_phone1 ORDER BY CUST_APPID DESC LIMIT 1);
          
           IF (IFNULL(CUST_APPID_EXIST,'') <> '')  AND in_bypass_dup_data = 'FALSE'
              THEN
          	   SET StatusUpload = 'Duplicate!!';
                 
               INSERT INTO `DUPLICATE_DATA` (`CUST_APPID_EXIST`
                                                  ,`CUST_NAME`
                                                  ,`CAMPAIGN_NAME`
                                                  ,`PRODUCT_NAME`
                                                  ,`CUST_TYPE`
                                                  ,`CUST_TYPE_DETAIL`
                                                  ,`DATA_CARD_TYPE`
                                                  ,`CUST_PHONE1`
                                                  ,`RESULT_DETAIL`
                                                  ,`UPLOAD_DATE`
                                                  ,`DUPLICATE_TYPE`
                                                 )
											VALUES (CUST_APPID_EXIST
                                                    ,in_cust_name
                                                    ,in_campaign_name
                                                    ,in_product_name
                                                    ,in_customer_type
                                                    ,in_customer_type_detail
                                                    ,in_data_card_type
                                                    ,in_cust_phone1
                                                    ,''
                                                    ,now()
                                                    ,'DUPLICATE'
                                                   );
                                                   
                    CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									);
                                    
                  
           ELSEIF (exists (SELECT CONTACT_NUMBER FROM MASTER_BLACKLIST_NUMBER 
                           WHERE CONTACT_NUMBER IN (in_cust_phone1,in_cust_phone2,in_cust_phone3) AND STATUS = 'ACTIVE' LIMIT 1))
			   THEN
			    SET StatusUpload = 'Black List Number!!';
            		   CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									);
                                    
            ELSEIF ( ((IFNULL(in_cust_name_id,'') = '') OR (IFNULL(in_cust_name,'') = '')) 
                    OR ((IFNULL(in_cust_phone1,'') = '') AND (IFNULL(in_cust_phone2,'') = '') AND (IFNULL(in_cust_phone3,'') = '')) )
                  -- AND (in_jenis_customer <> 'GAGAL_DEBET')
			THEN	
			 		SET StatusUpload = 'Data Not Complete!!';
                    
                  CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									);
          
           ELSEIF (LENGTH(IFNULL(in_cust_phone1,'')) <= 7) AND (LENGTH(IFNULL(in_cust_phone2,'')) <= 7) 
           				AND (LENGTH(IFNULL(in_cust_phone3,''))<= 7)
                    -- AND (in_jenis_customer <> 'GAGAL_DEBET') AND (in_jenis_customer <> 'REINSTATEMENT')
			THEN 
				SET StatusUpload = 'Invalid Phone Number!!';
                
                CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									); 
          
          
          	ELSE
             IF (in_unlimitexpdate = 'TRUE')
             	THEN
                	set ExpDataUpload = 99999;
             ELSE
             	set ExpDataUpload = 60;
         	 END IF;

         		INSERT INTO `master_customer`(`ID`
                                       	,`UPLOAD_DATE`
                                         ,`EXPIRE_DATE`
                                          ,`JENIS_CUSTOMER`
                                          ,`FLAG_DIAL`
                                          ,`FLAG_SCHEDULE`
                                          ,`FLAG_WAYBILL`
                                          ,`FLAG_QA`
                                          ,`CAMPAIGN_NAME`
                                          ,`DATA_MGR`
                                          ,`CUST_NAME_ID`
                                          ,`CUST_NAME`
                                          ,`CUST_ZIPCODE`
                                          ,`CUST_AGE`
                                          ,`CUST_GENDER`
                                          ,`CUST_PHONE1`
                                          ,`CUST_PHONE2`
                                          ,`CUST_PHONE3`
                                          ,`PRODUCT_NAME`
                                          ,`SPONSOR`
                                          ,`CUSTOMER_TYPE`
                                          ,`CUSTOMER_TYPE_DETAIL`
                                          ,`DATA_CARD_TYPE`
                                         )
         							VALUES(0
 										 ,now()
                                         ,DATE_ADD(NOW(), INTERVAL ExpDataUpload DAY)
                                         ,in_jenis_customer
                                         ,'0'
                                         ,'0'
                                         ,'0'
                                         ,'0'
                                         ,in_campaign_name
                                         ,in_data_mgr
                                         ,in_cust_name_id
                                         ,in_cust_name
                                         ,in_cust_zipcode
                                         ,in_cust_age
                                         ,in_cust_gender
                                         ,in_cust_phone1
                                         ,in_cust_phone2
                                         ,in_cust_phone3
                                         ,in_product_name
                                         ,in_sponsor
                                         ,in_customer_type
                                         ,in_customer_type_detail
                                         ,in_data_card_type
                                    	);
			call insertmasterdatacard(in_cust_name_id, in_cust_name, in_product_name);
		    SET StatusUpload = 'Success Upload Data!!';   
			CALL 	spUploadStatus(in_id_previewdata,
									StatusUpload,in_campaign_name
									);
           END IF;
                                        
    END IF;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spSaveDist_Data` (IN `in_user` VARCHAR(255), IN `in_filter_group` VARCHAR(255), IN `in_lower_age` VARCHAR(225), IN `in_upper_age` VARCHAR(225), IN `in_type_card` VARCHAR(225), IN `in_selected_level` VARCHAR(225), IN `in_statusdata1` VARCHAR(225), IN `in_statusdata2` VARCHAR(225), IN `in_total_dist` VARCHAR(225), IN `in_user_dist` VARCHAR(225), IN `in_campaign_name` VARCHAR(500), IN `in_zipcode` VARCHAR(225), IN `in_gender` VARCHAR(225))  BEGIN
	DECLARE vWhere varchar(500);
	DECLARE vWhere2 varchar(500);
	DECLARE vWhere3 varchar(500);
	DECLARE OrderBy varchar(500);
	DECLARE StatusAssign varchar(500);
	DECLARE Flag_Status varchar(500);
	DECLARE Flag_Dial varchar(500);
-- 	DECLARE vQuery varchar(5000);
-- 	DECLARE vQuery1 varchar(5000);
	
	DECLARE vLevel varchar(255);

	   (SELECT AGENT_LEVEL FROM master_user_agents WHERE AGENT_USERNAME = in_user LIMIT 1) INTO vLevel;
		 
		 /*-- ADD FILTER FUNCTION */
		IF in_filter_group = '---ALL---'
			THEN
				SET vWhere3 =" ";
		ELSE
				IF in_filter_group ='Age' 
					THEN
						SET vWhere3 =  CONCAT(" AND CONVERT(IFNULL(CUST_AGE,0),INT) BETWEEN ",
								in_lower_age, " AND ", in_upper_age,"  ");
						
				ELSEIF in_filter_group ='Type Of Card'
					THEN
						SET vWhere3 =CONCAT(" AND PRODUCT_NAME = '",in_type_card,"' ");
						
				ELSEIF in_filter_group ='Zipcode'
					THEN
						SET vWhere3 =CONCAT(" AND CUST_ZIPCODE LIKE '%",in_zipcode,"%' ");
						
				ELSEIF in_filter_group ='Gender'
					THEN
						SET vWhere3 =CONCAT(" AND CUST_GENDER = '",in_gender,"' ");

			  END IF ;
		  END IF ;
			/*--END OF ADD FILTER FUNCTION */
		 
		 	IF vLevel = 'ADMINISTRATOR'
				THEN
				If in_selected_level = 'AGENT'
							THEN
					IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_ADM_TO_AGENT";
							SET in_statusdata1 = "%%" ;
							SET in_statusdata2 = "%%" ;
					ELSE
						 IF in_statusdata1 = '' and in_statusdata2 = ''
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_ADM_TO_AGENT";
									SET Flag_Status="1" ;
									SET Flag_Dial= "1" ;
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_ADM_TO_AGENT";
									SET Flag_Status= "3" ;
									SET Flag_Dial=  "0" ;	
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
		
		
		       SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																" THEN 'NEW_RE_ASSIGNMENT_ADM_TO_AGENT' ELSE (CASE WHEN IFNULL(DIAL_STATUS,'') = '' ",
																" AND IFNULL(FLAG_STATUS,'') <> '2' THEN 'NEW_ASSIGNMENT_ADM_TO_AGENT' ", 
																" ELSE 'RE_ASSIGNMENT_ADM_TO_AGENT' END) END AS ASSIGN_STATUS, '",in_user,
																"' as alter_BY FROM MASTER_CUSTOMER WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
		
		
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET AGENT_USERNAME = '",in_user_dist,
					"',DATA_SPV = (SELECT SPV_ID FROM master_user_agents WHERE AGENT_USERNAME = '",in_user_dist,
					"' LIMIT 1), DATA_MGR = (SELECT MANAGER_ID FROM master_user_agents WHERE AGENT_USERNAME = '",in_user_dist,
					"' LIMIT 1),  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END , ", 
					"	FLAG_DIAL =  CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '0' ",
											" end "
									" ELSE '0' ",
									" END ",
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");		
	
		
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 
					
--  belum  translate to mysql    	         
-- 					INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
-- 									'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
-- 									'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO AGENT ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','')
				
			ELSEIF in_selected_level = 'SPV'
					THEN
						IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_ADM_TO_SPV";
							SET in_statusdata1 = "%%";
							SET in_statusdata2 = "%%";
					ELSE
						 IF (in_statusdata1 = '' and in_statusdata2 = '')
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_ADM_TO_SPV";
									SET Flag_Status= "1";
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_ADM_TO_SPV";
									SET Flag_Status= "3";
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
		
				
		       SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE ",
																" WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																		" THEN 'NEW_RE_ASSIGNMENT_ADM_TO_SPV' ",
																" ELSE (CASE ",
																				" WHEN IFNULL(DIAL_STATUS,'') = '' AND IFNULL(FLAG_STATUS,'') <> '2' ",
																						" THEN 'NEW_ASSIGNMENT_ADM_TO_SPV' ", 
																				" ELSE 'RE_ASSIGNMENT_ADM_TO_SPV' END) ",
																" END AS ASSIGN_STATUS, '",
																in_user,"' as alter_BY FROM MASTER_CUSTOMER WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
		
						
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET DATA_SPV = '",in_user_dist,
					"' , DATA_MGR = (SELECT MANAGER_ID FROM master_user_agents WHERE AGENT_USERNAME = '",in_user_dist,
					"' LIMIT 1),  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END ", 
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'')  '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");		
	
		
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 
--  belum  translate to mysql       
-- 					INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
-- 									'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
-- 									'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO SPV ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','')
				
					 		
			ELSEIF in_selected_level = 'MANAGER'
					THEN
						IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_ADM_TO_MGR";
							SET in_statusdata1 = "%%";
							SET in_statusdata2 = "%%";
					ELSE
						 IF (in_statusdata1 = '' and in_statusdata2 = '')
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_ADM_TO_MGR";
									SET Flag_Status= "1";
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_ADM_TO_MGR";
									SET Flag_Status= "3";
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
		
				
						SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE ",
																" WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																		" THEN 'NEW_RE_ASSIGNMENT_ADM_TO_MGR' ",
																" ELSE (CASE ",
																				" WHEN IFNULL(DIAL_STATUS,'') = '' AND IFNULL(FLAG_STATUS,'') <> '2' ",
																						" THEN 'NEW_ASSIGNMENT_ADM_TO_MGR' ", 
																				" ELSE 'RE_ASSIGNMENT_ADM_TO_MGR' END) ",
																" END AS ASSIGN_STATUS, '",
																in_user,"' as alter_BY FROM MASTER_CUSTOMER WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
		
						
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET DATA_MGR = '",in_user_dist,
					"' ,  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END ", 
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");
																
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 					
					
--  belum  translate to mysql    
-- 		INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
-- 									'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
-- 									'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO MGR ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','')
					 								
											
		END IF ; 	/* end if in_selected_level dari vlevel adm */
		
	 	ELSEIF vLevel = 'MANAGER'
				THEN
				If in_selected_level = 'AGENT'
							THEN
					IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_MGR_TO_AGENT";
							SET in_statusdata1 = "%%" ;
							SET in_statusdata2 = "%%" ;
					ELSE
						 IF in_statusdata1 = '' and in_statusdata2 = ''
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_MGR_TO_AGENT";
									SET Flag_Status="1" ;
									SET Flag_Dial= "1" ;
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_MGR_TO_AGENT";
									SET Flag_Status= "3" ;
									SET Flag_Dial=  "0" ;	
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
		
		
		       SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE ",
																		" WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																			" THEN 'NEW_RE_ASSIGNMENT_MGR_TO_AGENT' ",
																" ELSE (CASE ",
																			" WHEN IFNULL(DIAL_STATUS,'') = '' AND IFNULL(FLAG_STATUS,'') <> '2' ",
																				" THEN 'NEW_ASSIGNMENT_MGR_TO_AGENT' ", 
																			" ELSE 'RE_ASSIGNMENT_MGR_TO_AGENT' END) ",
																" END AS ASSIGN_STATUS, '",in_user,
																"' as alter_BY FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '",in_user,"' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
					
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET AGENT_USERNAME = '",in_user_dist,
					"',DATA_SPV = (SELECT SPV_ID FROM master_user_agents WHERE AGENT_USERNAME = '",in_user_dist,
					"' LIMIT 1),  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END , ", 
					"	FLAG_DIAL =  CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '0' ",
											" end "
									" ELSE '0' ",
									" END ",
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '",in_user,"' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");		
		
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 
--  belum  translate to mysql    
-- 					INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
-- 									'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
-- 									'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO AGENT ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','')
-- 		
			ELSEIF in_selected_level = 'SPV'
					THEN
						IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_MGR_TO_SPV";
							SET in_statusdata1 = "%%";
							SET in_statusdata2 = "%%";
					ELSE
						 IF (in_statusdata1 = '' and in_statusdata2 = '')
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_MGR_TO_SPV";
									SET Flag_Status= "1";
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_MGR_TO_SPV";
									SET Flag_Status= "3";
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
					
				
		       SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE ",
																" WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																		" THEN 'NEW_RE_ASSIGNMENT_MGR_TO_SPV' ",
																" ELSE (CASE ",
																				" WHEN IFNULL(DIAL_STATUS,'') = '' AND IFNULL(FLAG_STATUS,'') <> '2' ",
																						" THEN 'NEW_ASSIGNMENT_MGR_TO_SPV' ", 
																				" ELSE 'RE_ASSIGNMENT_MGR_TO_SPV' END) ",
																" END AS ASSIGN_STATUS, '",
																in_user,"' as alter_BY FROM MASTER_CUSTOMER WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '",in_user,"' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
		
		
						
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET DATA_SPV = '",in_user_dist,
					"',  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END ", 
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_MGR,'') = '",in_user,"' AND IFNULL(DATA_SPV,'') ='' ",
																" AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");			
		
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 
--  belum  translate to mysql    
-- 					INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
-- 									'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
-- 									'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO SPV ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','')
					 											
		END IF ; 	/* end if in_selected_level dari vlevel MANAGER */		
		
		
		
		 	ELSEIF vLevel = 'SPV'
				THEN
				If in_selected_level = 'AGENT'
							THEN
					IF in_statusdata1 = '---ALL---'
						THEN
							SET StatusAssign = "NEW_RE_ALL_ASSIGNMENT_SPV_TO_AGENT";
							SET in_statusdata1 = "%%" ;
							SET in_statusdata2 = "%%" ;
					ELSE
						 IF in_statusdata1 = '' and in_statusdata2 = ''
								THEN
									SET StatusAssign = "NEW_ASSIGNMENT_SPV_TO_AGENT";
									SET Flag_Status="1" ;
									SET Flag_Dial= "1" ;
							ELSE
									SET StatusAssign = "RE_ASSIGNMENT_SPV_TO_AGENT";
									SET Flag_Status= "3" ;
									SET Flag_Dial=  "0" ;	
								END IF; 	/* end if in_statusdata1 = '' and in_statusdata2 = ''*/
						END IF; 	/* end if in_statusdata1*/
		
		       SET @vQuery = CONCAT(" INSERT INTO DATA_ASSIGNMENT (ASSIGN_DATE,ID_MASTER,CUST_APPID ", 
															  ",AGENT_USERNAME,AGENT_USERNAME_TO,ASSIGN_STATUS,CREATE_BY) ",
																" SELECT  NOW() AS ASSIGN_DATE,ID,CUST_APPID, '",in_user_dist,
																"' AS AGENT_USERNAME, '' AS AGENT_USERNAME_TO, ", 
																" CASE ",
																		" WHEN IFNULL(DIAL_STATUS,'') = '' and IFNULL(FLAG_STATUS,'') = '2' ",
																			" THEN 'NEW_RE_ASSIGNMENT_SPV_TO_AGENT' ",
																" ELSE (CASE ",
																			" WHEN IFNULL(DIAL_STATUS,'') = '' AND IFNULL(FLAG_STATUS,'') <> '2' ",
																				" THEN 'NEW_ASSIGNMENT_SPV_TO_AGENT' ", 
																			" ELSE 'RE_ASSIGNMENT_SPV_TO_AGENT' END) ",
																" END AS ASSIGN_STATUS, '",in_user,
																"' as alter_BY FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_SPV,'') ='",in_user,
																"' AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,
																" ;");
					PREPARE stmt FROM @vQuery;
					EXECUTE stmt; 
					DEALLOCATE PREPARE stmt; 
					
					
					SET @vQuery1 = CONCAT(" UPDATE MASTER_CUSTOMER SET AGENT_USERNAME = '",in_user_dist,
					"',  DISTRIBUTE_DATE = NOW(), ", 
					" FLAG_STATUS = CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '3' ",
											" END ",
									" ELSE '3' ",
									 " END , ", 
					"	FLAG_DIAL =  CASE IFNULL(DIAL_STATUS,'') ",
									"	WHEN '' THEN ",
										"	CASE IFNULL(RESULT_DETAIL,'') ",
											"	WHEN '' THEN '1' ",
											"	ELSE '0' ",
											" end "
									" ELSE '0' ",
									" END ",
					" WHERE CUST_APPID IN (SELECT * FROM (SELECT CUST_APPID FROM MASTER_CUSTOMER ",
																" WHERE IFNULL(USER_LOCK,'') = '' ",
																" AND DATE_FORMAT(EXPIRE_DATE, '%Y-%m-%d')>=DATE_FORMAT(NOW(),'%Y-%m-%d') ",
																" AND IFNULL(RESULT,'') NOT IN ('Interested','Block') AND CAMPAIGN_NAME = '",
																in_campaign_name, "' AND IFNULL(DATA_SPV,'') ='",in_user,
																"' AND IFNULL(AGENT_USERNAME,'') = '' AND IFNULL(DIAL_STATUS,'') LIKE '", 
																in_statusdata1, "' AND IFNULL(RESULT_DETAIL,'') LIKE '",in_statusdata2,"' ",  
																vWhere3," ORDER BY CUST_APPID LIMIT ",in_total_dist,") AS top) ;");		
		
		
					PREPARE stmt1 FROM @vQuery1;
					EXECUTE stmt1; 
					DEALLOCATE PREPARE stmt1; 
--  belum  translate to mysql    
-- 				INSERT INTO EVENT_AUDIT_TRAIL Values(GETDATE(), @AGENT_USERNAME, 
--                    'MASTER_CUSTOMER', 'DISTRIBUTION DATA', @Data7, 
--           'DISTRIBUTION CAMPAIGN_NAME : ' + @Data3 + ' TO AGENT ' + @Data1 + ' TOTAL DATA : ' + @Data2,'','') 		
		
		END IF ; 	/* end if in_selected_level dari vlevel SPV */		
		END IF ;  /* end if akhirr vLevel =*/ 
		 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUploadStatus` (IN `in_id_previewdata` BIGINT, IN `StatusUpload` VARCHAR(500), IN `campaign_name` VARCHAR(500))  BEGIN
		  
			UPDATE `temp_preview_customers` SET 				`status_upload` = StatusUpload,
            `nama_campaign` = campaign_name
			WHERE id=in_id_previewdata;      
END$$

DELIMITER ;

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
-- Table structure for table `data_assignment`
--

CREATE TABLE `data_assignment` (
  `ID` bigint(20) NOT NULL,
  `ASSIGN_DATE` datetime DEFAULT NULL,
  `ID_MASTER` int(11) DEFAULT NULL,
  `CUST_APPID` int(11) DEFAULT NULL,
  `AGENT_USERNAME` varchar(50) DEFAULT NULL,
  `AGENT_USERNAME_TO` varchar(50) DEFAULT NULL,
  `ASSIGN_STATUS` varchar(50) DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `data_assignment`
--

INSERT INTO `data_assignment` (`ID`, `ASSIGN_DATE`, `ID_MASTER`, `CUST_APPID`, `AGENT_USERNAME`, `AGENT_USERNAME_TO`, `ASSIGN_STATUS`, `CREATE_BY`) VALUES
(154, '2021-05-21 15:59:12', 0, 42, 'tofan', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(155, '2021-05-21 16:04:12', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_SPV_TO_AGENT', 'tofan'),
(156, '2021-05-22 13:44:43', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_MGR_TO_AGENT', 'INTAN'),
(157, '2021-05-22 13:46:42', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_MGR_TO_AGENT', 'INTAN'),
(158, '2021-05-22 13:56:16', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_MGR_TO_AGENT', 'Intan'),
(159, '2021-05-22 18:41:09', 0, 42, 'Budi', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(160, '2021-05-22 18:41:10', 0, 43, 'Tofan', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(161, '2021-05-22 19:10:38', 0, 42, 'Budi', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(162, '2021-05-22 19:10:38', 0, 43, 'Budi', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(163, '2021-05-22 19:10:38', 0, 44, 'Budi', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(164, '2021-05-23 00:17:16', 0, 42, 'Tofan', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(165, '2021-05-23 00:19:40', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_SPV_TO_AGENT', 'Tofan'),
(166, '2021-05-23 01:48:02', 0, 42, 'Tofan', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(167, '2021-05-23 01:51:08', 0, 43, 'Tofan', '', 'NEW_ASSIGNMENT_MGR_TO_SPV', 'Intan'),
(168, '2021-05-23 01:53:01', 0, 42, 'Gerung', '', 'NEW_ASSIGNMENT_SPV_TO_AGENT', 'Tofan');

-- --------------------------------------------------------

--
-- Table structure for table `duplicate_data`
--

CREATE TABLE `duplicate_data` (
  `ID` bigint(20) NOT NULL,
  `CUST_APPID_EXIST` bigint(20) DEFAULT NULL,
  `CUST_NAME` varchar(500) DEFAULT NULL,
  `CAMPAIGN_NAME` varchar(500) DEFAULT NULL,
  `PRODUCT_NAME` varchar(500) DEFAULT NULL,
  `CUST_TYPE` varchar(500) DEFAULT NULL,
  `CUST_TYPE_DETAIL` varchar(500) DEFAULT NULL,
  `DATA_CARD_TYPE` varchar(500) DEFAULT NULL,
  `CUST_PHONE1` varchar(500) DEFAULT NULL,
  `RESULT_DETAIL` varchar(500) DEFAULT NULL,
  `UPLOAD_DATE` datetime DEFAULT NULL,
  `DUPLICATE_TYPE` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `duplicate_data`
--

INSERT INTO `duplicate_data` (`ID`, `CUST_APPID_EXIST`, `CUST_NAME`, `CAMPAIGN_NAME`, `PRODUCT_NAME`, `CUST_TYPE`, `CUST_TYPE_DETAIL`, `DATA_CARD_TYPE`, `CUST_PHONE1`, `RESULT_DETAIL`, `UPLOAD_DATE`, `DUPLICATE_TYPE`) VALUES
(1, 3, 'nama5', 'tess', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 12:47:55', 'DUPLICATE'),
(2, 4, 'nama6', 'tess', 'VISAKUNING', 'SAVING', 'REGULAR', 'SILVER', '123456788888', '', '2021-05-13 12:47:55', 'DUPLICATE'),
(3, 3, 'nama5', 'tes', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 12:52:59', 'DUPLICATE'),
(4, 4, 'nama6', 'tes', 'VISAKUNING', 'SAVING', 'REGULAR', 'SILVER', '123456788888', '', '2021-05-13 12:53:00', 'DUPLICATE'),
(5, 3, 'nama5', 'tes1', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 13:29:35', 'DUPLICATE'),
(6, 4, 'nama6', 'tes1', 'VISAKUNING', 'SAVING', 'REGULAR', 'SILVER', '123456788888', '', '2021-05-13 13:29:36', 'DUPLICATE'),
(7, 3, 'nama5', 'dd', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 14:36:17', 'DUPLICATE'),
(8, 4, 'nama6', 'dd', 'VISAKUNING', 'SAVING', 'REGULAR', 'SILVER', '123456788888', '', '2021-05-13 14:36:17', 'DUPLICATE'),
(9, 5, 'nama5', 'gh', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 14:46:20', 'DUPLICATE'),
(10, 6, 'nama6', 'gh', 'VISAKUNING', 'SAVING', 'REGULAR', 'SILVER', '123456788888', '', '2021-05-13 14:46:20', 'DUPLICATE'),
(11, 5, 'nama5', 'kk', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 14:47:11', 'DUPLICATE'),
(12, 5, 'nama5', 'jj', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '62816888888', '', '2021-05-13 14:53:29', 'DUPLICATE'),
(38, 34, 'nama7', 'test3', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888888', '', '2021-05-15 12:20:54', 'DUPLICATE'),
(39, 38, 'nama7', 'bbbb', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888888', '', '2021-05-15 12:23:51', 'DUPLICATE'),
(40, 42, 'nama7', 'test', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888888', '', '2021-05-15 12:29:14', 'DUPLICATE'),
(41, 42, 'nama5', 'tt', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888888', '', '2021-05-15 12:32:53', 'DUPLICATE'),
(42, 43, 'nama6', 'tt', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888998', '', '2021-05-15 12:32:54', 'DUPLICATE'),
(43, 42, 'nama7', 'tt', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888888888', '', '2021-05-15 12:32:54', 'DUPLICATE'),
(44, 44, 'nama9', 'tt', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08889255555', '', '2021-05-15 12:32:54', 'DUPLICATE'),
(45, 45, 'nama5', 'gg', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888876755', '', '2021-05-15 23:07:41', 'DUPLICATE'),
(46, 46, 'nama88', 'test3', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888876777', '', '2021-05-18 15:12:49', 'DUPLICATE'),
(47, 47, 'nama99', 'bypass', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888879999', '', '2021-05-18 23:29:44', 'DUPLICATE'),
(48, 48, 'nama99', 'bypass 2', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888879999', '', '2021-05-18 23:53:25', 'DUPLICATE'),
(49, 51, 'nama99', 'tess', 'VISAMERAH', 'SAVING', 'REGULAR', 'SILVER', '08888879999', '', '2021-05-19 00:29:01', 'DUPLICATE');

-- --------------------------------------------------------

--
-- Table structure for table `event_audit_trail`
--

CREATE TABLE `event_audit_trail` (
  `ID` bigint(20) NOT NULL,
  `EVENT_TIME` datetime DEFAULT NULL,
  `AGENT_USERNAME` varchar(50) DEFAULT NULL,
  `EVENT_TABLE` varchar(50) DEFAULT NULL,
  `EVENT_STATUS` varchar(50) DEFAULT NULL,
  `EVENT_OPERATION` varchar(50) DEFAULT NULL,
  `EVENT_DESCRIPTION` varchar(500) NOT NULL,
  `FAILURE_AMOUNT` varchar(50) DEFAULT NULL,
  `BLOCKED_AMOUNT` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
-- Table structure for table `master_blacklist_number`
--

CREATE TABLE `master_blacklist_number` (
  `ID` bigint(20) NOT NULL,
  `CONTACT_NUMBER` varchar(50) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL,
  `REMARKS` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_blacklist_number`
--

INSERT INTO `master_blacklist_number` (`ID`, `CONTACT_NUMBER`, `NAME`, `STATUS`, `REMARKS`) VALUES
(0, '08888866666', 'urut', 'ACTIVE', 'BLOCKED');

-- --------------------------------------------------------

--
-- Table structure for table `master_customer`
--

CREATE TABLE `master_customer` (
  `CUST_APPID` bigint(20) NOT NULL,
  `ID` int(11) DEFAULT NULL,
  `UPLOAD_DATE` datetime DEFAULT NULL,
  `EXPIRE_DATE` datetime DEFAULT NULL,
  `DISTRIBUTE_DATE` datetime DEFAULT NULL,
  `LASTUPDATE_DATE` datetime DEFAULT NULL,
  `LASTCALL_DATE` datetime DEFAULT NULL,
  `AGENT_USERNAME` varchar(25) DEFAULT NULL,
  `RESULT` varchar(50) DEFAULT NULL,
  `RESULT_DETAIL` varchar(50) DEFAULT NULL,
  `DIAL_STATUS` varchar(50) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  `JENIS_CUSTOMER` varchar(20) DEFAULT NULL,
  `FLAG_DIAL` varchar(5) DEFAULT NULL,
  `FLAG_SCHEDULE` varchar(5) DEFAULT NULL,
  `DATE_SCHEDULE` datetime DEFAULT NULL,
  `TIME_SCHEDULE` varchar(11) DEFAULT NULL,
  `REMARKS_SCHEDULE` varchar(50) DEFAULT NULL,
  `REMARKS_NO` varchar(50) DEFAULT NULL,
  `FLAG_PRINT` varchar(5) DEFAULT NULL,
  `DATE_PRINT` datetime DEFAULT NULL,
  `FLAG_FAX` varchar(5) DEFAULT NULL,
  `DATE_FAX` datetime DEFAULT NULL,
  `FLAG_WAYBILL` varchar(5) DEFAULT NULL,
  `DATE_WAYBILL` datetime DEFAULT NULL,
  `REMARKS_WAYBILL` varchar(50) DEFAULT NULL,
  `FLAG_QA` varchar(50) DEFAULT NULL,
  `REASON_QA_DETAIL` varchar(50) DEFAULT NULL,
  `TEAM_QA` varchar(50) DEFAULT NULL,
  `DATE_QA` datetime DEFAULT NULL,
  `REMARKS_QA` varchar(500) DEFAULT NULL,
  `FLAG_SPV` varchar(50) DEFAULT NULL,
  `DATE_SPV` datetime DEFAULT NULL,
  `REMARKS_SPV` varchar(50) DEFAULT NULL,
  `FLAG_OVERRIDE` varchar(50) DEFAULT NULL,
  `STATUS_DATA` varchar(50) DEFAULT NULL,
  `DATE_PROCESS` datetime DEFAULT NULL,
  `CAMPAIGN_NAME` varchar(50) DEFAULT NULL,
  `DATA_MGR` varchar(50) DEFAULT NULL,
  `DATA_SPV` varchar(50) DEFAULT NULL,
  `BLOCK_DATA` varchar(50) DEFAULT NULL,
  `USER_LOCK` varchar(50) DEFAULT NULL,
  `CUST_NAME_ID` varchar(500) DEFAULT NULL,
  `CUST_NAME` varchar(500) DEFAULT NULL,
  `CUST_ADDRESS` varchar(500) DEFAULT NULL,
  `CUST_CITY` varchar(500) DEFAULT NULL,
  `CUST_PROVINCE` varchar(500) DEFAULT NULL,
  `CUST_ZIPCODE` varchar(500) DEFAULT NULL,
  `CUST_POB` varchar(500) DEFAULT NULL,
  `CUST_DOB` datetime DEFAULT NULL,
  `CUST_AGE` varchar(500) DEFAULT NULL,
  `POLICY_NO` varchar(500) DEFAULT NULL,
  `CUST_ID_NO` varchar(500) DEFAULT NULL,
  `CUST_GENDER` varchar(10) DEFAULT NULL,
  `CUST_RELIGION` varchar(500) DEFAULT NULL,
  `CUST_MARITAL` varchar(500) DEFAULT NULL,
  `CUST_JOB` varchar(500) DEFAULT NULL,
  `CUST_PHONE1` varchar(500) DEFAULT NULL,
  `CUST_PHONE2` varchar(500) DEFAULT NULL,
  `CUST_PHONE3` varchar(500) DEFAULT NULL,
  `CUST_PHONE4` varchar(500) DEFAULT NULL,
  `PRODUCT_NAME` varchar(500) DEFAULT NULL,
  `TOTAL_PREMIUM` varchar(500) DEFAULT NULL,
  `SUM_ASSURED` varchar(500) DEFAULT NULL,
  `PAY_FREQ` varchar(500) DEFAULT NULL,
  `FLAG_PREMIUM` varchar(500) DEFAULT NULL,
  `HOME_PHONE_PREFIX` varchar(50) DEFAULT NULL,
  `HOME_PHONE` varchar(50) DEFAULT NULL,
  `OFFICE_PHONE_PREFIX` varchar(50) DEFAULT NULL,
  `OFFICE_PHONE` varchar(50) DEFAULT NULL,
  `OFFICE_EXT` varchar(50) DEFAULT NULL,
  `HANDPHONE_1_PREFIX` varchar(50) DEFAULT NULL,
  `HANDPHONE_1` varchar(50) DEFAULT NULL,
  `HANDPHONE_2_PREFIX` varchar(50) DEFAULT NULL,
  `HANDPHONE_2` varchar(50) DEFAULT NULL,
  `FAX_NO_PREFIX` varchar(50) DEFAULT NULL,
  `FAX_NO` varchar(50) DEFAULT NULL,
  `CONTACT_NO` varchar(50) DEFAULT NULL,
  `FLAG_STATUS` char(5) CHARACTER SET utf8 DEFAULT NULL,
  `SPONSOR` varchar(50) DEFAULT NULL,
  `CUSTOMER_TYPE` varchar(50) DEFAULT NULL,
  `CUSTOMER_TYPE_DETAIL` varchar(50) DEFAULT NULL,
  `DATA_CARD_TYPE` varchar(50) DEFAULT NULL,
  `CUST_REF_GE` varchar(500) DEFAULT NULL,
  `CUST_REF_ID` varchar(50) DEFAULT NULL,
  `CUST_LEVEL` varchar(50) DEFAULT NULL,
  `PRODUCT_ID` varchar(50) DEFAULT NULL,
  `BASE_NAME` varchar(50) DEFAULT NULL,
  `CUST_NAME_KANTOR` varchar(50) DEFAULT NULL,
  `CUST_ADDRESS_KANTOR1` varchar(50) DEFAULT NULL,
  `CUST_ADDRESS_KANTOR2` varchar(50) DEFAULT NULL,
  `CUST_ADDRESS_KANTOR3` varchar(50) DEFAULT NULL,
  `CUST_ADDRESS_KANTOR4` varchar(50) DEFAULT NULL,
  `CUST_KOTA_KANTOR` varchar(50) DEFAULT NULL,
  `CUST_ZIPCODE_KANTOR` varchar(50) DEFAULT NULL,
  `CUST_CARD_HOLDER_NAME` varchar(50) DEFAULT NULL,
  `CUST_CARD_NO` varchar(50) DEFAULT NULL,
  `CUST_CARD_EXPIRY` varchar(50) DEFAULT NULL,
  `CUST_KAT_CARD` varchar(50) DEFAULT NULL,
  `FLAG_RECYCLED` varchar(50) DEFAULT NULL,
  `CREATE_BY` varchar(50) DEFAULT NULL,
  `EDIT_BY` varchar(50) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `EDIT_DATE` datetime DEFAULT NULL,
  `CUST_SEND_BACK` varchar(50) DEFAULT NULL,
  `CUST_SEND_BACK_TIME` datetime DEFAULT NULL,
  `TYPE_DATE` varchar(50) DEFAULT NULL,
  `BSK_PP` varchar(500) DEFAULT NULL,
  `REMARKS_SPV_DETAIL` varchar(50) DEFAULT NULL,
  `FLAG_MGR` varchar(50) DEFAULT NULL,
  `DATE_MGR` datetime DEFAULT NULL,
  `REMARKS_MGR` varchar(500) DEFAULT NULL,
  `REMARKS_MGR_DETAIL` varchar(50) DEFAULT NULL,
  `TGL_ISSUED` varchar(10) DEFAULT NULL,
  `TGL_MULAS` varchar(10) DEFAULT NULL,
  `TGL_LAPSE` varchar(10) DEFAULT NULL,
  `PLAN` varchar(20) DEFAULT NULL,
  `JENIS_PLAN` varchar(20) DEFAULT NULL,
  `CARA_BAYAR` varchar(20) DEFAULT NULL,
  `PREMI_TERTUNGGAK` varchar(20) DEFAULT NULL,
  `INSTALLMENT_TERTUNGGAK` varchar(20) DEFAULT NULL,
  `NO_REK` varchar(30) DEFAULT NULL,
  `STATUS_DEBET` varchar(30) DEFAULT NULL,
  `HEIGHT_CM` varchar(20) DEFAULT NULL,
  `WEIGHT_KG` varchar(20) DEFAULT NULL,
  `CUST_ADDRESS2` varchar(500) DEFAULT NULL,
  `RESULT_HIERARCHY` varchar(50) DEFAULT NULL,
  `FLAG_HIERARCHY` char(5) CHARACTER SET utf8 DEFAULT NULL,
  `CUST_COMPANY` varchar(100) DEFAULT NULL,
  `CUST_INFOLEVEL` varchar(100) DEFAULT NULL,
  `CUST_EMAIL` varchar(50) DEFAULT NULL,
  `CUST_ADDRESS3` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `master_customer`
--

INSERT INTO `master_customer` (`CUST_APPID`, `ID`, `UPLOAD_DATE`, `EXPIRE_DATE`, `DISTRIBUTE_DATE`, `LASTUPDATE_DATE`, `LASTCALL_DATE`, `AGENT_USERNAME`, `RESULT`, `RESULT_DETAIL`, `DIAL_STATUS`, `NOTES`, `JENIS_CUSTOMER`, `FLAG_DIAL`, `FLAG_SCHEDULE`, `DATE_SCHEDULE`, `TIME_SCHEDULE`, `REMARKS_SCHEDULE`, `REMARKS_NO`, `FLAG_PRINT`, `DATE_PRINT`, `FLAG_FAX`, `DATE_FAX`, `FLAG_WAYBILL`, `DATE_WAYBILL`, `REMARKS_WAYBILL`, `FLAG_QA`, `REASON_QA_DETAIL`, `TEAM_QA`, `DATE_QA`, `REMARKS_QA`, `FLAG_SPV`, `DATE_SPV`, `REMARKS_SPV`, `FLAG_OVERRIDE`, `STATUS_DATA`, `DATE_PROCESS`, `CAMPAIGN_NAME`, `DATA_MGR`, `DATA_SPV`, `BLOCK_DATA`, `USER_LOCK`, `CUST_NAME_ID`, `CUST_NAME`, `CUST_ADDRESS`, `CUST_CITY`, `CUST_PROVINCE`, `CUST_ZIPCODE`, `CUST_POB`, `CUST_DOB`, `CUST_AGE`, `POLICY_NO`, `CUST_ID_NO`, `CUST_GENDER`, `CUST_RELIGION`, `CUST_MARITAL`, `CUST_JOB`, `CUST_PHONE1`, `CUST_PHONE2`, `CUST_PHONE3`, `CUST_PHONE4`, `PRODUCT_NAME`, `TOTAL_PREMIUM`, `SUM_ASSURED`, `PAY_FREQ`, `FLAG_PREMIUM`, `HOME_PHONE_PREFIX`, `HOME_PHONE`, `OFFICE_PHONE_PREFIX`, `OFFICE_PHONE`, `OFFICE_EXT`, `HANDPHONE_1_PREFIX`, `HANDPHONE_1`, `HANDPHONE_2_PREFIX`, `HANDPHONE_2`, `FAX_NO_PREFIX`, `FAX_NO`, `CONTACT_NO`, `FLAG_STATUS`, `SPONSOR`, `CUSTOMER_TYPE`, `CUSTOMER_TYPE_DETAIL`, `DATA_CARD_TYPE`, `CUST_REF_GE`, `CUST_REF_ID`, `CUST_LEVEL`, `PRODUCT_ID`, `BASE_NAME`, `CUST_NAME_KANTOR`, `CUST_ADDRESS_KANTOR1`, `CUST_ADDRESS_KANTOR2`, `CUST_ADDRESS_KANTOR3`, `CUST_ADDRESS_KANTOR4`, `CUST_KOTA_KANTOR`, `CUST_ZIPCODE_KANTOR`, `CUST_CARD_HOLDER_NAME`, `CUST_CARD_NO`, `CUST_CARD_EXPIRY`, `CUST_KAT_CARD`, `FLAG_RECYCLED`, `CREATE_BY`, `EDIT_BY`, `CREATE_DATE`, `EDIT_DATE`, `CUST_SEND_BACK`, `CUST_SEND_BACK_TIME`, `TYPE_DATE`, `BSK_PP`, `REMARKS_SPV_DETAIL`, `FLAG_MGR`, `DATE_MGR`, `REMARKS_MGR`, `REMARKS_MGR_DETAIL`, `TGL_ISSUED`, `TGL_MULAS`, `TGL_LAPSE`, `PLAN`, `JENIS_PLAN`, `CARA_BAYAR`, `PREMI_TERTUNGGAK`, `INSTALLMENT_TERTUNGGAK`, `NO_REK`, `STATUS_DEBET`, `HEIGHT_CM`, `WEIGHT_KG`, `CUST_ADDRESS2`, `RESULT_HIERARCHY`, `FLAG_HIERARCHY`, `CUST_COMPANY`, `CUST_INFOLEVEL`, `CUST_EMAIL`, `CUST_ADDRESS3`) VALUES
(42, 0, '2021-05-15 12:29:13', '2021-07-14 12:29:13', '2021-05-23 01:53:01', NULL, NULL, 'Gerung', NULL, NULL, NULL, NULL, 'ALL', '1', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'test', 'Intan', 'Tofan', NULL, NULL, '5', 'nama5', NULL, NULL, NULL, '1245', NULL, NULL, '38', NULL, NULL, 'L', NULL, NULL, NULL, '08888888888', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(43, 0, '2021-05-15 12:29:13', '2021-07-14 12:29:13', '2021-05-23 01:51:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'test', 'Intan', 'Tofan', NULL, NULL, '6', 'nama6', NULL, NULL, NULL, '1246', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888888998', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 0, '2021-05-15 12:29:14', '2021-07-14 12:29:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'test', 'Intan', NULL, NULL, NULL, '9', 'nama9', NULL, NULL, NULL, '1249', NULL, NULL, '42', NULL, NULL, 'P', NULL, NULL, NULL, '08889255555', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(45, 0, '2021-05-15 12:41:16', '2295-02-27 12:41:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'test4', 'Intan', NULL, NULL, NULL, '5', 'nama5', NULL, NULL, NULL, '1245', NULL, NULL, '38', NULL, NULL, 'P', NULL, NULL, NULL, '08888876755', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(46, 0, '2021-05-15 23:08:44', '2021-07-14 23:08:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hh', 'Intan', NULL, NULL, NULL, '5', 'nama88', NULL, NULL, NULL, '1245', NULL, NULL, '38', NULL, NULL, 'L', NULL, NULL, NULL, '08888876777', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(47, 0, '2021-05-18 17:27:22', '2021-07-17 17:27:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tess66', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(48, 0, '2021-05-18 23:29:54', '2021-07-17 23:29:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bypass', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(50, 0, '2021-05-19 00:05:28', '2021-07-18 00:05:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tes user', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(51, 0, '2021-05-19 00:10:34', '2021-07-18 00:10:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'testggg', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(52, 0, '2021-05-19 00:44:32', '2021-07-18 00:44:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tes user4', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(53, 0, '2021-05-19 01:13:21', '2021-07-18 01:13:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tssss', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(54, 0, '2021-05-19 01:22:06', '2021-07-18 01:22:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALL', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tes lagi', 'Intan', NULL, NULL, NULL, '5', 'nama99', NULL, NULL, NULL, '1245', NULL, NULL, '39', NULL, NULL, 'L', NULL, NULL, NULL, '08888879999', '', '', NULL, 'VISAMERAH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PARTNER', 'SAVING', 'REGULAR', 'SILVER', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `master_data_card`
--

CREATE TABLE `master_data_card` (
  `ID_MASTER` bigint(20) NOT NULL,
  `CIF_NUMBER` varchar(50) DEFAULT NULL,
  `CARD_NAME` varchar(100) DEFAULT NULL,
  `CARD_TYPE` varchar(100) DEFAULT NULL,
  `CARD_NO` varchar(100) DEFAULT NULL,
  `CARD_BANK` varchar(100) DEFAULT NULL,
  `CARD_LIMIT` varchar(100) DEFAULT NULL,
  `CARD_EXP` varchar(50) DEFAULT NULL,
  `CARD_STATUS` varchar(50) DEFAULT NULL,
  `LAST_UPDATE` datetime DEFAULT NULL,
  `CUST_APPID` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_data_card`
--

INSERT INTO `master_data_card` (`ID_MASTER`, `CIF_NUMBER`, `CARD_NAME`, `CARD_TYPE`, `CARD_NO`, `CARD_BANK`, `CARD_LIMIT`, `CARD_EXP`, `CARD_STATUS`, `LAST_UPDATE`, `CUST_APPID`) VALUES
(21, '5', 'nama88', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-15 23:08:45', '46'),
(22, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-18 17:27:22', '47'),
(23, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-18 23:29:55', '48'),
(24, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-18 23:53:36', '49'),
(25, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-19 00:05:28', '50'),
(26, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-19 00:10:34', '51'),
(27, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-19 00:44:32', '52'),
(28, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-19 01:13:22', '53'),
(29, '5', 'nama99', 'VISAMERAH', '5', NULL, NULL, NULL, NULL, '2021-05-19 01:22:06', '54');

-- --------------------------------------------------------

--
-- Table structure for table `master_param`
--

CREATE TABLE `master_param` (
  `ID` bigint(20) NOT NULL,
  `PARAM_AUTO` varchar(50) DEFAULT NULL,
  `PARAM_VALUE` varchar(50) DEFAULT NULL,
  `PARAM_REMARKS` varchar(50) DEFAULT NULL,
  `LAST_UPDATE_DATE` datetime DEFAULT NULL,
  `LAST_UPDATED_BY` datetime DEFAULT NULL,
  `STATUS` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `master_userid`
--

CREATE TABLE `master_userid` (
  `ID_USER` bigint(20) NOT NULL,
  `USER_ID` varchar(50) DEFAULT NULL,
  `USER_NAME` varchar(50) DEFAULT NULL,
  `USER_PWD` varchar(50) DEFAULT NULL,
  `USER_LEVEL` varchar(50) DEFAULT NULL,
  `USER_DN` varchar(50) DEFAULT NULL,
  `USER_EXT` varchar(50) DEFAULT NULL,
  `USER_STATUS` varchar(50) DEFAULT NULL,
  `USER_TEAM` varchar(20) DEFAULT NULL,
  `USER_GROUP` varchar(10) DEFAULT NULL,
  `USER_LEADER` varchar(10) DEFAULT NULL,
  `USER_MANAGER` varchar(50) DEFAULT NULL,
  `USER_SPV` varchar(50) DEFAULT NULL,
  `TEAM_QA` varchar(50) DEFAULT NULL,
  `ID_MITRA` varchar(50) DEFAULT NULL,
  `AUTODIAL` varchar(2) DEFAULT NULL,
  `SOFTPHONE` varchar(2) DEFAULT NULL,
  `LAST_UPDATE` datetime DEFAULT NULL,
  `PWD_EXPIRE` datetime DEFAULT NULL,
  `DATE_JOIN` datetime DEFAULT NULL,
  `DATE_RESIGN` datetime DEFAULT NULL,
  `CREATE_USER` varchar(50) DEFAULT NULL,
  `EDIT_USER` varchar(50) DEFAULT NULL,
  `LOGIN_STATUS` varchar(50) DEFAULT NULL,
  `LOCK_STATUS` varchar(50) DEFAULT NULL,
  `LAST_ACCESS` datetime DEFAULT NULL,
  `LAST_UPDATED_BY` varchar(50) DEFAULT NULL,
  `ISDELETED` varchar(10) DEFAULT NULL,
  `AGENT_PHOTO` longblob DEFAULT NULL,
  `LEVEL_TARGET` varchar(50) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `EDIT_DATE` datetime DEFAULT NULL,
  `LOGIN_IP` varchar(50) DEFAULT NULL,
  `LOGIN_VERSION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_userid`
--

INSERT INTO `master_userid` (`ID_USER`, `USER_ID`, `USER_NAME`, `USER_PWD`, `USER_LEVEL`, `USER_DN`, `USER_EXT`, `USER_STATUS`, `USER_TEAM`, `USER_GROUP`, `USER_LEADER`, `USER_MANAGER`, `USER_SPV`, `TEAM_QA`, `ID_MITRA`, `AUTODIAL`, `SOFTPHONE`, `LAST_UPDATE`, `PWD_EXPIRE`, `DATE_JOIN`, `DATE_RESIGN`, `CREATE_USER`, `EDIT_USER`, `LOGIN_STATUS`, `LOCK_STATUS`, `LAST_ACCESS`, `LAST_UPDATED_BY`, `ISDELETED`, `AGENT_PHOTO`, `LEVEL_TARGET`, `CREATE_DATE`, `EDIT_DATE`, `LOGIN_IP`, `LOGIN_VERSION`) VALUES
(1, 'ADMIN1', 'ADMIN1', NULL, 'ADMIN', '', NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'MANAGER1', 'MANAGER1', NULL, 'MANAGER', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'SPV01', 'SPV01', NULL, 'SPV', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', 'TL26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'SPV02', 'SPV02', NULL, 'SPV', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', 'TL26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'AGENT1', 'AGENT1', NULL, 'AGENT', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', 'SPV01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'AGENT2', 'AGENT2', NULL, 'AGENT', NULL, NULL, 'ACTIVE', NULL, NULL, NULL, 'MANAGER1', 'SPV02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `master_user_agents`
--

CREATE TABLE `master_user_agents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `AGENT_USERNAME` varchar(50) NOT NULL,
  `AGENT_NAME` varchar(50) DEFAULT NULL,
  `AGENT_PWD` varchar(255) NOT NULL,
  `AGENT_LEVEL` varchar(20) DEFAULT NULL,
  `AGENT_DN` varchar(15) DEFAULT NULL,
  `AGENT_STATUS` varchar(20) DEFAULT NULL,
  `AGENT_TIME` varchar(255) DEFAULT NULL,
  `GROUP_ID` varchar(20) DEFAULT NULL,
  `LEADER_ID` varchar(30) DEFAULT NULL,
  `SPV_ID` varchar(30) DEFAULT NULL,
  `MANAGER_ID` varchar(20) DEFAULT NULL,
  `LAST_UPDATE` date DEFAULT NULL,
  `STS_AUTODIAL` varchar(10) DEFAULT NULL,
  `STS_AUDITORIAL` varchar(20) DEFAULT NULL,
  `PWD_EXPIRE` date DEFAULT '2021-06-17',
  `RUNNING_STATUS` varchar(255) DEFAULT NULL,
  `DATE_JOIN` date DEFAULT NULL,
  `DATE_RESIGN` date DEFAULT NULL,
  `TEAM` varchar(20) DEFAULT 'TEAM 1',
  `CREATE_USER` varchar(20) DEFAULT 'ADMIN',
  `BALANCE_VOUCHER` varchar(20) DEFAULT 'NULL',
  `EXPIRE_DATE` date DEFAULT NULL,
  `AGENT_GROUP` varchar(30) DEFAULT 'NULL',
  `LOGIN_STATUS` tinyint(1) DEFAULT 0,
  `LOCK_STATUS` tinyint(1) DEFAULT 0,
  `APPROVE_VOUCHER` varchar(30) DEFAULT 'NULL',
  `TEAM_QA` varchar(30) DEFAULT 'NULL',
  `CAN_USE_SOFTPHONE` tinyint(1) DEFAULT 0,
  `LAST_ACCESS` datetime DEFAULT NULL,
  `LAST_UPDATED_BY` datetime DEFAULT NULL,
  `IS_DELETED` varchar(1) DEFAULT NULL,
  `AGENT_PHOTO` varchar(255) DEFAULT NULL,
  `LEVEL_TARGET` varchar(20) DEFAULT NULL,
  `ID_MITRA` varchar(20) DEFAULT NULL,
  `ID_MITRA_BNILIFE` varchar(255) DEFAULT NULL,
  `CREATE_DATE` date DEFAULT NULL,
  `EDIT_DATE` date DEFAULT NULL,
  `SPONSOR` date DEFAULT NULL,
  `PRODUCT` varchar(30) DEFAULT NULL,
  `LOGIN_IP` varchar(255) DEFAULT NULL,
  `BS_VERSION` varchar(30) DEFAULT 'Animates 04',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_user_agents`
--

INSERT INTO `master_user_agents` (`id`, `AGENT_USERNAME`, `AGENT_NAME`, `AGENT_PWD`, `AGENT_LEVEL`, `AGENT_DN`, `AGENT_STATUS`, `AGENT_TIME`, `GROUP_ID`, `LEADER_ID`, `SPV_ID`, `MANAGER_ID`, `LAST_UPDATE`, `STS_AUTODIAL`, `STS_AUDITORIAL`, `PWD_EXPIRE`, `RUNNING_STATUS`, `DATE_JOIN`, `DATE_RESIGN`, `TEAM`, `CREATE_USER`, `BALANCE_VOUCHER`, `EXPIRE_DATE`, `AGENT_GROUP`, `LOGIN_STATUS`, `LOCK_STATUS`, `APPROVE_VOUCHER`, `TEAM_QA`, `CAN_USE_SOFTPHONE`, `LAST_ACCESS`, `LAST_UPDATED_BY`, `IS_DELETED`, `AGENT_PHOTO`, `LEVEL_TARGET`, `ID_MITRA`, `ID_MITRA_BNILIFE`, `CREATE_DATE`, `EDIT_DATE`, `SPONSOR`, `PRODUCT`, `LOGIN_IP`, `BS_VERSION`, `created_at`, `updated_at`) VALUES
(1, 'Teguh', 'Teguh Muhammad Harits', '$2y$10$Lna1X.lJGWo3q4iaD73TPuuS6PY65Hcb2LmvA/QpSXs13YtQkO5dK', 'ADMIN', '083135351881', 'ACTIVE', NULL, NULL, NULL, NULL, 'Intan', NULL, NULL, NULL, '2021-06-17', NULL, '2021-05-18', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 0, NULL, NULL, 'N', 'aries.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '127.0.0.1', 'Animates 04', '2021-05-17 18:08:31', '2021-05-19 15:20:12'),
(2, 'Tofan', 'Tofan Maiki', '$2y$10$qGQWiys8iddd4iFMe4t0.OnDlFACabB/iavovD2VAR/siNFKj73r2', 'SPV', '0831391838191', 'ACTIVE', NULL, NULL, NULL, NULL, 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-17', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 1, 0, 'NULL', 'NULL', 1, NULL, NULL, 'N', 'shoes1.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-17 18:14:42', '2021-05-22 18:52:16'),
(3, 'Budi', 'Budi', '$2y$10$o/H1bueGNXgCE4MXy/mX3O6ZC7EjDF8ogERa6HXtZ3B4dVH28Pd8a', 'SPV', '08989898989', 'ACTIVE', NULL, NULL, NULL, NULL, 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-12', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 'N', 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-17 18:17:59', '2021-05-17 18:17:59'),
(4, 'Intan', 'Intan 08928983924', '$2y$10$xOePSucJHe8PzQxbrVc6ZOthLKr58krtBi7ZgNZ8Hbcz.ytOiDPUy', 'MANAGER', '0898898989', 'ACTIVE', NULL, NULL, NULL, NULL, 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-09', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 'N', 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-17 18:30:14', '2021-05-22 18:52:05'),
(5, 'Gerung', 'Gerung', '$2y$10$WK6CrOZlGADfP4W47Ie9quToAybTys2Jb2q6Bvlyzg8iXq8suihZC', 'AGENT', '088786876', 'ACTIVE', NULL, NULL, NULL, 'Tofan', 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-20', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 'N', 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-17 18:32:09', '2021-05-17 18:32:09'),
(6, 'Busi', '5948934', '$2y$10$uvREXd2dHw050vqWS.2xieVw/RdhZhXAxw4xczn1YIbzaSVlZTbZi', 'ADMINISTRATOR', '0859849584938', 'ACTIVE', NULL, NULL, NULL, NULL, 'Intan', NULL, NULL, 'preview', '2021-06-17', NULL, '2021-05-17', NULL, 'TEAM 1', 'ADMIN', 'NULL', NULL, 'NULL', 0, 0, 'NULL', 'NULL', 1, NULL, NULL, 'N', 'default.jpg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Animates 04', '2021-05-17 18:33:36', '2021-05-17 18:33:36');

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
-- Table structure for table `temp_preview_customers`
--

CREATE TABLE `temp_preview_customers` (
  `id` bigint(11) NOT NULL,
  `cust_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `bphone` varchar(255) DEFAULT NULL,
  `hphone` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `agenow` varchar(225) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `jenis_kartu` varchar(255) DEFAULT NULL,
  `status_upload` varchar(255) DEFAULT NULL,
  `nama_campaign` varchar(225) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

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
(1, 'Teguh', '$2y$10$Vi1RG0iG6sJBmOwo.eowtOI/vDHRhHdYtnFUGiGCzld/Rgs8yHZTG', 'Teguh Muhammad Harits', '127.0.0.1', '2021-05-19 22:20:12', 'admin', 0, 'aries.jpg', '2021-06-17', 'CGc57lObtK0YsoVooFzv14WOKiChzpRTzFFXaOzFPndu9QNBobUQu9zfFaZt', '2021-05-18 01:08:31', '2021-05-19 15:20:12'),
(2, 'Tofan', '$2y$10$PG3a6egpfNQtb5IMQpKBhO8nuWUeVScL4F.NPgiDtE1CPBIcTsY6q', 'Tofan Maiki', '127.0.0.1', '2021-05-23 00:41:07', 'spv', 0, 'shoes1.jpg', '2021-06-17', 'FQuvUeqguJeD6CjD1TOnsRmjfh00jVVGRBtKsOroV3VUxe2mZNRY32VMU0R7', '2021-05-18 01:14:42', '2021-05-22 18:52:16'),
(3, 'Budi', '$2y$10$WO6wFG9epxqvwdtOraWnAOB/Fci73/AOW2NMvtezyJlK7j4o6mRJy', 'Budi', NULL, NULL, 'spv', 0, 'default.jpg', '2021-06-17', '1KG0XxP5mwsFPolyxkmsFRC8O0w1vDV7uiYry0PMmFd6kk09SLBOUdKV14Mp', '2021-05-18 01:17:59', '2021-05-18 01:17:59'),
(4, 'Intan', '$2y$10$tFhW3BkwERfTJQjRxVJn8uVGtVehoQTPZg.O8.KaeZrfI8P//Z2Mu', 'Intan 08928983924', '127.0.0.1', '2021-05-23 01:52:05', 'manager', 0, 'default.jpg', '2021-06-17', 'Tv0E4nDMPKL5AafPuWdH3WnJ2zmp7VjxcjVnXBwf95o0UmbsrV9QXXNs3gsa', '2021-05-18 01:30:14', '2021-05-22 18:52:05'),
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
-- Indexes for table `data_assignment`
--
ALTER TABLE `data_assignment`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `duplicate_data`
--
ALTER TABLE `duplicate_data`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `event_audit_trail`
--
ALTER TABLE `event_audit_trail`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `master_blacklist_number`
--
ALTER TABLE `master_blacklist_number`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `master_customer`
--
ALTER TABLE `master_customer`
  ADD PRIMARY KEY (`CUST_APPID`) USING BTREE;

--
-- Indexes for table `master_data_card`
--
ALTER TABLE `master_data_card`
  ADD PRIMARY KEY (`ID_MASTER`);

--
-- Indexes for table `master_param`
--
ALTER TABLE `master_param`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `master_userid`
--
ALTER TABLE `master_userid`
  ADD PRIMARY KEY (`ID_USER`);

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
-- Indexes for table `temp_preview_customers`
--
ALTER TABLE `temp_preview_customers`
  ADD PRIMARY KEY (`id`) USING BTREE;

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
-- AUTO_INCREMENT for table `data_assignment`
--
ALTER TABLE `data_assignment`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=169;

--
-- AUTO_INCREMENT for table `duplicate_data`
--
ALTER TABLE `duplicate_data`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `event_audit_trail`
--
ALTER TABLE `event_audit_trail`
  MODIFY `ID` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `master_customer`
--
ALTER TABLE `master_customer`
  MODIFY `CUST_APPID` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `master_data_card`
--
ALTER TABLE `master_data_card`
  MODIFY `ID_MASTER` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `master_userid`
--
ALTER TABLE `master_userid`
  MODIFY `ID_USER` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
-- AUTO_INCREMENT for table `temp_preview_customers`
--
ALTER TABLE `temp_preview_customers`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
