Msg("DA3 Ambient\n");

DirectorOptions <-
{
	AlwaysAllowWanderers = true
	MobSpawnMinTime = 3500
	MobSpawnMaxTime = 3500
	MobMinSize = 10
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.6
	RelaxMinInterval = 25
	RelaxMaxInterval = 40
	RelaxMaxFlowTravel = 1100
	ZombieSpawnRange = 2600
	NumReservedWanderers = 10
	ZombieSpawnInFog = true
}

Director.ResetMobTimer()