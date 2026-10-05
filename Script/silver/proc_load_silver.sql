/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
  Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

---------------------------------------------------------------Silver.crm_prd_info------------------------------------------------


CREATE OR ALTER PROCEDURE Silver.load_silver as 
begin 
PRINT 'Silver.crm_prd_info Tronasformed '
TRUNCATE TABLE Silver.crm_prd_info
insert into Silver.crm_prd_info
  ( prd_id,
  cat_id,
  prd_key,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt,
  prd_end_dt
  )

  select prd_id ,
  replace(SUBSTRING(prd_key , 1, 5) ,'-','_') as cat_id , --extract of category id 
          SUBSTRING(prd_key , 7, len(prd_key))  as prd_key ,--extract of product key
          prd_nm ,
         ISNULL(prd_cost , 0) as prd_cost,
         case 
         when upper(Trim(prd_line)) = 'R' then 'Road'
         when upper(TRIM(prd_line)) = 'M' then 'Mountain'
         when upper(TRIM(prd_line)) = 'S' then 'Other sales'
         when upper(TRIM(prd_line ))= 'T' then 'Touring'
         ELSE 'N/A'
         END as prd_line ,---map product line codes to descriptive  values
         cast(prd_start_dt as DATE) AS prd_start_dt ,
         CAST(
         Lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1  as DATE)
          prd_end_dt --calculate end date as one day before the next start date 
         from bronze.crm_prd_info
          
       
------------------------------------------------------Silver.crm_cust_info---------------------------------------------------------------

print'Silver.crm_cust_info Transformed'
Truncate table Silver.crm_cust_info
insert into Silver.crm_cust_info (
cst_id ,
cst_key ,
cst_firstname ,
cst_lastname ,
cst_material_status,
cst_gndr ,
cst_create_date 
 )
select cst_id,
cst_key ,
      Trim(cst_firstname) as cst_firstname,
      Trim(cst_lastname) as cst_lastname ,

      case when upper(Trim(cst_material_status)) = 'M' then 'Married'
      when upper (Trim(cst_material_status)) = 'S' then 'Single'
      else 'n/a'                 ---Normalization marital status values into readable format
      end cst_material_status,

      case when upper(Trim(cst_gndr)) = 'M' then 'Male'
      when upper (Trim(cst_gndr))= 'f' then 'Female'
      else 'n/a'
      end cst_gndr,  ---Normalization Gender values into readable format
      cst_create_date

from
        (select * , ROW_NUMBER () OVER(Partition by cst_id order by cst_create_date desc) as flat_test
        from bronze.crm_cust_info
        where cst_id IS NOT NULL
        ) t
        where  flat_test = 1 ----Select the most recent record 

------------------------------------------------------silver.crm_sales_details--------------------------------------------------------
Print 'silver.crm_sales_details Transformed'
Truncate table silver.crm_sales_details
insert into silver.crm_sales_details
(sls_ord_num ,
sls_prd_key ,
sls_cust_id  ,
sls_order_dt ,
sls_ship_dt ,
sls_due_dt ,
sls_sales ,
sls_quantity ,
sls_price

)
select  
sls_ord_num ,
sls_prd_key,
sls_cust_id,
CASE
	when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	else cast(cast(sls_order_dt as varchar) as Date )
	END as sls_order_dt ,
CASE
	when sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 THEN Null
	else CAST(CAST(sls_ship_dt as Varchar) as DATE )
	END as sls_ship_dt,
CASE
	when sls_due_dt = 0 or LEN(sls_due_dt) != 8 Then null
	else cast(cast(sls_due_dt as varchar) as date )
	end as sls_due_dt,
case 
	when sls_sales IS NULL OR sls_sales < = 0 or sls_sales != sls_quantity *ABS(sls_price)
	then sls_quantity * ABS(sls_price)
	else sls_sales 
	END as sls_sales ,-- Recalculate sales if original value is missing or incorrect
	sls_quantity ,
	case
		when sls_price is null or sls_price < = 0
		then sls_sales/nullif(sls_quantity,0)
		else sls_sales --derive price if original value is invalid
		end as sls_price 
	from bronze.crm_sales_details

------------------------------------------------------Silver.erp_loc_az12-----------------------------------------------------------------------------------
Print 'Silver.erp_loc_az12 Transformed'

Truncate table Silver.erp_loc_az12

insert into Silver.erp_loc_az12
(
cid,
bdate,
gen  
)

select 
case 
	when cid like 'NAS%' THEN SUBSTRING(cid , 4 ,LEN(cid))
		else cid
		end as cid ,
	case  
		when bdate > Getdate() then null
		else bdate 
		end as  bdate ,
case 
	when upper(TRIM(gen)) in ('F','Female') then 'Female'
	when upper(TRIM(gen)) in ('M','Male') then 'Male'
	else 'n/a'
	end as gen 
from bronze.erp_loc_az12


-----------------------------------------------------------Silver .erp_loc_a101---------------------------------------------------------------------------
Print 'Silver .erp_loc_a101 transformed'

TRUNCATE TABLE Silver .erp_loc_a101

insert into Silver .erp_loc_a101
(cid,
cntry)


Select
replace (cid , '-','') as cid,
case 
when TRIM(cntry) ='DE' then 'Germany'
when TRIM(cntry) in ('US','USA') THEN 'united States'
when TRIM(cntry) ='' or cntry is null then 'N/A'
ELSE TRIM(cntry)
END AS cntry 
from 
 bronze.erp_loc_a101

---------------------------------------------------------Silver.erp_px_cat_g1v2------------------------------------------------------------------------
Print'Silver.erp_px_cat_g1v2 transformed'

insert into Silver.erp_px_cat_g1v2

(id,cat,subcat,maintenance)
select 
id , 
cat,
subcat,
maintenance 
from bronze.erp_px_cat_g1v2 

END 
