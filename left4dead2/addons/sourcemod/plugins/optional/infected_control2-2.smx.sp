/*
** [Ezrealik]提醒你：
** 反编译的代码是无法直接进行编译的！
** 反编译器只是给你一个大概,帮助你了解别人是如何编写插件的!
** 了解插件是如何工作的,是否有可能拥有恶意代码。
** 所有的转换仅仅是一种可能性,它很多都是错误的转换！例如：
** SetEntityRenderFx(client, RenderFx 0);
→  SetEntityRenderFx(client, view_as<RenderFx>0);
→  SetEntityRenderFx(client, RENDERFX_NONE);
*/

 PlVers __version = 5;
 float NULL_VECTOR[3];
 char NULL_STRING[1];
 Extension __ext_core = 68;
 int MaxClients;
 Extension __ext_sdktools = 2280;
 Extension __ext_sdkhooks = 2324;
 char L4DResourceName[7][0];
 char L4D2WeaponName[57][0];
 EngineVersion g_iEngine = 1952867692;
 StringMap g_hWeaponNameTrie = 1952867692;
 char L4D2WeaponWorldModel[57][0];
 SharedPlugin __pl_l4dh = 2368;
 char infected_name[7][0];
 Handle timertele;
 ConVar infected_spawn_interval;
 ConVar z_infected_limit;
 ConVar z_spawn_max;
 ConVar sb_escort;
 bool is_late;
 int SpawnMaxCount;
 ArrayList thread_handle;
 int ArraySpecial[6];
 int TargetPlayer;
 int survivors2[8];
 int numSurvivors2;
 int TeleCount[66];
 char CLASSNAME_INFECTED[3] = "infected";
 char CLASSNAME_WITCH[2] = "witch";
 char CLASSNAME_PHYSPROPS[4] = "prop_physics";
