#pragma semicolon 1

#include <sourcemod>
#include <builtinvotes>
#include <colors>

public Plugin:myinfo =
{
	name = "Vote for run command or cfg file",
	description = "使用!vote投票执行命令或cfg文件",
	author = "东",
	version = "1.0",
	url = "https://github.com/fantasylidong/"
};

Handle
	g_hVote,
	g_hVoteKick,	
	g_hCfgsKV;

char
	g_sCfg[32],
	g_skickplayername[32];


public OnPluginStart()
{
	char g_sBuffer[128];
	GetGameFolderName(g_sBuffer, sizeof(g_sBuffer));
	RegConsoleCmd("sm_vote", VoteRequest);
	RegConsoleCmd("sm_votekick", KickRequest);
	RegAdminCmd("sm_cancelvote", VoteCancle, ADMFLAG_GENERIC, "管理员终止此次投票", "", 0);
	g_hCfgsKV = CreateKeyValues("Cfgs", "", "");
	BuildPath(Path_SM, g_sBuffer, 128, "configs/cfgs.txt");
	if (!FileToKeyValues(g_hCfgsKV, g_sBuffer))
	{
		SetFailState("无法加载cfgs.txt文件!");
	}
}

public Action VoteCancle(int client, int args)
{
	if (IsBuiltinVoteInProgress())
	{
		CancelBuiltinVote();
		PrintToChatAll("\x03管理员取消了当前投票!");
		return Plugin_Handled;
	}
	ReplyToCommand(client, "没有投票在进行!");
	return Plugin_Handled;
}

public Action VoteRequest(int client, int args)
{
	if (!client)
	{
		return Plugin_Handled;
	}
	if (IsClientConnected(client) && IsClientInGame(client) &&(GetClientTeam(client) < 2))
	{
		PrintToChat(client, "[\x05vote\x01]\x03旁观者不允许投票执行命令或cfg文件!");
	}
	if (args > 0)
	{
		char sCfg[64];
		char sBuffer[256];
		GetCmdArg(1, sCfg, sizeof(sCfg));
		BuildPath(Path_SM, sBuffer, 256, "../../cfg/%s", sCfg);
		if (DirExists(sBuffer))
		{
			FindConfigName(sCfg, sBuffer, 256);
			if (StartVote(client, sBuffer))
			{
				strcopy(g_sCfg, 32, sCfg);
				FakeClientCommand(client, "Vote Yes");
			}
			return Plugin_Handled;
		}
	}
	ShowVoteMenu(client);
	return Plugin_Handled;
}

bool FindConfigName(char[] cfg, char[] message, int maxlength)
{
	KvRewind(g_hCfgsKV);
	if (KvGotoFirstSubKey(g_hCfgsKV, true))
	{
		while (KvJumpToKey(g_hCfgsKV, cfg, false))
		{
			if (KvGotoNextKey(g_hCfgsKV, true))
			{
			}
		}
		KvGetString(g_hCfgsKV, "message", message, maxlength, "");
		return true;
	}
	return false;
}

void ShowVoteMenu(int client)
{
	Handle hMenu = CreateMenu(VoteMenuHandler, MENU_ACTIONS_DEFAULT);
	SetMenuTitle(hMenu, "选择:");
	char sBuffer[64];
	KvRewind(g_hCfgsKV);
	if (KvGotoFirstSubKey(g_hCfgsKV, true))
	{
		do {
			KvGetSectionName(g_hCfgsKV, sBuffer, sizeof(sBuffer));
			AddMenuItem(hMenu, sBuffer, sBuffer, ITEMDRAW_DEFAULT);
		} while (KvGotoNextKey(g_hCfgsKV, true));
	}
	DisplayMenu(hMenu, client, 20);
}

public int VoteMenuHandler(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char sInfo[64];
		char sBuffer[64];
		GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
		KvRewind(g_hCfgsKV);
		if (KvJumpToKey(g_hCfgsKV, sInfo, false) && KvGotoFirstSubKey(g_hCfgsKV, true))
		{
			Handle hMenu = CreateMenu(ConfigsMenuHandler, MENU_ACTIONS_DEFAULT);
			Format(sBuffer, 64, "选择 %s :", sInfo);
			SetMenuTitle(hMenu, sBuffer);
			do {
				KvGetSectionName(g_hCfgsKV, sInfo, 64);
				KvGetString(g_hCfgsKV, "message", sBuffer, 64, "");
				AddMenuItem(hMenu, sInfo, sBuffer, 0);
			} while (KvGotoNextKey(g_hCfgsKV, true));
			DisplayMenu(hMenu, param1, 20);
		}
		else
		{
			PrintToChat(param1, "没有相关的文件存在.");
			ShowVoteMenu(param1);
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	return 0;
}

public int ConfigsMenuHandler(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char sInfo[64];
		char sBuffer[64];
		GetMenuItem(menu, param2, sInfo, sizeof(sInfo));
		strcopy(g_sCfg, 32, sInfo);
		if (!StrEqual(g_sCfg, "sm_votekick", true))
		{
			if (StartVote(param1, sBuffer))
			{
				FakeClientCommand(param1, "Vote Yes");
			}
			else
			{
				ShowVoteMenu(param1);
			}
		}
		else
		{
			FakeClientCommand(param1, "sm_votekick");
		}
	}
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
	if (action == MenuAction_Cancel)
	{
		ShowVoteMenu(param1);
	}
	return 0;
}

