-- Project Title: Layoffs Data Cleaning in MySQL
-- By: Abdullah Akintobi
-- Published On: November 11, 2024
--
--
-- -- Data Modelling --
-- Create Database
CREATE DATABASE world_layoffs;
-- Data Archiving
-- Create a dublicate of the dataset as a backup dataset
CREATE TABLE layoffs_copy LIKE layoffs;
-- Populate the new backup table 'layoffs_raw' with data from 'layoffs' table
INSERT
    layoffs_copy
SELECT
    *
FROM
    layoffs;
-- Preview the newly populated table
SELECT 
    *
FROM
    layoffs_copy;
--
--
-- Data Exploration
-- Preview 10 samples from 'layoffs' table
SELECT 
    *
FROM
    layoffs_copy
ORDER BY RAND()
LIMIT 10;
--
-- Count the number of rows in the table
SELECT 
    COUNT(*) AS row_num
FROM
    layoffs_copy;
-- Check for Duplicates using 'ROW_NUMBER()' window function
WITH dublicate AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY `company`,
            `location`,
            `industry`,
            `total_laid_off`,
            `percentage_laid_off`,
            `date`,
            `stage`,
            `country`,
            `funds_raised_millions`
        ) AS dub_row_num
    FROM
        layoffs_copy
)
SELECT
    *
FROM
    dublicate
WHERE
	dub_row_num > 1;
--
--
-- Data Cleaning
-- Create new table to remove duplicates
CREATE TABLE `layoffs_clean` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` FLOAT DEFAULT NULL,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `dub_row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;
-- Populate the new table with data from 'layoffs_copy' and row number to identify duplicates
INSERT INTO
    layoffs_clean
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY `company`,
        `location`,
        `industry`,
        `total_laid_off`,
        `percentage_laid_off`,
        `date`,
        `stage`,
        `country`,
        `funds_raised_millions`
    ) AS dub_row_num
FROM
    layoffs_copy;
SELECT 
    *
FROM
    layoffs_clean
WHERE
    dub_row_num > 1;
SELECT 
    COUNT(*)
FROM
    layoffs_clean;
--
DROP TABLE layoffs_clean;









WITH COUNT_ROW AS (
        SELECT
            *,
            COUNT(*) NUM_DUBLICATE
        FROM
            layoffs
        GROUP BY
            `company`,
            `location`,
            `industry`,
            `total_laid_off`,
            `percentage_laid_off`,
            `date`,
            `stage`,
            `country`,
            `funds_raised_millions`
    )
SELECT
    COUNT(*)
FROM
    COUNT_ROW;
SELECT 
    COUNT(*)
FROM
    layoffs;
    

SELECT 
    *
FROM
    layoffs_clean;
--

DELETE FROM layoffs_clean 
WHERE
    row_num > 1;
SELECT 
    *
FROM
    layoffs_clean;
--
    -- Standardizing data