# BDCC Better Chastity

BDCC Better Chastity is a small source mod for **Broken Dreams Correctional Center**. It adds three non-graphic, mechanics-focused chastity restraint items with better status text, fit/service actions, save data, and more varied struggle behavior.

## What It Adds

- **Ergonomic Chastity Cage**: lower-pressure long-term cage with serviceable fit.
- **Tamper-Evident Chastity Cage**: stricter cage with seal checks and stronger restraint level.
- **Timed Smart Chastity Cage**: configurable smart cage with rotating protocol modes.
- **BetterChastity restraint data**: struggle outcomes include pressure, fit, seal, hygiene, and comfort flavor rather than a single generic result.

All content is written to be non-graphic. It uses BDCC's existing item slots, tags, rigged models, and inventory art where possible.

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
BBC_ErgonomicChastityCage
BBC_TamperEvidentChastityCage
BBC_TimedSmartChastityCage
```

## Source Layout

```text
Modules/
  BDCCBetterChastity/
    Module.gd
    Items/
      ErgonomicChastityCage.gd
      TamperEvidentChastityCage.gd
      TimedSmartChastityCage.gd
    Restraints/
      BetterChastityRestraint.gd
```

## Notes

The mod is built against BDCC's Godot 3.x-style mod system. It registers new item scripts through `Modules/BDCCBetterChastity/Module.gd`.
