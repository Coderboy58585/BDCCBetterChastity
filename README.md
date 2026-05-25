# BDCC Better Chastity

BDCC Better Chastity is a source mod for **Broken Dreams Correctional Center**. It adds mechanics-focused chastity restraint items, flat cage variants, timer behavior, use actions, toy-training items, fictional feminizing effects, custom status effects, and a Better Chastity sex-engine activity.

## What It Adds

- **Better Standard Chastity Cage**: prison-issued shape with clearer restraint feedback.
- **Ergonomic Chastity Cage**: lower-pressure long-term cage with serviceable fit.
- **Tamper-Evident Chastity Cage**: stricter cage with seal checks and stronger restraint level.
- **Timed Smart Chastity Cage**: configurable smart cage with rotating protocol modes and a timer that syncs to the game clock, then switches to the normal take-off scene at zero hours.
- **Flat Ergonomic Chastity Cage**: low-profile plate design with serviceable pressure settings.
- **Flat Tamper-Evident Chastity Cage**: recessed seal and plate number variant.
- **Flat Timed Smart Chastity Cage**: flat smart-lock variant with timer and silent status behavior.
- **Better Permanent Chastity Cage**: unremovable standard cage with use tracking.
- **Flat Permanent Chastity Cage**: unremovable flat plate cage with plate condition tracking.
- **BetterChastity restraint data**: struggle outcomes include pressure, fit, seal, hygiene, and comfort flavor rather than a single generic result.
- **Cage use behavior**: item use applies lust/stamina/pain changes, rotates between controlled cage-pressure techniques, and applies Better Chastity status effects.
- **Toy-training items**: Soft Training Dildo, Weighted Training Dildo, Prostate Pulse Stimulator, and Sterile Sounding Kit add reusable toy routines with saved training score.
- **Fictional feminizing item**: Estralux Patch applies a temporary feminizing-shift status and can nudge compatible body-transformation systems.
- **Status effects**: Sissy Euphoria, Prostate Focus, and Feminizing Shift add visible gameplay effects and buffs.
- **Sex-engine activity**: Better Chastity toy training adds prostate focus, cage pressure, and headspace training options to compatible sex scenes.

All content is written to be suggestive rather than graphic. Risky real-world activities are abstracted into game mechanics and do not provide procedure instructions. It uses BDCC's existing item slots, tags, rigged models, and inventory art where possible.

## Install From Source

BDCC loads `.pck` and `.zip` resource packs from its mods folder. This repo is arranged so `BDCCBetterChastity.json` and the `Modules/` folder sit at the resource-pack root.

On Windows:

```powershell
.\build_mod.ps1
```

That creates:

```text
dist\BDCCBetterChastity.zip
```

Copy that ZIP into BDCC's mods folder:

```text
%APPDATA%\Godot\app_userdata\BDCC\mods
```

Then start BDCC and enable/reorder the mod if the game asks.

If the launcher says `No 'BDCCBetterChastity.json' file provided inside the mod`, rebuild the zip and replace the old copy in the mods folder. If the launcher looks clean but the items still do not appear, press `Reset GR cache`, restart BDCC, and launch with `Play (modded)`.

In the debug item menu, search by item ID:

```text
BBC_StandardChastityCage
BBC_ErgonomicChastityCage
BBC_TamperEvidentChastityCage
BBC_TimedSmartChastityCage
BBC_FlatErgonomicChastityCage
BBC_FlatTamperEvidentChastityCage
BBC_FlatTimedSmartChastityCage
BBC_PermanentChastityCage
BBC_FlatPermanentChastityCage
BBC_SoftTrainingDildo
BBC_WeightedTrainingDildo
BBC_ProstatePulseStimulator
BBC_SterileSoundingKit
BBC_EstraluxPatch
```

## Source Layout

```text
Modules/
  BDCCBetterChastity/
    Module.gd
    ChastityUseLogic.gd
    ToyUseLogic.gd
    Items/
      StandardChastityCage.gd
      ErgonomicChastityCage.gd
      TamperEvidentChastityCage.gd
      TimedSmartChastityCage.gd
      FlatErgonomicChastityCage.gd
      FlatTamperEvidentChastityCage.gd
      FlatTimedSmartChastityCage.gd
      PermanentChastityCage.gd
      FlatPermanentChastityCage.gd
      SoftTrainingDildo.gd
      WeightedTrainingDildo.gd
      ProstatePulseStimulator.gd
      SterileSoundingKit.gd
      EstraluxPatch.gd
    Restraints/
      BetterChastityRestraint.gd
    StatusEffects/
      SissyEuphoria.gd
      ProstateFocus.gd
      FeminizingShift.gd
    SexActivities/
      BetterChastityToyTraining.gd
```

## Notes

The mod is built against BDCC's Godot 3.x-style mod system. It registers new item scripts through `Modules/BDCCBetterChastity/Module.gd`.
