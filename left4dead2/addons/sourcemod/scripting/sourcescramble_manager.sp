/**
 * SourceScramble Manager
 * 
 * A loader for simple memory patches.
 */
#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <sourcescramble>

#define PLUGIN_VERSION "1.2.0"
public Plugin myinfo =
{
	name = "Source Scramble Manager",
	author = "nosoop",
	description = "Helper plugin to load simple assembly patches from a configuration file.",
	version = PLUGIN_VERSION,
	url = "https://github.com/nosoop/SMExt-SourceScramble"
}

public void OnPluginStart()
{
	SMCParser parser = new SMCParser();
	parser.OnKeyValue = smcPatchMemConfigEntry;
	
	char sConfigFile[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sConfigFile, sizeof sConfigFile, "configs/sourcescramble_manager.cfg");
	parser.ParseFile(sConfigFile);
	
	char sConfigDirectory[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sConfigDirectory, sizeof sConfigDirectory, "configs/sourcescramble");
	if(DirExists(sConfigDirectory))
	{
		DirectoryListing dlConfig = OpenDirectory(sConfigDirectory, true);
		if(dlConfig)
		{
			char sEntryPath[PLATFORM_MAX_PATH];
			FileType dlEntryType;
			while(dlConfig.GetNext(sEntryPath, sizeof sEntryPath, dlEntryType))
			{
				if(dlEntryType != FileType_File)
					continue;

				FormatEx(sConfigFile, sizeof sConfigFile, "%s/%s", sConfigDirectory, sEntryPath);
				parser.ParseFile(sConfigFile);
			}

			delete dlConfig;
		}
	}

	delete parser;
}

SMCResult smcPatchMemConfigEntry(SMCParser smc, const char[] key, const char[] value, bool key_quotes, bool value_quotes)
{
	GameData hGameData = new GameData(key);
	if(!hGameData)
	{
		LogError("Failed to load \"%s.txt\" gamedata.", key);
		return SMCParse_Continue;
	}

	// patches are cleaned up when the plugin is unloaded
	MemoryPatch patch = MemoryPatch.CreateFromConf(hGameData, value);
	delete hGameData;

	if(!patch.Validate())
		LogError("[sourcescramble] Failed to verify patch \"%s\" from \"%s\"", value, key);
	else if(patch.Enable())
		PrintToServer("[sourcescramble] Enabled patch \"%s\" from \"%s\" at address: 0x%08X", value, key, patch.Address);

	return SMCParse_Continue;
}
