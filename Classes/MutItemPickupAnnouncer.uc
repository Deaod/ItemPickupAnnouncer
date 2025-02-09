class MutItemPickupAnnouncer extends Mutator
	config;

var localized string MutatorName;
var localized string MutatorDescription;

var config array<name> IncludedBaseClasses;
var config array<name> IncludedExactClasses;
var config array<name> ExcludedExactClasses;

var int MessageCounter;
var float SequenceStartTime;

function bool IsBasedOnIncludedClass(Inventory Item) {
	local int i;

	for (i = 0; i < IncludedBaseClasses.Length; i++)
		if (Item.IsA(IncludedBaseClasses[i]))
			return true;

	return false;
}

function bool IsAnIncludedClass(Inventory Item) {
	local int i;

	for (i = 0; i < IncludedExactClasses.Length; i++)
		if (Item.Class.Name == IncludedExactClasses[i])
			return true;

	return false;
}

function bool IsAnExcludedClass(Inventory Item) {
	local int i;

	for (i = 0; i < ExcludedExactClasses.Length; i++)
		if (Item.Class.Name == ExcludedExactClasses[i])
			return true;

	return false;
}

function AnnounceItemPickup(PlayerReplicationInfo PRI, Object ItemClass) {
    local Pawn P;
    local class<LocalMessage> Message;
    local PlayerReplicationInfo PRI1;
    local PlayerReplicationInfo PRI2;
    local Object OptObj;
    
    // Check if current sequence has expired (using 3 second lifetime)
    if (Level.TimeSeconds - SequenceStartTime > 3.0) {
        MessageCounter = 0;
        SequenceStartTime = Level.TimeSeconds;
    } else {
        MessageCounter = (MessageCounter + 1) % 6;
    }
    
    Message = class'IPA_PickupMessage';
    PRI1 = PRI;
    PRI2 = none;
    OptObj = ItemClass;

    for (P = Level.PawnList; P != none; P = P.NextPawn)
        if ((P.bIsPlayer || P.IsA('MessagingSpectator')) &&
            (P != PRI.Owner) &&
            (P.IsA('Spectator') || (Level.Game.bTeamGame && P.PlayerReplicationInfo.Team == PRI.Team)) &&
            (
                Level.Game.MessageMutator == none ||
                Level.Game.MessageMutator.MutatorBroadcastLocalizedMessage(self, P, Message, MessageCounter, PRI1, PRI2, OptObj)
            )
        ) {
            if (P.IsA('Spectator')) {
                Message = class'IPA_SpectatorPickupMessage';
            } else {
                Message = class'IPA_PickupMessage';
            }
            P.ReceiveLocalizedMessage(Message, MessageCounter, PRI1, PRI2, OptObj);
        }
}

function bool HandlePickupQuery(Pawn Other, Inventory Item, out byte bAllowPickup) {
	if (IsAnExcludedClass(Item) == false)
		if (IsAnIncludedClass(Item) || IsBasedOnIncludedClass(Item))
			AnnounceItemPickup(Other.PlayerReplicationInfo, Item.Class);

	return super.HandlePickupQuery(Other, Item, bAllowPickup);
}

function PreBeginPlay() {
	super.PreBeginPlay();

	if (IncludedBaseClasses.Length == 0 &&
		IncludedExactClasses.Length == 0 &&
		ExcludedExactClasses.Length == 0
	) {
		IncludedBaseClasses.Insert(0, 11);
		IncludedBaseClasses[0]='ShieldBelt';
		IncludedBaseClasses[1]='UT_ShieldBelt';
		IncludedBaseClasses[2]='Armor';
		IncludedBaseClasses[3]='Armor2';
		IncludedBaseClasses[4]='ThighPads';
		IncludedBaseClasses[5]='HealthPack';
		IncludedBaseClasses[6]='UDamage';
		IncludedBaseClasses[7]='UT_Invisibility';
		IncludedBaseClasses[8]='Invisibility';
		IncludedBaseClasses[9]='UT_JumpBoots';
		IncludedBaseClasses[10]='JumpBoots';
		SaveConfig();
	}

	if ((Level.EngineVersion$Level.GetPropertyText("EngineRevision")) >= "469c")
		AddToPackageMap(string(Class.Outer.Name));
}

defaultproperties {
	MutatorName="Item Pickup Announcer"
	MutatorDescription="Announces items being picked up by other members of your team"

	IncludedBaseClasses=ShieldBelt
	IncludedBaseClasses=UT_ShieldBelt
	IncludedBaseClasses=Armor
	IncludedBaseClasses=Armor2
	IncludedBaseClasses=ThighPads
	IncludedBaseClasses=HealthPack
	IncludedBaseClasses=UDamage
	IncludedBaseClasses=UT_Invisibility
	IncludedBaseClasses=Invisibility
	IncludedBaseClasses=UT_JumpBoots
	IncludedBaseClasses=JumpBoots
}