public Plugin myinfo =
{
	name = "AnneServer InfectedSpawn",
	description = "AnneServer InfectedSpawn",
	author = "Caibiii",
	version = "2022.02.24",
	url = "https://github.com/Caibiii/AnneServer"
};
public void __ext_core_SetNTVOptional()
{
	MarkNativeAsOptional("GetFeatureStatus");
	MarkNativeAsOptional("RequireFeature");
	MarkNativeAsOptional("AddCommandListener");
	MarkNativeAsOptional("RemoveCommandListener");
	MarkNativeAsOptional("BfWriteBool");
	MarkNativeAsOptional("BfWriteByte");
	MarkNativeAsOptional("BfWriteChar");
	MarkNativeAsOptional("BfWriteShort");
	MarkNativeAsOptional("BfWriteWord");
	MarkNativeAsOptional("BfWriteNum");
	MarkNativeAsOptional("BfWriteFloat");
	MarkNativeAsOptional("BfWriteString");
	MarkNativeAsOptional("BfWriteEntity");
	MarkNativeAsOptional("BfWriteAngle");
	MarkNativeAsOptional("BfWriteCoord");
	MarkNativeAsOptional("BfWriteVecCoord");
	MarkNativeAsOptional("BfWriteVecNormal");
	MarkNativeAsOptional("BfWriteAngles");
	MarkNativeAsOptional("BfReadBool");
	MarkNativeAsOptional("BfReadByte");
	MarkNativeAsOptional("BfReadChar");
	MarkNativeAsOptional("BfReadShort");
	MarkNativeAsOptional("BfReadWord");
	MarkNativeAsOptional("BfReadNum");
	MarkNativeAsOptional("BfReadFloat");
	MarkNativeAsOptional("BfReadString");
	MarkNativeAsOptional("BfReadEntity");
	MarkNativeAsOptional("BfReadAngle");
	MarkNativeAsOptional("BfReadCoord");
	MarkNativeAsOptional("BfReadVecCoord");
	MarkNativeAsOptional("BfReadVecNormal");
	MarkNativeAsOptional("BfReadAngles");
	MarkNativeAsOptional("BfGetNumBytesLeft");
	MarkNativeAsOptional("BfWrite.WriteBool");
	MarkNativeAsOptional("BfWrite.WriteByte");
	MarkNativeAsOptional("BfWrite.WriteChar");
	MarkNativeAsOptional("BfWrite.WriteShort");
	MarkNativeAsOptional("BfWrite.WriteWord");
	MarkNativeAsOptional("BfWrite.WriteNum");
	MarkNativeAsOptional("BfWrite.WriteFloat");
	MarkNativeAsOptional("BfWrite.WriteString");
	MarkNativeAsOptional("BfWrite.WriteEntity");
	MarkNativeAsOptional("BfWrite.WriteAngle");
	MarkNativeAsOptional("BfWrite.WriteCoord");
	MarkNativeAsOptional("BfWrite.WriteVecCoord");
	MarkNativeAsOptional("BfWrite.WriteVecNormal");
	MarkNativeAsOptional("BfWrite.WriteAngles");
	MarkNativeAsOptional("BfRead.ReadBool");
	MarkNativeAsOptional("BfRead.ReadByte");
	MarkNativeAsOptional("BfRead.ReadChar");
	MarkNativeAsOptional("BfRead.ReadShort");
	MarkNativeAsOptional("BfRead.ReadWord");
	MarkNativeAsOptional("BfRead.ReadNum");
	MarkNativeAsOptional("BfRead.ReadFloat");
	MarkNativeAsOptional("BfRead.ReadString");
	MarkNativeAsOptional("BfRead.ReadEntity");
	MarkNativeAsOptional("BfRead.ReadAngle");
	MarkNativeAsOptional("BfRead.ReadCoord");
	MarkNativeAsOptional("BfRead.ReadVecCoord");
	MarkNativeAsOptional("BfRead.ReadVecNormal");
	MarkNativeAsOptional("BfRead.ReadAngles");
	MarkNativeAsOptional("BfRead.BytesLeft.get");
	MarkNativeAsOptional("PbReadInt");
	MarkNativeAsOptional("PbReadFloat");
	MarkNativeAsOptional("PbReadBool");
	MarkNativeAsOptional("PbReadString");
	MarkNativeAsOptional("PbReadColor");
	MarkNativeAsOptional("PbReadAngle");
	MarkNativeAsOptional("PbReadVector");
	MarkNativeAsOptional("PbReadVector2D");
	MarkNativeAsOptional("PbGetRepeatedFieldCount");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetFloat");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbSetColor");
	MarkNativeAsOptional("PbSetAngle");
	MarkNativeAsOptional("PbSetVector");
	MarkNativeAsOptional("PbSetVector2D");
	MarkNativeAsOptional("PbAddInt");
	MarkNativeAsOptional("PbAddFloat");
	MarkNativeAsOptional("PbAddBool");
	MarkNativeAsOptional("PbAddString");
	MarkNativeAsOptional("PbAddColor");
	MarkNativeAsOptional("PbAddAngle");
	MarkNativeAsOptional("PbAddVector");
	MarkNativeAsOptional("PbAddVector2D");
	MarkNativeAsOptional("PbRemoveRepeatedFieldValue");
	MarkNativeAsOptional("PbReadMessage");
	MarkNativeAsOptional("PbReadRepeatedMessage");
	MarkNativeAsOptional("PbAddMessage");
	MarkNativeAsOptional("Protobuf.ReadInt");
	MarkNativeAsOptional("Protobuf.ReadInt64");
	MarkNativeAsOptional("Protobuf.ReadFloat");
	MarkNativeAsOptional("Protobuf.ReadBool");
	MarkNativeAsOptional("Protobuf.ReadString");
	MarkNativeAsOptional("Protobuf.ReadColor");
	MarkNativeAsOptional("Protobuf.ReadAngle");
	MarkNativeAsOptional("Protobuf.ReadVector");
	MarkNativeAsOptional("Protobuf.ReadVector2D");
	MarkNativeAsOptional("Protobuf.GetRepeatedFieldCount");
	MarkNativeAsOptional("Protobuf.SetInt");
	MarkNativeAsOptional("Protobuf.SetInt64");
	MarkNativeAsOptional("Protobuf.SetFloat");
	MarkNativeAsOptional("Protobuf.SetBool");
	MarkNativeAsOptional("Protobuf.SetString");
	MarkNativeAsOptional("Protobuf.SetColor");
	MarkNativeAsOptional("Protobuf.SetAngle");
	MarkNativeAsOptional("Protobuf.SetVector");
	MarkNativeAsOptional("Protobuf.SetVector2D");
	MarkNativeAsOptional("Protobuf.AddInt");
	MarkNativeAsOptional("Protobuf.AddInt64");
	MarkNativeAsOptional("Protobuf.AddFloat");
	MarkNativeAsOptional("Protobuf.AddBool");
	MarkNativeAsOptional("Protobuf.AddString");
	MarkNativeAsOptional("Protobuf.AddColor");
	MarkNativeAsOptional("Protobuf.AddAngle");
	MarkNativeAsOptional("Protobuf.AddVector");
	MarkNativeAsOptional("Protobuf.AddVector2D");
	MarkNativeAsOptional("Protobuf.RemoveRepeatedFieldValue");
	MarkNativeAsOptional("Protobuf.ReadMessage");
	MarkNativeAsOptional("Protobuf.ReadRepeatedMessage");
	MarkNativeAsOptional("Protobuf.AddMessage");
	VerifyCoreVersion();
	return void 0;
}

