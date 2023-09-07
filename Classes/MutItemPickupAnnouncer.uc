class MutItemPickupAnnouncer extends Mutator
	config;

var localized string MutatorName;
var localized string MutatorDescription;

var config array<name> IncludedBaseClasses;
var config array<name> IncludedExactClasses;
var config array<name> ExcludedExactClasses;

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
	local int Sw;
	local PlayerReplicationInfo PRI1;
	local PlayerReplicationInfo PRI2;
	local Object OptObj;

	Message = class'IPA_PickupMessage';
	Sw = 0;
	PRI1 = PRI;
	PRI2 = none;
	OptObj = ItemClass;

	for (P = Level.PawnList; P != none; P = P.NextPawn)
		if ((P.bIsPlayer || P.IsA('MessagingSpectator')) &&
			(P != PRI.Owner) &&
			(P.IsA('Spectator') || (Level.Game.bTeamGame && P.PlayerReplicationInfo.Team == PRI.Team)) &&
			(
				Level.Game.MessageMutator == none ||
				Level.Game.MessageMutator.MutatorBroadcastLocalizedMessage(self, P, Message, Sw, PRI1, PRI2, OptObj)
			)
		) {
			P.ReceiveLocalizedMessage(Message, Sw, PRI1, PRI2, OptObj);
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
		IncludedBaseClasses.Insert(0, 7);
		IncludedBaseClasses[0]='ShieldBelt';
		IncludedBaseClasses[1]='UT_ShieldBelt';
		IncludedBaseClasses[2]='Armor';
		IncludedBaseClasses[3]='Armor2';
		IncludedBaseClasses[4]='ThighPads';
		IncludedBaseClasses[5]='HealthPack';
		IncludedBaseClasses[6]='UDamage';
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
}
