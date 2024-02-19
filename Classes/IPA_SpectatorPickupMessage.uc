class IPA_SpectatorPickupMessage extends IPA_PickupMessage;
	
static function float GetOffset(int Switch, float YL, float ClipY )
{
	return ClipY - YL - (default.Ypos/768)*ClipY;
}