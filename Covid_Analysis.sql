<<<<<<< HEAD
--SELECT * 
--FROM CovidAnalysisProject..CovidDeath
--order by 3,4

--SELECT * 
--FROM CovidAnalysisProject..CovidVaccionation
--order by 3,4

-- Select data we are going to be using.

--SELECT Location, date, total_cases, new_cases, total_deaths, population, AVG(total_deaths)
--FROM CovidAnalysisProject..CovidDeath
--Order by 1,2

 --Looking at the total cases vs total deaths.
 -- Around 2 to 6 percent likelihood to die.
SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM CovidAnalysisProject..CovidDeath
where Location like '%States%'
Order by 1,2



-- Looking at total cases vs population
--Shows the percentage of population got Covid
SELECT Location, date, total_cases, total_deaths,(total_cases/population)*100 as PopulationgodCovidPercent
FROM CovidAnalysisProject..CovidDeath
where Location like '%States%'
Order by 1,2 DESC


-- Looking at countries with hightiest infection ratio compared to population
SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PopulationInfectedPercent
FROM CovidAnalysisProject..CovidDeath
Group by location, population
Order by 4 DESC

--DROP TABLE IF EXISTS #temp_contruiesinfection
--CREATE TABLE #temp_contruiesinfection(
--	Location varchar(50),
--	Population float,
--	HighestInfectionCount float, 
--	PopulationInfectedPercent float)

--INSERT INTO #temp_contruiesinfection
--	SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PopulationInfectedPercen
--	FROM CovidAnalysisProject..CovidDeath
--	Group by location, population
--	Order by 4 DESC

--SELECT AVG(PopulationInfectedPercent) as PromedioDeContagio
--FROM #temp_contruiesinfection




-- Showing at countries with hightiest deaths count compared to population

SELECT Location,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is not null
Group by location
Order by 2 DESC

--BREAKING BY CONTIENT 

SELECT Location,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is  null
Group by location
Order by 2 DESC

-- Showing continents with the highest death count per population

-- Continent version
SELECT continent,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is not  null
Group by continent
Order by 2 DESC

-- GLOBAL NUMBERS

 --Looking at the total cases vs total deaths.
 -- Around 2 to 6 percent likelihood to die.
SELECT   SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)  * 100  as DeathPercentage 
FROM CovidAnalysisProject..CovidDeath
where new_cases <> 0 and continent is not null 
--Group by date
-- where Location like '%States%'
Order by 1,2

-- Looking at the total Vaccination vs Population
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition BY dea.Location Order By dea.Location, dea.date) as RollingpeopleVaccinated
FROM CovidAnalysisProject..CovidDeath dea
JOIN CovidAnalysisProject..CovidVaccination vac
	ON dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null 
Order by 1,2,3


-- Using CTE to make more calculations

with PopulationvsVaccination (Continent, location, date, population, new_vaccinations, RollingpeopleVaccinated)
as
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition BY dea.Location Order By dea.Location, dea.date) as RollingpeopleVaccinated
FROM CovidAnalysisProject..CovidDeath dea
JOIN CovidAnalysisProject..CovidVaccination vac
	ON dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null
)

Select *, (RollingpeopleVaccinated/population) * 100 as PercentPopulationVaccionated
FROM PopulationvsVaccination

-- Creating view Percent of Population Vaccinated

Create View PercentPopulationVaccinated as

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition BY dea.Location Order By dea.Location, dea.date) as RollingpeopleVaccinated
FROM CovidAnalysisProject..CovidDeath dea
JOIN CovidAnalysisProject..CovidVaccination vac
	ON dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null

=======
--SELECT * 
--FROM CovidAnalysisProject..CovidDeath
--order by 3,4

--SELECT * 
--FROM CovidAnalysisProject..CovidVaccionation
--order by 3,4

-- Select data we are going to be using.

--SELECT Location, date, total_cases, new_cases, total_deaths, population, AVG(total_deaths)
--FROM CovidAnalysisProject..CovidDeath
--Order by 1,2

 --Looking at the total cases vs total deaths.
 -- Around 2 to 6 percent likelihood to die.
SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM CovidAnalysisProject..CovidDeath
where Location like '%States%'
Order by 1,2



-- Looking at total cases vs population
--Shows the percentage of population got Covid
SELECT Location, date, total_cases, total_deaths,(total_cases/population)*100 as PopulationgodCovidPercent
FROM CovidAnalysisProject..CovidDeath
where Location like '%States%'
Order by 1,2 DESC


-- Looking at countries with hightiest infection ratio compared to population
SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PopulationInfectedPercent
FROM CovidAnalysisProject..CovidDeath
Group by location, population
Order by 4 DESC

--DROP TABLE IF EXISTS #temp_contruiesinfection
--CREATE TABLE #temp_contruiesinfection(
--	Location varchar(50),
--	Population float,
--	HighestInfectionCount float, 
--	PopulationInfectedPercent float)

--INSERT INTO #temp_contruiesinfection
--	SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PopulationInfectedPercen
--	FROM CovidAnalysisProject..CovidDeath
--	Group by location, population
--	Order by 4 DESC

--SELECT AVG(PopulationInfectedPercent) as PromedioDeContagio
--FROM #temp_contruiesinfection




-- Showing at countries with hightiest deaths count compared to population

SELECT Location,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is not null
Group by location
Order by 2 DESC

--BREAKING BY CONTIENT 

SELECT Location,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is  null
Group by location
Order by 2 DESC

-- Showing continents with the highest death count per population

-- Continent version
SELECT continent,  MAX(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is not  null
Group by continent
Order by 2 DESC

-- GLOBAL NUMBERS

 --Looking at the total cases vs total deaths.
 -- Around 2 to 6 percent likelihood to die.
SELECT   SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)  * 100  as DeathPercentage 
FROM CovidAnalysisProject..CovidDeath
where new_cases <> 0 and continent is not null 
--Group by date
-- where Location like '%States%'
Order by 1,2

>>>>>>> 681996e2d9520d5206147e81f713593a016952c9
