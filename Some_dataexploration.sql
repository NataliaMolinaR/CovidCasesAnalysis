/* Process of data exploration */ 

-- Looking at countries with hightiest infection ratio compared to population
SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
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

SELECT Location,  SUM(total_deaths) AS totalDeathCount
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

 --2. TOTAL CASES VS TOTAL DEATHS
SELECT   SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)  * 100  as DeathPercentage 
FROM CovidAnalysisProject..CovidDeath
where new_cases <> 0 and continent is not null 
--Group by date
-- where Location like '%States%'
Order by 1,2

-- 1. LOOKING AT PEOPLE GETTING VACCINATED BY LOCATION
SELECT dea.continent,dea.location, dea.date, dea.population, MAX(vac.new_vaccinations) as RollingpeopleVaccinated 
FROM CovidAnalysisProject..CovidDeath dea
JOIN CovidAnalysisProject..CovidVaccination vac
	ON dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
Order by 1,2,3


-- 6. STUDYING TRENDS OF HOW OFTEN PEOPLE WAS GETTING VACCINATED 

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

