global function InstantRespawn_Init

struct
{
	bool instantRespawnEnabled = true
	bool instantRespawnRegistered = false
} file

void function InstantRespawn_Init()
{
	RegisterInstantRespawnDelay()
	RegisterServerVarChangeCallback( "respawnAvailableBits", TryRespawn )
}

void function TryRespawn()
{
	entity player = GetLocalClientPlayer()
	if( RespawnSelect_ShouldShowRespawnAsPilot( player ) && file.instantRespawnEnabled )
	{
		WaitFrame()
		player.ClientCommand( "CC_RespawnPlayer Pilot" )
	}
}

void function RegisterInstantRespawnDelay()
{
	if( file.instantRespawnRegistered )
		return
		
	RegisterButtonPressedCallback(KEY_LSHIFT, PlayerPressed_DelayRespawn)
	RegisterButtonReleasedCallback(KEY_LSHIFT, PlayerReleased_DelayRespawn)
	file.instantRespawnRegistered = true
}

void function PlayerPressed_DelayRespawn( entity player )
{
	if ( !file.instantRespawnEnabled )
		return

	file.instantRespawnEnabled = false
		
}

void function PlayerReleased_DelayRespawn( entity player )
{
	if ( file.instantRespawnEnabled )
		return
		
	file.instantRespawnEnabled = true
}

//stolen from cl_respawnselect.gnut
bool function RespawnSelect_ShouldShowRespawnAsPilot( entity player )
{
	if ( IsAlive( player ) && !IsWatchingKillReplay() )
	{
		//printt( "IsAlive( player )" )
		return false
	}

	if ( IsPlayerEliminated( player ) )
	{
		//printt( "IsPlayerEliminated( player )" )
		return false
	}

	if ( !IsRespawnAvailable( player ) )
	{
		//printt( "!IsRespawnAvailable( player )" )
		return false
	}

	if ( GetGameState() != eGameState.Playing && GetGameState() != eGameState.Epilogue && GetGameState() != eGameState.WinnerDetermined )
	{
		//printt( " GetGameState() != ...", GetGameState() )
		return false
	}

	return true
}