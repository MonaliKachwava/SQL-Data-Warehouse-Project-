/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


--check for Nulls or Duplicates in Primary key
--Expectataion : NO Result

select * from bronze.crm_cust_info

select cst_id  , count(*) from
 bronze.crm_cust_info
 GROUP BY cst_id
 having count(*) >1

 --check for unwanted Spaces
 --Expectataion : NO Result
 select cst_firstname 
 from Silver.crm_cust_info
 where cst_firstname !=TRIM(cst_firstname)

  --check for unwanted Spaces
 --Expectataion : NO Result
 select cst_lastname 
 from bronze.crm_cust_info
 where cst_firstname !=TRIM(cst_lastname)

 --Data Standardization & Consistency

 select distinct cst_gndr from 
 bronze.crm_cust_info

 --quality checks
 --check for nulls or duplicates for primary key
 --expectation : no result

 select prd_id , count(*) from bronze.crm_prd_inf
 group by prd_id
 having count(*) > 1 or prd_id is null

--check for unwanted spaces
 --expectation : no result

 select prd_nm 
 from  bronze.crm_prd_info 
 where  prd_nm !=TRIM(prd_nm)

 --check for null or negative values
  --expectation : no result
select prd_cost from 
 bronze.crm_prd_info
 where prd_cost < 0 or prd_cost is  null 

 --Data Standardization & consistenecy
 select Distinct prd_line 
 from bronze.crm_prd_info 

 --check fro invalid dates
 select * from bronze.crm_prd_info 
 where prd_start_dt > prd_end_dt

--identify out -of-Range Dates
select Distinct 
bdate
from bronze.erp_loc_az12
where bdate < '1924-01-01' or bdate > getdate()

--Data Standardization & consistency
select distinct 
gen ,
case 
when upper(TRIM(gen)) in ('F','Female') then 'Female'
when upper(TRIM(gen)) in ('M','Male') then 'Male'
else 'n/a'
end as gen 
from bronze.erp_loc_az12

---check data quality---
select
replace (cid , '-','') as cid,
case 
when TRIM(cntry) ='DE' then 'Germany'
when TRIM(cntry) in ('US','USA') THEN 'united States'
when TRIM(cntry) ='' or cntry is null then 'N/A'
ELSE TRIM(cntry)
END AS cntry 
from 
 bronze.erp_loc_a101

 ---data standardization & consistency
 select distinct cntry from  bronze.erp_loc_a101
 order by cntry

--check for unwanted spaces
select * from bronze.erp_px_cat_g1v2
select * 
from bronze.erp_px_cat_g1v2 
where subcat != TRIM(subcat) or cat!=trim(cat) or  maintenance !=trim(maintenance)

select distinct maintenance from bronze.erp_px_cat_g1v2


