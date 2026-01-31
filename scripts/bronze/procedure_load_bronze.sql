/* 
=====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================================
Script purpose:
    This stored procedure load data into 'bronze' schema from external CSV files.
    It performes the following actions:
      - Truncates the bronze tables before loading data.
      - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:
    None. This stored procedure doesn't accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
=====================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME ;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '============================';
		PRINT '*** Loading Bronze Layer ***';
		PRINT '============================';
		PRINT'------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT'------------------------------------';
		------------------------------------------------------------------------------------------------ (1)
		PRINT '>> Inserting Data into: bronze.crm_cust_info'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_cust_info;  -- first I truncate the table (clear the table) 
		BULK INSERT bronze.crm_cust_info -- second Insert the data
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------'
		------------------------------------------------------------------------------------------------ (2)
		PRINT '>> Inserting Data into: bronze.crm_prd_info'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------'
		------------------------------------------------------------------------------------------------ (3)
		PRINT '>> Inserting Data into: bronze.crm_sales_details'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------'
		------------------------------------------------------------------------------------------------ (4)
		PRINT '------------------------------------';
		PRINT 'Loading ERP Tables' ;
		PRINT '------------------------------------';
		PRINT '>> Inserting Data into: bronze.erp_cust_az12'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------'
		------------------------------------------------------------------------------------------------ (5)
		PRINT '>> Inserting Data into: bronze.erp_loc_a101'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------'
		------------------------------------------------------------------------------------------------ (6)
		PRINT '>> Inserting Data into: bronze.erp_px_cat_g1v2'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Mahmoud\Programming\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds ';
		PRINT '--------------------------------';
		------------------------------------------------------------------------------------------------
		SET @batch_end_time = GETDATE();
		PRINT '===================================';
		PRINT 'Total Duration of Loading Bronze Layer: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds ';
	END TRY
	BEGIN CATCH
		PRINT '======================================';
		PRINT 'Error Occured During Load Bronze Layer';
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Number ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================';
	END CATCH
END
