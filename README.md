# Item Pickup Announcer for Unreal Tournament

Item Pickup Announcer is a mutator for Unreal Tournament that enhances the gameplay experience by announcing when players pick up key items.

This is especially useful in team games, where knowing about team item pickups can positively impact team strategy and coordination.

## Key Features

- **Item Pickup Announcements:** Broadcasts a message to team members when a player picks up an important item.
- **Configurable Item List:** Allows server administrators to configure which items should trigger announcements.
- **Spectator Enhancements:** Provides an option to adjust the message lifetime and position for spectators, making it easier for them to follow the action.
- **Easy Configuration:** All settings can be easily configured through a `.ini` file.

## Configuration

The mutator is configurable through the `UnrealTournament.ini` file. Below are the configurable options:

- **IncludedBaseClasses:** A list of base item classes that should trigger pickup announcements. This allows for broad categories of items to be included without specifying each item individually.
- **SpectatorMessageLifetime:** Adjusts the duration that pickup messages are displayed for spectators. This allows spectators to have messages displayed for longer periods, making it easier to follow the game's progress.
- **SpectatorCustomYPos:** Allows adjusting the vertical position of the message display for spectators.

### Example Configuration
```
[ItemPickupAnnouncerv02.MutItemPickupAnnouncer]
IncludedBaseClasses=ShieldBelt
IncludedBaseClasses=UT_ShieldBelt
IncludedBaseClasses=Armor
IncludedBaseClasses=Armor2
IncludedBaseClasses=ThighPads
IncludedBaseClasses=HealthPack
IncludedBaseClasses=UDamage
IncludedBaseClasses=UT_invisibility
IncludedBaseClasses=Invisibility
IncludedBaseClasses=UT_Jumpboots
IncludedBaseClasses=JumpBoots
```

Original work by Deaod at https://github.com/Deaod/ItemPickupAnnouncer

