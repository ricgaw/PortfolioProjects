create database db_Covid19

drop table dbo.CovidVaccinations
drop table dbo.CovidDeaths

--Select the data we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from db_Covid19..CovidDeaths
where location like 'Brazil'
order by 1,2


--Looking at total cases versus total deaths
--Shows the likelihood of dying after contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from db_Covid19..CovidDeaths
--where location = 'United Kingdom'
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from db_Covid19..CovidDeaths
where location = 'Brazil'
order by 1,2

-- Looking at total cases versus population
--Shows what percentage of population got covid in Brazil

select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
from db_Covid19..CovidDeaths
where location = 'Brazil'
order by 1,2


-- Looking at total cases versus population
--Shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as CasesPercentage
from db_Covid19..CovidDeaths
--where location = 'United Kingdom'
order by 1,2


--Looking at countries with high infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from db_Covid19..CovidDeaths
group by location, population
order by PercentPopulationInfected desc


--Showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeaths
from db_Covid19..CovidDeaths
where continent not like ''
group by location
order by TotalDeaths desc



--Analysis by continent
select continent
from CovidDeaths
where continent is not null
group by continent

--Total death count by continent

select continent, max(cast(total_deaths as int)) as TotalDeaths
from db_Covid19..CovidDeaths
--where continent is null
group by continent
order by TotalDeaths desc

 
--Global analysis

--Showing how likely dying after contract covid per day

select date, SUM(new_cases) as TotalCases, SUM(Cast(new_deaths as int)) as TotalDeaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from db_Covid19..CovidDeaths
where continent not like ''
group by date
order by 1, 2


--Showing how likely dying after contract covid

select SUM(new_cases) as TotalCases, SUM(Cast(new_deaths as int)) as TotalDeaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from db_Covid19..CovidDeaths
where continent not like ''




--Looking at Population x Vaccination

select cd.location, cd.date, cd.population, cv.new_vaccinations
from db_Covid19..CovidDeaths cd
join db_Covid19..CovidVaccinations cv on 
	cd.location=cv.location
	and cd.date=cv.date
where cd.continent not like ''
order by 1,2


--Vaccination rollout

select cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as VaccineRollout
from db_Covid19..CovidDeaths cd
join db_Covid19..CovidVaccinations cv on 
	cd.location=cv.location
	and cd.date=cv.date
where cd.continent not like ''
order by 1,2

--Looking at Population fully vaccinated
 


--With CTE
WITH ctePopVsVacc (Location, Date, Population, new_vaccinations, VaccineRollout)
as
(
select cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as VaccineRollout
from db_Covid19..CovidDeaths cd
join db_Covid19..CovidVaccinations cv on 
	cd.location=cv.location
	and cd.date=cv.date
where cd.continent not like ''
)
select *, (VaccineRollout/Population)*100 as VaccinationPercentage
from ctePopVsVacc
--where location 




--Temp Table
drop table if exists #PercentPopulationVaccinated
Create table  #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations nvarchar (255),
VaccineRollout numeric,
)

insert into #PercentPopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as VaccineRollout
from db_Covid19..CovidDeaths cd
join db_Covid19..CovidVaccinations cv on 
	cd.location=cv.location
	and cd.date=cv.date
--where cd.continent not like ''
--order by 2,3

select *, (VaccineRollout/Population)*100 as VaccinationPercentage
from #PercentPopulationVaccinated





--Create View
Create View PopulationPercentageVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(convert(int, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as VaccineRollout
from db_Covid19..CovidDeaths cd
join db_Covid19..CovidVaccinations cv on 
	cd.location=cv.location
	and cd.date=cv.date
where cd.continent not like ''
--order by 2,3


