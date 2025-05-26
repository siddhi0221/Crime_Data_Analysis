CREATE DATABASE crime;
use crime;
CREATE TABLE IF NOT EXISTS CrimeData (
    id INT,
    report_number INT NOT NULL,
    date_of_occurrence DATE NOT NULL,
    time_of_occurrence TIME NOT NULL,
    city VARCHAR(100) NOT NULL,
    crime_code INT NOT NULL,
    crime_description VARCHAR(255) NOT NULL,
    victim_age INT NOT NULL,
    victim_gender VARCHAR(10) NOT NULL,
    weapon_used VARCHAR(100),
    crime_domain VARCHAR(100) NOT NULL,
    police_deployed INT NOT NULL,
    case_closed BOOLEAN NOT NULL,
    date_case_closed VARCHAR(50),  -- Kept as string since format is inconsistent
    date_of_report DATE NOT NULL,
    time_of_report TIME NOT NULL,
    occurrence_year INT NOT NULL,
    age_group VARCHAR(50) NOT NULL
);

drop table crimedata;

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crime_cleaned_data.csv"
INTO TABLE crimedata
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS;

SELECT * FROM crimedata;

-- How many total crime records are there in the dataset?
select count(report_number) from crimedata;

-- What are the unique types of crimes recorded?
select distinct crime_description from crimedata
limit 10;

-- How many crimes occurred in each city?
SELECT city, COUNT(*) AS total_crimes
FROM CrimeData
GROUP BY city
ORDER BY total_crimes DESC;

-- What are the most and least common crime types?
(Select crime_description, count(*) as crime_count
from crimedata
group by crime_description 
order by crime_count DESC
limit 1)

Union all

(Select crime_description, count(*) as crime_count
from crimedata
group by crime_description 
order by crime_count ASC
limit 1);

-- How many crimes occurred in a specific year (e.g., 2023)?
select count(report_number) from crimedata
where occurrence_year=2023;

-- Which months have the highest crime rates?
select extract(month From date_of_occurrence) as month,count(*) as total_crime
from crimedata
group by month
order by total_crime DESC;

-- Which locations have seen an increase in crime over time?
SELECT occurrence_year,city, COUNT(*) AS total_crimes
FROM CrimeData
GROUP BY city, occurrence_year
ORDER BY city, occurrence_year;

-- What is the average number of crimes per month in a specific city?
SELECT 
    city,
    AVG(monthly_crimes) AS avg_crime_per_month
FROM (
    SELECT city, EXTRACT(MONTH FROM date_of_occurrence) AS month, COUNT(*) AS monthly_crimes
    FROM CrimeData
    GROUP BY city, month
) AS monthly_counts
GROUP BY city
ORDER BY avg_crime_per_month DESC;



