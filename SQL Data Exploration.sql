Select *
From PortfolioProject..CovidDeaths
where continent is not null
Order by 3, 4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1, 2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%australia%'
where continent is not null
Order by 1, 2

Select Location, date, population, total_cases, (total_cases/population)*100 as CasesPerPopulation
From PortfolioProject..CovidDeaths
--Where location like '%australia%'
where continent is not null
Order by 1, 2

Select Location, population, max(total_cases) as HigestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%australia%'
where continent is not null
Group By Location, population
Order by PercentPopulationInfected desc

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group By Location
Order by TotalDeathCount desc

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group By continent
Order by TotalDeathCount desc

Select date, sum(new_cases), sum(cast(new_deaths as int)), (Sum(CAST(new_deaths as int))/sum(new_cases))*100 as deathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
Order by 1, 2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
, 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2, 3

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3

Select *
From PercentPopulationVaccinated