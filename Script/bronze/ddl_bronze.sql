/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

Create table bronze.crm_cust_info (
cst_id INT ,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE ) ;


Create table bronze.crm_prd_info (
prd_id INT ,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME 

)

Create table bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT ,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT 
);

Create table bronze.erp_loc_a101 (
cid NVARCHAR(50),
cntry  NVARCHAR(50)
)

Create table bronze.erp_loc_az12 (

cid NVARCHAR(50),
bdate DATE ,
gen NVARCHAR(50)

);

Create table bronze.erp_px_cat_g1v2 (
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance  NVARCHAR(50)
) ;


CREATE OR ALTER PROCEDURE bronze.load_bronze as
begin
print'======================================================';
print'Loading bronze Layer';
print '======================================================';

print'-----------------------------------------------------';
print'Loading CRM Tables'
print'-----------------------------------------------------';

print'>>> Truncating Table bronze.crm_cust_info' ;
	TRUNCATE TABLE bronze.crm_cust_info
print'>>> Inserting data into Table bronze.crm_cust_info' ;
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\USER\Downloads\source_crm\cust_info.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

print'>>> Truncating Table bronze.crm_prd_info' ;
	TRUNCATE TABLE bronze.crm_prd_info
print'>>> Inserting data into Table bronze.crm_prd_inf ';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\USER\Downloads\source_crm\prd_info.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

print'>>> Truncating Table bronze.crm_sales_details ';

	TRUNCATE TABLE bronze.crm_sales_details 
	print'>>> Inserting data into Table bronze.crm_sales_details' ;
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\USER\Downloads\source_crm\sales_details.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


print'======================================================';
print'Loading bronze Layer';
print '======================================================';

print'-----------------------------------------------------';
print'Loading ERP Tables';
print'-----------------------------------------------------';

print'>>> Truncating Table : bronze.bronze.erp_loc_a101' ;
	TRUNCATE TABLE  bronze.erp_loc_a101
print'>>> Inserting into Table : bronze.bronze.erp_loc_a101' ;
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\USER\Downloads\source_erp\LOC_A101.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

print'>>> Truncating Table :bronze.erp_loc_az12' ;
	TRUNCATE TABLE bronze.erp_loc_az12 
print'>>> Inserting into  Table : bronze.erp_loc_az12 ';
	BULK INSERT bronze.erp_loc_az12 
	FROM 'C:\Users\USER\Downloads\source_erp\CUST_AZ12.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

Print'>>> Truncating Table :bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2
	print'>>>Inserting into Table :bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\USER\Downloads\source_erp\PX_CAT_G1V2.csv'
	with (
	FIRSTROW = 2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

end

exec bronze.load_bronze
