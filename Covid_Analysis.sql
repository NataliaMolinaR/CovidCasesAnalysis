
/* DATA TO USE FOR VISUALIZATION - TABLEAU */


-- Select data we are going to be using.
--SELECT Location, date, total_cases, new_cases, total_deaths, population, AVG(total_deaths)
--FROM CovidAnalysisProject..CovidDeath
--Order by 1,2

 --1. PERCENT TOTAL DEATH.
SELECT   SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)  * 100  as DeathPercentage 
FROM CovidAnalysisProject..CovidDeath
where new_cases <> 0 and continent is not null 
--Group by date
-- where Location like '%States%'
Order by 1,2


-- Double checking metrics with online sources. Results are pretty close to current stadistics. 

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From CovidAnalysisProject..CovidDeath
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2

-- 2.  HIGHEST DEATH COUNT BY CONTINENTS

SELECT Location,  SUM(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is  null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Low income', ' Lower middle income')
Group by location
Order by totalDeathCount DESC


-- 3. PERCENT POPULATION INFECTED BY LOCATION AND POPULATION

SELECT Location, population , MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
FROM CovidAnalysisProject..CovidDeath
Group by location, population
Order by PercentPopulationInfected DESC

-- 4. PERCENT POPULATION INFECTED PROGRESS TRHOUGHTOUT THE TIME.

SELECT Location, population , date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
FROM CovidAnalysisProject..CovidDeath
Group by location, population
Order by PercentPopulationInfected DESC




/* OTHER METRICS TO EXPLORE AND UNDERSTAND THE DATA AND CASE OF STUDY*/


-- 1. LOOKING AT PEOPLE GETTING VACCINATED BY LOCATION
SELECT dea.continent,dea.location, dea.date, dea.population, MAX(vac.new_vaccinations) as RollingpeopleVaccinated 
FROM CovidAnalysisProject..CovidDeath dea
JOIN CovidAnalysisProject..CovidVaccination vac
	ON dea.location =vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
Order by 1,2,3

 --2. TOTAL CASES VS TOTAL DEATHS
SELECT   SUM(new_cases) as totalCases,SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)  * 100  as DeathPercentage 
FROM CovidAnalysisProject..CovidDeath
where new_cases <> 0 and continent is not null 
--Group by date
-- where Location like '%States%'
Order by 1,2

-- 3.  HIGHEST DEATH COUNT BY CONTINENTS

SELECT Location,  SUM(total_deaths) AS totalDeathCount
FROM CovidAnalysisProject..CovidDeath
where continent is  null
and location not in ('World', 'European Union', 'International',  'High income', 'Upper middle income', 'Low income', ' Lower middle income')
Group by location
Order by totalDeathCount DESC

-- 4. PERCENT POPULATION INFECTED PROGRESS TRHOUGHTOUT THE TIME.

SELECT Location, population , date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
FROM CovidAnalysisProject..CovidDeath
Group by location, population
Order by PercentPopulationInfected DESC

 --5. TOTAL CASES VS TOTAL DEATH.
SELECT Location, date,population,  total_cases, total_deaths
FROM CovidAnalysisProject..CovidDeath
where continent is not null 
Order by 1,2


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







