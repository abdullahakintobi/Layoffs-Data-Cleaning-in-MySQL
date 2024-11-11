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
CREATE TABLE layoffs_raw LIKE layoffs;
-- Populate the new backup table 'layoffs_raw' with data from 'layoffs' table
INSERT
    layoffs_raw
SELECT
    *
FROM
    layoffs;
-- Preview the newly populated table
SELECT 
    *
FROM
    layoffs_raw;
SELECT 
    *
FROM
    layoffs
ORDER BY RAND()
LIMIT 10;
SELECT 
    COUNT(*)
FROM
    layoffs_raw;
INSERT
    layoffs_raw
SELECT
    *
FROM
    layoffs;
SELECT 
    *, COUNT(*) AS duplicate_count
FROM
    layoffs
GROUP BY company
HAVING COUNT(*) > 1;
WITH dublicate_count AS (
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
            ) AS NUM_DUBLICATE
        FROM
            layoffs
    )
SELECT
    COUNT(*)
FROM
    dublicate_count;
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
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;
SELECT 
    *
FROM
    layoffs_clean;
--
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
    ) AS row_num
FROM
    layoffs;
SELECT 
    *
FROM
    layoffs_clean
WHERE
    row_num > 1;
DELETE FROM layoffs_clean 
WHERE
    row_num > 1;
SELECT 
    *
FROM
    layoffs_clean;
--
    -- Standardizing data