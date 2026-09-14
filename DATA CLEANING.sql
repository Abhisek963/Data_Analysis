-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null Values
-- 4. Remove any irrelevant columns

CREATE table layoffs_satging
LIKE layoffs;

SELECT *
FROM layoffs_satging;

INSERT layoffs_satging
SELECT *
FROM  layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS Row_Num
FROM layoffs_satging;

WITH duplicates_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,  industry, total_laid_off, percentage_laid_off, `date`,stage,country,funds_raised_millions) AS Row_Num
FROM layoffs_satging
)
SELECT * 
FROM duplicates_cte
WHERE Row_num > 1;


SELECT *
FROM layoffs_satging
WHERE company = 'Casper';

WITH duplicates_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,  industry, total_laid_off, percentage_laid_off, `date`,stage,country,funds_raised_millions) AS Row_Num
FROM layoffs_satging
)
DELETE  
FROM duplicates_cte
WHERE Row_num > 1;


CREATE TABLE `layoffs_satging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_satging2;

INSERT into layoffs_satging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,  industry, total_laid_off, percentage_laid_off, `date`,stage,country,funds_raised_millions) AS Row_Num
FROM layoffs_satging;

DELETE
FROM layoffs_satging2
WHERE row_num > 1;

select *
FROM layoffs_satging2;


-- Standardizing the data

SELECT company, TRIM(company)
FROM layoffs_satging2;

UPDATE layoffs_satging2
SET company = TRIM(company);

SELECT *
FROM layoffs_satging2
WHERE industry like 'crypto%';

UPDATE layoffs_satging2
set industry = 'crypto'
WHERE industry like 'crypto%';

UPDATE layoffs_satging2
set country = 'United States'
WHERE country like 'United States%';

SELECT distinct country
FROM layoffs_satging2
order by 1;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y');

UPDATE layoffs_satging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER table layoffs_satging2
MODIFY column `date` DATE;


SELECT *
FROM layoffs_satging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_satging2
WHERE company = 'Airbnb';

UPDATE layoffs_satging2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_satging2 AS st1
JOIN layoffs_satging2 AS st2
	ON st1.company = st2.company
    And st1.location = st2.location
WHERE (st1.industry IS NULL OR st1.industry = '')
and st2.industry is NOT NULL;


UPDATE layoffs_satging2 AS st1
JOIN layoffs_satging2 AS st2
	ON st1.company = st2.company
set st1.industry = st2.industry
WHERE st1.industry IS NULL
and st2.industry is NOT NULL;


delete
FROM layoffs_satging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_satging2;

ALTER TABLE layoffs_satging2
DROP COLUMN row_num;