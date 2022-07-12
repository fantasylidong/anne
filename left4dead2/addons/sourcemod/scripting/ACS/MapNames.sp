void WriteConfigFileDescriptionInfo(Handle hFile)
{
	WriteFileLine(hFile, "// Automatic Campaign Switcher (ACS) Map List Config File");
	WriteFileLine(hFile, "// ======================================================");
	WriteFileLine(hFile, "// This file was automatically generated by ACS %s", PLUGIN_VERSION);
	WriteFileLine(hFile, "// ");
	WriteFileLine(hFile, "// USAGE");
	WriteFileLine(hFile, "// 1) Each row represents one map for one game mode.");
	WriteFileLine(hFile, "// 2) The order the maps are listed here controls the order in game.");
	WriteFileLine(hFile, "// 3) Custom maps work, as long as the server can load the map.");
	WriteFileLine(hFile, "// 4) There is a hardcoded limit of 200 maps, changeable in the source.");
	WriteFileLine(hFile, "// 5) CAMPAIGN, SCAVENGE, and SURVIVAL are the only game modes needed.");
	WriteFileLine(hFile, "// 6) SCAVENGE and SURVIVAL do not require a END_MAP_NAME.");
	WriteFileLine(hFile, "// 7) Changes made while server is running will be loaded on next map change.");
	WriteFileLine(hFile, "// 8) Check server console output to see if everything loaded into ACS properly.");
	WriteFileLine(hFile, "// ");
	WriteFileLine(hFile, "// COLUMN HEADERS");
	WriteFileLine(hFile, "// GAMEMODE, MAP_DESCRIPTION, START_MAP_NAME, END_MAP_NAME");
}

// The order these are defined for each game mode sets the map rotation
char g_strDefaultMapListArray[][][64] = {

	// GAMEMODE  MAP_DESCRIPTION                    START_MAP_NAME          END_MAP_NAME

	// Campaign (Coop/Versus)
	{"CAMPAIGN", "No Mercy",                        "c8m1_apartment",       "c8m5_rooftop"},
	{"CAMPAIGN", "Crash Course",                    "c9m1_alleys",          "c9m2_lots"},
	{"CAMPAIGN", "Death Toll",                      "c10m1_caves",          "c10m5_houseboat"},
	{"CAMPAIGN", "Dead Air",                        "c11m1_greenhouse",     "c11m5_runway"},
	{"CAMPAIGN", "Blood Harvest",                   "c12m1_hilltop",        "c12m5_cornfield"},
	{"CAMPAIGN", "The Sacrifice",                   "c7m1_docks",           "c7m3_port"},
	{"CAMPAIGN", "Dead Center",                     "c1m1_hotel",           "c1m4_atrium"},
	{"CAMPAIGN", "The Passing",                     "c6m1_riverbank",       "c6m3_port"},
	{"CAMPAIGN", "Dark Carnival",                   "c2m1_highway",         "c2m5_concert"},
	{"CAMPAIGN", "Swamp Fever",                     "c3m1_plankcountry",    "c3m4_plantation"},
	{"CAMPAIGN", "Hard Rain",                       "c4m1_milltown_a",      "c4m5_milltown_escape"},
	{"CAMPAIGN", "The Parish",                      "c5m1_waterfront",      "c5m5_bridge"},
	{"CAMPAIGN", "Cold Stream",                     "c13m1_alpinecreek",    "c13m4_cutthroatcreek"},
	{"CAMPAIGN", "The Last Stand",                  "c14m1_junkyard",       "c14m2_lighthouse"},

	// Scavenge
	{"SCAVENGE", "No Mercy: The Apartments",        "c8m1_apartment",       ""},
	{"SCAVENGE", "No Mercy: The Rooftop",           "c8m5_rooftop",         ""},
	{"SCAVENGE", "Crash Course: The Alleys",        "c9m1_alleys",          ""},
	{"SCAVENGE", "Death Toll: The Church",          "c10m3_ranchhouse",     ""},
	{"SCAVENGE", "Dead Air: The Terminal",          "c11m4_terminal",       ""},
	{"SCAVENGE", "Blood Harvest: The Farmhouse",    "c12m5_cornfield",      ""},
	{"SCAVENGE", "The Sacrifice: Brick Factory",    "c7m1_docks",           ""},
	{"SCAVENGE", "The Sacrifice: Barge",            "c7m2_barge",           ""},
	{"SCAVENGE", "Dead Center: Mall Atrium",        "c1m4_atrium",          ""},
	{"SCAVENGE", "The Passing: Riverbank",          "c6m1_riverbank",       ""},
	{"SCAVENGE", "The Passing: Underground",        "c6m2_bedlam",          ""},
	{"SCAVENGE", "The Passing: Port",               "c6m3_port",            ""},
	{"SCAVENGE", "Dark Carnival: Motel",            "c2m1_highway",         ""},
	{"SCAVENGE", "Swamp Fever: Plank Country",      "c3m1_plankcountry",    ""},
	{"SCAVENGE", "Hard Rain: Milltown",             "c4m1_milltown_a",      ""},
	{"SCAVENGE", "Hard Rain: Sugar Mill",           "c4m2_sugarmill_a",     ""},
	{"SCAVENGE", "The Parish: Park",                "c5m2_park",            ""},
	{"SCAVENGE", "The Last Stand: The Village",     "c14m1_junkyard",       ""},
	{"SCAVENGE", "The Last Stand: The Lighthouse",  "c14m2_lighthouse",     ""},    

	// Survival
	{"SURVIVAL", "No Mercy: Generator Room",        "c8m2_subway",          ""},
	{"SURVIVAL", "No Mercy: Rooftop",               "c8m5_rooftop",         ""},
	{"SURVIVAL", "Crash Course: Truck Depot",       "c9m2_lots",            ""},
	{"SURVIVAL", "The Sacrifice: Train Car",        "c7m1_docks",           ""},
	{"SURVIVAL", "The Sacrifice: Port",             "c7m3_port",            ""},
	{"SURVIVAL", "Dead Center: Mall Atrium",        "c1m4_atrium",          ""},
	{"SURVIVAL", "The Passing: Riverbank",          "c6m1_riverbank",       ""},
	{"SURVIVAL", "The Passing: Underground",        "c6m2_bedlam",          ""},
	{"SURVIVAL", "The Passing: Port",               "c6m3_port",            ""},
	{"SURVIVAL", "Dark Carnival: Motel",            "c2m1_highway",         ""},
	{"SURVIVAL", "Dark Carnival: Stadium Gate",     "c2m4_barns",           ""},
	{"SURVIVAL", "Dark Carnival: Concert",          "c2m5_concert",         ""},
	{"SURVIVAL", "Swamp Fever: Gator Village",      "c3m1_plankcountry",    ""},
	{"SURVIVAL", "Swamp Fever: Plantation",         "c3m4_plantation",      ""},
	{"SURVIVAL", "Hard Rain: Burger Tank",          "c4m1_milltown_a",      ""},
	{"SURVIVAL", "Hard Rain: Sugar Mill",           "c4m2_sugarmill_a",     ""},
	{"SURVIVAL", "The Parish: Bus Depot",           "c5m2_park",            ""},
	{"SURVIVAL", "The Parish: Bridge",              "c5m5_bridge",          ""},
	{"SURVIVAL", "The Last Stand: Junkyard",        "c14m1_junkyard",       ""},
	{"SURVIVAL", "The Last Stand: Lighthouse",      "c14m2_lighthouse",     ""},
};

