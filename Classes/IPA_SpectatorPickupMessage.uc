class IPA_SpectatorPickupMessage extends IPA_PickupMessage;
    
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
defaultproperties {
    Lifetime=6
}