public float operator+(Float:,_:)(float oper1, int oper2)
{
	return FloatAdd(oper1, float(oper2));
}

public void MakeVectorFromPoints(float pt1[3], float pt2[3], float output[3])
{
	output[0] = FloatSub(pt2[0], pt1[0]);
	output[4] = FloatSub(pt2[4], pt1[4]);
	output[8] = FloatSub(pt2[8], pt1[8]);
	return void 0;
}

public bool StrEqual(char str1[], char str2[], bool caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

public int HasAnyCountFull()
{
	int class1 = 0;
	int class3 = 0;
	int class5 = 0;
	int class6 = 0;
	int count = 0;
	int survivors[4];
	int numSurvivors = 0;
	int i = 1;
	while (i <= MaxClients)
	{
		int var1;
		if (IsBotInfected(i))
		{
			int type = GetEntProp(i, PropType 0, "m_zombieClass", 4, 0);
			if (type <= 6)
			{
				count++;
			}
			switch (type)
			{
				case 1: {
					class1++;
					char cvar[16];
					Format(cvar, 16, "z_%s_limit", infected_name[class1][0][0]);
					if (ConVar.IntValue.get(FindConVar(cvar)) <= class1)
					{
						ArraySpecial[0] = 0;
					}
				}
				case 2: {
					ArraySpecial[4] = 0;
				}
				case 3: {
					class3++;
					char cvar[16];
					Format(cvar, 16, "z_%s_limit", infected_name[class3][0][0]);
					if (ConVar.IntValue.get(FindConVar(cvar)) <= class3)
					{
						ArraySpecial[8] = 0;
					}
				}
				case 4: {
					ArraySpecial[12] = 0;
				}
				case 5: {
					class5++;
					char cvar[16];
					Format(cvar, 16, "z_%s_limit", infected_name[class5][0][0]);
					if (ConVar.IntValue.get(FindConVar(cvar)) <= class5)
					{
						ArraySpecial[16] = 0;
					}
				}
				case 6: {
					class6++;
					char cvar[16];
					Format(cvar, 16, "z_%s_limit", infected_name[class6][0][0]);
					if (ConVar.IntValue.get(FindConVar(cvar)) <= class6)
					{
						ArraySpecial[20] = 0;
					}
				}
				default: {
				}
			}
		}
		int var2;
		if (IsSurvivor(i))
		{
			is_late = 1;
			if (numSurvivors < 4)
			{
				survivors[numSurvivors] = i;
				numSurvivors++;
				i++;
			}
			i++;
		}
		i++;
	}
	if (0 < numSurvivors)
	{
		TargetPlayer = survivors[GetRandomInt(0, numSurvivors + -1)];
	}
	else
	{
		TargetPlayer = L4D_GetHighestFlowSurvivor();
	}
	return count;
}

public bool PlayerVisibleTo(float spawnpos[3])
{
	float pos[3];
	numSurvivors2 = 0;
	int i = 1;
	while (i <= MaxClients)
	{
		int var1;
		if (IsSurvivor(i))
		{
			survivors2[numSurvivors2] = i;
			numSurvivors2 += 1;
			GetClientEyePosition(i, pos);
			int var2;
			if (PosIsVisibleTo(i, spawnpos))
			{
				return true;
			}
			i++;
		}
		i++;
	}
	return false;
}

public bool PosIsVisibleTo(int client, float targetposition[3])
{
	float position[3];
	float vAngles[3];
	float vLookAt[3];
	float spawnPos[3];
	GetClientEyePosition(client, position);
	MakeVectorFromPoints(targetposition, position, vLookAt);
	GetVectorAngles(vLookAt, vAngles);
	static Handle trace;
	trace = TR_TraceRayFilterEx(targetposition, vAngles, 24705, RayType 1, TraceEntityFilter 55, client);
	bool isVisible = 0;
	if (TR_DidHit(trace))
	{
		static float vStart[3];
		TR_GetEndPosition(2952, trace);
		if (__FLOAT_GE__(FloatAdd(75, GetVectorDistance(targetposition, 2952, false)), GetVectorDistance(position, targetposition, false)))
		{
			isVisible = 1;
		}
		else
		{
			int var1 = spawnPos[8];
			var1 = FloatAdd(40, var1);
			MakeVectorFromPoints(spawnPos, position, vLookAt);
			GetVectorAngles(vLookAt, vAngles);
			trace = TR_TraceRayFilterEx(spawnPos, vAngles, 24705, RayType 1, TraceEntityFilter 55, client);
			if (TR_DidHit(trace))
			{
				TR_GetEndPosition(2952, trace);
				if (__FLOAT_GE__(FloatAdd(75, GetVectorDistance(spawnPos, 2952, false)), GetVectorDistance(position, spawnPos, false)))
				{
					isVisible = 1;
				}
			}
			isVisible = 1;
		}
	}
	else
	{
		isVisible = 1;
	}
	CloseHandle(trace);
	__unk = 0;
	return isVisible;
}

public bool TracerayFilter(int entity, int contentMask)
{
	if (entity <= MaxClients)
	{
		return false;
	}
	char class[128];
	GetEdictClassname(entity, class, 128);
	int var1;
	if (StrEqual(class, CLASSNAME_INFECTED, false))
	{
		return false;
	}
	return true;
}

public bool IsOnValidMesh(float pos[3])
{
	Address pNavArea = L4D2Direct_GetTerrorNavArea(pos, 120);
	if (pNavArea)
	{
		return true;
	}
	return false;
}

public bool IsValidClient(int client)
{
	int var1;
	if (client > 0)
	{
		return true;
	}
	return false;
}

public bool IsPlayerStuck(float pos[3])
{
	bool isStuck = 1;
	float mins[3];
	float maxs[3];
	float pos2[3];
	pos2[0] = pos[0];
	pos2[4] = pos[4];
	pos2[8] = FloatAdd(35, pos[8]);
	mins[0] = -1048576000;
	mins[4] = -1048576000;
	mins[8] = 0;
	maxs[0] = 1098907648;
	maxs[4] = 1098907648;
	maxs[8] = 1108082688;
	TR_TraceHullFilter(pos, pos2, mins, maxs, 147467, TraceEntityFilter 55, any 0);
	isStuck = TR_DidHit(Handle 0);
	return isStuck;
}

public bool IsSurvivorPinned(int client)
{
	if (IsSurvivor(client))
	{
		if (0 < GetEntProp(client, PropType 0, "m_isIncapacitated", 4, 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_tongueOwner", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_pounceAttacker", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_carryAttacker", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_pummelAttacker", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_jockeyAttacker", 0))
		{
			return true;
		}
	}
	return false;
}

public bool IsPinningASurvivor(int client)
{
	int var1;
	if (IsBotInfected(client))
	{
		if (0 < GetEntPropEnt(client, PropType 0, "m_tongueVictim", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_pounceVictim", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_carryVictim", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_pummelVictim", 0))
		{
			return true;
		}
		if (0 < GetEntPropEnt(client, PropType 0, "m_jockeyVictim", 0))
		{
			return true;
		}
	}
	return false;
}

public bool IsSpecialInArray(int Array[6], int infected_type)
{
	int i = 0;
	while (i < 6)
	{
		if (Array[i] == infected_type)
		{
			return true;
		}
		i++;
	}
	return false;
}

public bool IsSurvivor(int client)
{
	int var1;
	if (client > 0)
	{
		return true;
	}
	return false;
}

public bool IsBotInfected(int client)
{
	int var1;
	if (client > 0)
	{
		return true;
	}
	return false;
}

public bool CanBeTP(int client)
{
	int var1;
	if (!IsClientInGame(client))
	{
		return false;
	}
	int var2;
	if (GetClientTeam(client) == 3)
	{
		return false;
	}
	if (GetEntProp(client, PropType 0, "m_zombieClass", 4, 0) == 8)
	{
		return false;
	}
	return true;
}

public Action L4D_OnShovedBySurvivor(int client, int victim, float vecDir[3])
{
	if (IsSpitter(victim))
	{
		return Action 3;
	}
	return Action 0;
}

public Action L4D2_OnEntityShoved(int client, int entity, int weapon, float vecDir[3], bool bIsHighPounce)
{
	if (IsSpitter(client))
	{
		return Action 3;
	}
	return Action 0;
}


/* ERROR! 无法将类型为“Lysis.DReturn”的对象强制转换为类型“Lysis.DJumpCondition”。 */
 函数 "IsInfected" (数量 19)
public bool IsSpitter(int client)
{
	if (!IsInfected(client))
	{
		return false;
	}
	if (!IsPlayerAlive(client))
	{
		return false;
	}
	if (GetEntProp(client, PropType 0, "m_zombieClass", 4, 0) != 4)
	{
		return false;
	}
	return true;
}

public void OnPluginStart()
{
	HookEvent("round_start", EventHook 45, EventHookMode 2);
	HookEvent("finale_win", EventHook 43, EventHookMode 2);
	HookEvent("map_transition", EventHook 43, EventHookMode 2);
	HookEvent("round_end", EventHook 43, EventHookMode 2);
	HookEvent("player_death", EventHook 63, EventHookMode 2);
	infected_spawn_interval = CreateConVar("versus_special_respawn_interval", "16.0", "", 0, false, 0, false, 0);
	z_infected_limit = CreateConVar("l4d_infected_limit", "4", "", 0, false, 0, false, 0);
	sb_escort = CreateConVar("sb_escort", "1", "", 0, false, 0, false, 0);
	z_spawn_max = CreateConVar("z_spawn_max", "500", "", 0, false, 0, false, 0);
	ConVar.SetInt(FindConVar("director_no_specials"), 1, false, false);
	thread_handle = ArrayList.ArrayList(1, 0);
	RegAdminCmd("sm_startspawn", startspawn, 16384, "restartspawn", "", 0);
	return void 0;
}

public Action startspawn(int client, any args)
{
	if (L4D_HasAnySurvivorLeftSafeArea())
	{
		CreateTimer(0.5, SpawnFirstInfected, any 0, 0);
	}
	return Action 0;
}

public void player_death(Event event, char name[], bool dont_broadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (IsBotInfected(client))
	{
		if (GetEntProp(client, PropType 0, "m_zombieClass", 4, 0) != 4)
		{
			CreateTimer(0.5, kickbot, client, 0);
		}
	}
	TeleCount[client] = 0;
	return void 0;
}

public Action kickbot(Handle timer, any client)
{
	int var1;
	if (IsClientInGame(client))
	{
		if (IsFakeClient(client))
		{
			KickClient(client, "");
		}
	}
	return Action 0;
}

public void OnRoundStart(Event event, char name[], bool dont_broadcast)
{
	CloseHandle(timertele);
	timertele = 0;
	is_late = 0;
	int i = 0;
	while (ArrayList.Length.get(thread_handle) > i)
	{
		KillTimer(ArrayList.Get(thread_handle, i, 0, false), false);
		ArrayList.Erase(thread_handle, i);
		i++;
	}
	CreateTimer(3, SafeRoomOthers, any 0, 2);
	return void 0;
}

public void OnRoundEnd(Event event, char name[], bool dont_broadcast)
{
	CloseHandle(timertele);
	timertele = 0;
	is_late = 0;
	int i = 0;
	while (ArrayList.Length.get(thread_handle) > i)
	{
		KillTimer(ArrayList.Get(thread_handle, i, 0, false), false);
		ArrayList.Erase(thread_handle, i);
		i++;
	}
	return void 0;
}

public Action SafeRoomOthers(Handle timer)
{
	int infectedBot = 1;
	while (infectedBot <= MaxClients)
	{
		int var1;
		if (IsBotInfected(infectedBot))
		{
			TeleCount[infectedBot] = 0;
		}
		int var2;
		if (IsSurvivor(infectedBot))
		{
			L4D_RespawnPlayer(infectedBot);
			infectedBot++;
		}
		infectedBot++;
	}
	return Action 0;
}

public Action SpawnFirstInfected(Handle timer)
{
	if (!is_late)
	{
		is_late = 1;
		if (__FLOAT_GT__(ConVar.FloatValue.get(infected_spawn_interval), 9))
		{
			Handle time = CreateTimer(FloatAdd(8, ConVar.FloatValue.get(infected_spawn_interval)), SpawnNewInfected, any 0, 1);
			ArrayList.Push(thread_handle, time);
			TriggerTimer(time, true);
		}
		else
		{
			Handle time = CreateTimer(FloatAdd(4, ConVar.FloatValue.get(infected_spawn_interval)), SpawnNewInfected, any 0, 1);
			ArrayList.Push(thread_handle, time);
			TriggerTimer(time, true);
		}
		timertele = CreateTimer(1, Timer_PositionSI, any 0, 1);
	}
	return Action 0;
}

public Action SpawnNewInfected(Handle timer)
{
	if (is_late)
	{
		if (ConVar.IntValue.get(z_infected_limit) > ArrayList.Length.get(thread_handle))
		{
			if (__FLOAT_GT__(ConVar.FloatValue.get(infected_spawn_interval), 9))
			{
				Handle time = CreateTimer(FloatAdd(8, ConVar.FloatValue.get(infected_spawn_interval)), SpawnNewInfected, any 0, 1);
				ArrayList.Push(thread_handle, time);
				TriggerTimer(time, true);
			}
			else
			{
				Handle time = CreateTimer(FloatAdd(4, ConVar.FloatValue.get(infected_spawn_interval)), SpawnNewInfected, any 0, 1);
				ArrayList.Push(thread_handle, time);
				TriggerTimer(time, true);
			}
		}
		else
		{
			if (ConVar.IntValue.get(z_infected_limit) < ArrayList.Length.get(thread_handle))
			{
				int i = 0;
				while (ArrayList.Length.get(thread_handle) > i)
				{
					if (timer == ArrayList.Get(thread_handle, i, 0, false))
					{
						ArrayList.Erase(thread_handle, i);
						return Action 4;
					}
					i++;
				}
			}
		}
		ConVar.IntValue.set(z_spawn_max, 250);
		SpawnMaxCount = SpawnMaxCount + 1;
		if (ConVar.IntValue.get(z_infected_limit) < SpawnMaxCount)
		{
			int index = ConVar.IntValue.get(z_infected_limit) + 2;
			if (SpawnMaxCount > index)
			{
				SpawnMaxCount = index;
			}
			ConVar.IntValue.set(sb_escort, 1);
		}
	}
	return Action 0;
}

public void OnGameFrame()
{
	int var1;
	if (is_late)
	{
		if (ConVar.IntValue.get(z_infected_limit) <= HasAnyCountFull())
		{
		}
		else
		{
			float spawnPos[3];
			float survivorPos[3];
			float direction[3];
			float traceImpact[3];
			float Mins[3];
			float Maxs[3];
			float dist = 0;
			int infected_type = GetRandomInt(1, 6);
			GetClientEyePosition(TargetPlayer, survivorPos);
			int var4 = z_spawn_max;
			ConVar.FloatValue.set(var4, ConVar.FloatValue.get(var4) + 5);
			if (__FLOAT_LT__(ConVar.FloatValue.get(z_spawn_max), 500))
			{
				dist = 1144750080;
				Maxs[8] = FloatAdd(500, survivorPos[8]);
			}
			else
			{
				dist = FloatAdd(250, ConVar.FloatValue.get(z_spawn_max));
				Maxs[8] = FloatAdd(survivorPos[8], ConVar.FloatValue.get(z_spawn_max));
			}
			Mins[0] = FloatSub(survivorPos[0], ConVar.FloatValue.get(z_spawn_max));
			Maxs[0] = FloatAdd(survivorPos[0], ConVar.FloatValue.get(z_spawn_max));
			Mins[4] = FloatSub(survivorPos[4], ConVar.FloatValue.get(z_spawn_max));
			Maxs[4] = FloatAdd(survivorPos[4], ConVar.FloatValue.get(z_spawn_max));
			direction[0] = 1119092736;
			direction[4] = 0;
			direction[8] = 0;
			spawnPos[0] = GetRandomFloat(Mins[0], Maxs[0]);
			spawnPos[4] = GetRandomFloat(Mins[4], Maxs[4]);
			spawnPos[8] = GetRandomFloat(survivorPos[8], Maxs[8]);
			int count2 = 0;
			while (!IsOnValidMesh(spawnPos) || IsPlayerStuck(spawnPos) || PlayerVisibleTo(spawnPos))
			{
				count2++;
				if (count2 > 50)
				{
					if (count2 <= 50)
					{
						int X = 0;
						while (X < numSurvivors2)
						{
							int index = survivors2[X][0][0];
							int count = 0;
							GetClientEyePosition(index, survivorPos);
							int var7 = survivorPos[8];
							var7 = FloatSub(var7, 60);
							if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, dist, false, false, 3, false))
							{
								while (!IsSpecialInArray(ArraySpecial, infected_type) && count < 50)
								{
									infected_type = GetRandomInt(1, 6);
									count++;
								}
								if (count > 49)
								{
									infected_type = 3;
								}
								L4D2_SpawnSpecial(infected_type, spawnPos, 3604);
								SpawnMaxCount = SpawnMaxCount + -1;
							}
							X++;
						}
					}
				}
				else
				{
					spawnPos[0] = GetRandomFloat(Mins[0], Maxs[0]);
					spawnPos[4] = GetRandomFloat(Mins[4], Maxs[4]);
					spawnPos[8] = GetRandomFloat(survivorPos[8], Maxs[8]);
					TR_TraceRay(spawnPos, direction, 147467, RayType 1);
					if (TR_DidHit(Handle 0))
					{
						TR_GetEndPosition(traceImpact, Handle 0);
						if (!IsOnValidMesh(traceImpact))
						{
							spawnPos[8] = FloatAdd(20, survivorPos[8]);
							TR_TraceRay(spawnPos, direction, 147467, RayType 1);
							if (TR_DidHit(Handle 0))
							{
								TR_GetEndPosition(traceImpact, Handle 0);
								int var5 = spawnPos[8];
								var5 = FloatAdd(20, var5);
							}
						}
						int var6 = spawnPos[8];
						var6 = FloatAdd(20, var6);
					}
				}
				if (count2 <= 50)
				{
					int X = 0;
					while (X < numSurvivors2)
					{
						int index = survivors2[X][0][0];
						int count = 0;
						GetClientEyePosition(index, survivorPos);
						int var7 = survivorPos[8];
						var7 = FloatSub(var7, 60);
						if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, dist, false, false, 3, false))
						{
							while (!IsSpecialInArray(ArraySpecial, infected_type) && count < 50)
							{
								infected_type = GetRandomInt(1, 6);
								count++;
							}
							if (count > 49)
							{
								infected_type = 3;
							}
							L4D2_SpawnSpecial(infected_type, spawnPos, 3604);
							SpawnMaxCount = SpawnMaxCount + -1;
						}
						X++;
					}
				}
			}
			if (count2 <= 50)
			{
				int X = 0;
				while (X < numSurvivors2)
				{
					int index = survivors2[X][0][0];
					int count = 0;
					GetClientEyePosition(index, survivorPos);
					int var7 = survivorPos[8];
					var7 = FloatSub(var7, 60);
					if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, dist, false, false, 3, false))
					{
						while (!IsSpecialInArray(ArraySpecial, infected_type) && count < 50)
						{
							infected_type = GetRandomInt(1, 6);
							count++;
						}
						if (count > 49)
						{
							infected_type = 3;
						}
						L4D2_SpawnSpecial(infected_type, spawnPos, 3604);
						SpawnMaxCount = SpawnMaxCount + -1;
					}
					X++;
				}
			}
		}
	}
	return void 0;
}

