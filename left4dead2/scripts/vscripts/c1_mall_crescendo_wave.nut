Msg("Initiating crescendo\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	MobSpawnMinTime = 20
	MobSpawnMaxTime = 20
	MobMinSize = 10
	MobMaxSize = 30
	MobMaxPending = 90
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 10
	RelaxMaxInterval = 15
	RelaxMaxFlowTravel = 600
	SpecialRespawnInterval = 10.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()