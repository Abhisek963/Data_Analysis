-- Exploratory Data Analysis

SELECT *
FROM layoffs_satging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_satging2;

SELECT *
FROM layoffs_satging2
WHERE percentage_laid_off = 1;

SELECT company, SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY company
ORDER by 2 DESC;

SELECT MIN(`date`),MIN(`date`)
FROM layoffs_satging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY industry
ORDER by 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY country
ORDER by 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY YEAR(`date`)
ORDER by 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY stage
ORDER by 2 DESC;

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_satging2
WHERE substring(`date`,1,7) is not null
GROUP BY `MONTH`
ORDER by 1 ASC;

WITH rolling_total AS
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off
FROM layoffs_satging2
WHERE substring(`date`,1,7) is not null
GROUP BY `MONTH`
ORDER by 1 ASC
)
SELECT `MONTH`,laid_off, sum(laid_off) OVER (order by `MONTH`) AS Rolling_Total
FROM rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY company, YEAR(`date`)
ORDER by 3 DESC;

WITH COMPANY_YEAR(Company, Years, Total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_satging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
SELECT *, dense_rank() over(partition by Years order by Total_laid_off Desc) AS DenseRank
FROM COMPANY_YEAR
where Years is not null
)
SELECT * 
FROM Company_Year_Rank
where DenseRank<=5;