public Action Timer_PositionSI(Handle timer)
{
	int infectedBot = 1;
	while (infectedBot <= MaxClients)
	{
		int var1;
		if (IsBotInfected(infectedBot))
		{
			if (TeleCount[infectedBot][0][0] > 6)
			{
				float pos2[3];
				GetClientEyePosition(infectedBot, pos2);
				int var2;
				if (!PlayerVisibleTo(pos2))
				{
					SDKHook(infectedBot, SDKHookType 20, SDKHookCB 57);
					TeleCount[infectedBot] = 0;
				}
			}
			int var3 = TeleCount[infectedBot];
			var3 = var3[0][0] + 1;
			infectedBot++;
		}
		infectedBot++;
	}
	return Action 0;
}

public void UpdateThink(int infected_type)
{
	int var1;
	if (!IsValidClient(infected_type))
	{
		return void 0;
	}
	TeleCount[infected_type] = 0;
	static float pos2[3];
	GetClientEyePosition(infected_type, 3616);
	int var2;
	if (!PlayerVisibleTo(3616))
	{
		float spawnPos[3];
		float survivorPos[3];
		float direction[3];
		float traceImpact[3];
		float Mins[3];
		float Maxs[3];
		GetClientEyePosition(TargetPlayer, survivorPos);
		Mins[0] = FloatSub(survivorPos[0], 500);
		Maxs[0] = FloatAdd(500, survivorPos[0]);
		Mins[4] = FloatSub(survivorPos[4], 500);
		Maxs[4] = FloatAdd(500, survivorPos[4]);
		Maxs[8] = FloatAdd(500, survivorPos[8]);
		direction[0] = 1119092736;
		direction[4] = 0;
		direction[8] = 0;
		spawnPos[0] = GetRandomFloat(Mins[0], Maxs[0]);
		spawnPos[4] = GetRandomFloat(Mins[4], Maxs[4]);
		spawnPos[8] = GetRandomFloat(survivorPos[8], Maxs[8]);
		int count2 = 0;
		while (!IsOnValidMesh(spawnPos) || IsPlayerStuck(spawnPos) || PlayerVisibleTo(spawnPos))
		{
			count2++;
			if (count2 > 50)
			{
				if (count2 <= 50)
				{
					int X = 0;
					while (X < numSurvivors2)
					{
						int index = survivors2[X][0][0];
						GetClientEyePosition(index, survivorPos);
						int var6 = survivorPos[8];
						var6 = FloatSub(var6, 60);
						if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, 800, false, false, 3, false))
						{
							TeleportEntity(infected_type, spawnPos, NULL_VECTOR, NULL_VECTOR);
							SDKUnhook(infected_type, SDKHookType 20, SDKHookCB 57);
							X++;
						}
						X++;
					}
				}
			}
			else
			{
				spawnPos[0] = GetRandomFloat(Mins[0], Maxs[0]);
				spawnPos[4] = GetRandomFloat(Mins[4], Maxs[4]);
				spawnPos[8] = GetRandomFloat(survivorPos[8], Maxs[8]);
				TR_TraceRay(spawnPos, direction, 147467, RayType 1);
				if (TR_DidHit(Handle 0))
				{
					TR_GetEndPosition(traceImpact, Handle 0);
					if (!IsOnValidMesh(traceImpact))
					{
						spawnPos[8] = FloatAdd(20, survivorPos[8]);
						TR_TraceRay(spawnPos, direction, 147467, RayType 1);
						if (TR_DidHit(Handle 0))
						{
							TR_GetEndPosition(traceImpact, Handle 0);
							int var4 = spawnPos[8];
							var4 = FloatAdd(20, var4);
						}
					}
					int var5 = spawnPos[8];
					var5 = FloatAdd(20, var5);
				}
			}
			if (count2 <= 50)
			{
				int X = 0;
				while (X < numSurvivors2)
				{
					int index = survivors2[X][0][0];
					GetClientEyePosition(index, survivorPos);
					int var6 = survivorPos[8];
					var6 = FloatSub(var6, 60);
					if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, 800, false, false, 3, false))
					{
						TeleportEntity(infected_type, spawnPos, NULL_VECTOR, NULL_VECTOR);
						SDKUnhook(infected_type, SDKHookType 20, SDKHookCB 57);
						X++;
					}
					X++;
				}
			}
		}
		if (count2 <= 50)
		{
			int X = 0;
			while (X < numSurvivors2)
			{
				int index = survivors2[X][0][0];
				GetClientEyePosition(index, survivorPos);
				int var6 = survivorPos[8];
				var6 = FloatSub(var6, 60);
				if (L4D2_VScriptWrapper_NavAreaBuildPath(spawnPos, survivorPos, 800, false, false, 3, false))
				{
					TeleportEntity(infected_type, spawnPos, NULL_VECTOR, NULL_VECTOR);
					SDKUnhook(infected_type, SDKHookType 20, SDKHookCB 57);
					X++;
				}
				X++;
			}
		}
	}
	return void 0;
}

