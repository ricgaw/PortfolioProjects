--Queries to use on Tableau


-- 1-Death Percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2

-- 2-Total death count
Select continent, SUM(cast(new_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
and location not in ('International','World','European Union')
group by continent
order by TotalDeathCount desc


-- 3-Percent Population Infected
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
from db_Covid19..CovidDeaths
where continent is not null
group by location, population
order by PercentagePopulationInfected desc

-- 4-Percentage of population infected by date
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
where continent is not null
Group by Location, Population, date
order by PercentPopulationInfected desc

