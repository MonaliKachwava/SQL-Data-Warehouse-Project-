/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

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