bool StartVote(int client, char[] cfgname)
{
	if (!IsBuiltinVoteInProgress())
	{
		new iNumPlayers;
		decl iPlayers[MaxClients];
		new i = 1;
		while (i <= MaxClients)
		{
			if (!IsClientInGame(i) || IsFakeClient(i))
			{
			}
			else
			{
				iNumPlayers++;
				iPlayers[iNumPlayers] = i;
			}
			i++;
		}
		new String:sBuffer[64];
		g_hVote = CreateBuiltinVote(VoteActionHandler, BuiltinVoteType_Custom_YesNo, BUILTINVOTE_ACTIONS_DEFAULT);
		Format(sBuffer, 64, "执行 '%s' ?", cfgname);
		SetBuiltinVoteArgument(g_hVote, sBuffer);
		SetBuiltinVoteInitiator(g_hVote, client);
		SetBuiltinVoteResultCallback(g_hVote, VoteResultHandler);
		DisplayBuiltinVoteToAll(g_hVote, 12);
		PrintToChatAll("\x03%N 发表了一个投票", client);
		return true;
	}
	PrintToChat(client, "已经有一个投票正在进行.");
	return false;
}

public void VoteActionHandler(Handle vote, BuiltinVoteAction action, int param1, int param2)
{
	switch (action)
	{
		case BuiltinVoteAction_End:
		{
			g_hVote = INVALID_HANDLE;
			CloseHandle(vote);
		}
		case BuiltinVoteAction_Cancel:
		{
			DisplayBuiltinVoteFail(vote, BuiltinVoteFailReason:param1);
		}
	}
}

public void VoteResultHandler(Handle vote, int num_votes, int num_clients, const int[][] client_info, int num_items, const int[][] item_info)
{
	for (int i = 0; i< num_items; i++)
	{
		if (item_info[i][BUILTINVOTEINFO_ITEM_INDEX] == BUILTINVOTES_VOTE_YES)
		{
			if (item_info[i][BUILTINVOTEINFO_ITEM_VOTES] > (num_votes / 2))
			{
				if (g_hVote == vote)
				{
					DisplayBuiltinVotePass(vote, "文件正在加载...");
					ServerCommand("%s", g_sCfg);
					return;
				}
				if (g_hVoteKick == vote)
				{
					DisplayBuiltinVotePass(vote, "投票已完成...");
					ServerCommand("sm_kick %s 投票踢出", g_skickplayername);
					return;
				}
			}
		}
	}
	DisplayBuiltinVoteFail(vote, BuiltinVoteFail_Loses);
}

public Action KickRequest(int client, int args)
{
	if (client && client <= MaxClients)
	{
		CreateVotekickMenu(client);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

void CreateVotekickMenu(client)
{
	Handle menu = CreateMenu(Menu_Voteskick, MENU_ACTIONS_DEFAULT);
	char name[32];
	char info[40];
	char playerid[32];
	SetMenuTitle(menu, "选择踢出玩家");
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			Format(playerid, 32, "%i", GetClientUserId(i));
			if (GetClientName(i, name, 32))
			{
				Format(info, 38, "%s", name);
				AddMenuItem(menu, playerid, info, ITEMDRAW_DEFAULT);
			}
		}
		i++;
	}
	DisplayMenu(menu, client, 30);
}

public int Menu_Voteskick(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char name[32];
		GetMenuItem(menu, param2, name, sizeof(name));
		g_skickplayername = name;
		PrintToChatAll("\x04%N 发起投票踢出 \x05 %s", param1, g_skickplayername);
		if (DisplayVoteKickMenu(param1))
		{
			FakeClientCommand(param1, "Vote Yes");
		}
	}
	return 0;
}

public bool DisplayVoteKickMenu(client)
{
	if (!IsBuiltinVoteInProgress())
	{
		int iNumPlayers;
		int iPlayers[MAXPLAYERS];
		int i = 1;
		while (i <= MAXPLAYERS)
		{
			if (!IsClientInGame(i) || IsFakeClient(i))
			{
			}
			else
			{
				iNumPlayers++;
				iPlayers[iNumPlayers] = i;
			}
			i++;
		}
		char sBuffer[64];
		g_hVoteKick = CreateBuiltinVote(VoteActionHandler, BuiltinVoteType_Custom_YesNo, BUILTINVOTE_ACTIONS_DEFAULT);
		Format(sBuffer, 64, "踢出 '%s' ?", g_skickplayername);
		SetBuiltinVoteArgument(g_hVoteKick, sBuffer);
		SetBuiltinVoteInitiator(g_hVoteKick, client);
		SetBuiltinVoteResultCallback(g_hVoteKick, VoteResultHandler);
		DisplayBuiltinVoteToAll(g_hVoteKick, 10);
		PrintToChatAll("\x03%N 发表了一个投票", client);
		return true;
	}
	PrintToChat(client, "已经有一个投票正在进行.");
	return false;
}