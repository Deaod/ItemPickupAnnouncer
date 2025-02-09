class IPA_PickupMessage extends PickupMessagePlus;
	
var localized string PickedUp;

static final function string ApplyParameters(
	coerce string FormatString,
	optional coerce string Param1,
	optional coerce string Param2,
	optional coerce string Param3,
	optional coerce string Param4
) {
	local string Result;
	local int OpenPos;
	local int ClosePos;
	local int Index;
	local string Params[5];

	Params[1] = Param1;
	Params[2] = Param2;
	Params[3] = Param3;
	Params[4] = Param4;

	OpenPos = InStr(FormatString, "{");
	while (OpenPos >= 0) {
		Result = Result $ Left(FormatString, OpenPos);
		FormatString = Mid(FormatString, OpenPos+1);
		ClosePos = InStr(FormatString, "}");
		if (ClosePos == -1)
			return Result $ FormatString;
		
		Index = int(Left(FormatString, ClosePos));
		FormatString = Mid(FormatString, ClosePos+1);
		if (Index > 0 && Index < arraycount(Params))
			Result = Result $ Params[Index];

		OpenPos = InStr(FormatString, "{");
	}

	return Result$FormatString;
}

static function float GetOffset(int Switch, float YL, float ClipY)
{
    local float BaseOffset;
    local float MessageSpacing;
    
    // Base offset (original position)
    BaseOffset = ClipY - YL - (64.0/768)*ClipY;
    
    // Vertical space between multiple messages so they don't overlap (adjust this value as needed)
    MessageSpacing = 25.0;
    
    // Use Switch parameter for position
    return BaseOffset - (Switch * MessageSpacing);
}

static function string GetString(
	optional int Switch, // always 0
	optional PlayerReplicationInfo RelatedPRI_1, // player that picked up the item
	optional PlayerReplicationInfo RelatedPRI_2, // always none
	optional Object OptionalObject // class of item that was picked up
) {
	if (OptionalObject != none && RelatedPRI_1 != none)
		return ApplyParameters(default.PickedUp, RelatedPRI_1.PlayerName, class<Inventory>(OptionalObject).default.ItemName);
}

defaultproperties {
	PickedUp="{1} picked up {2}"
	Lifetime=3
	bIsUnique=False
}
