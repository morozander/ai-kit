---
name: navigation-and-permits
description: Covers offline maps, GPS limits, batteries, and region logistics including border or permit checklists. Use when the user asks about GPX, maps, permits, border zones, or navigation in poor weather.
---

# Navigation and permits

Always reply in the language the user writes in.

Read profile navigation/crossing experience, `gear_owned`, and every route/access field in `trip-params.yaml`. This is not legal advice. Rules and conditions change: record the official source and verification date rather than guaranteeing access.

Detailed checklists: [reference.md](reference.md).

## Route-screening workflow

Review in this order:

1. Legal access, protected land, border strip, closures, camping/fire/drone rules.
2. Contours and slope; compare topographic data with current satellite imagery.
3. Mapped paths, roads, structures, water, camps, and exit points.
4. Vegetation and terrain penalties: blowdown, dwarf pine/scrub, wet roots, side-hills, gullies.
5. River crossings: entry/exit, current, depth, downstream hazards, recent rain, alternatives.
6. Daily checkpoints, camp candidates, hard turnaround, bailout routes, and overdue threshold.

Use time ranges, not a single pace. Map distance underestimates off-trail effort. Preserve daylight margin and begin campsite selection before dark.

## Offline and independent backup

- Download route, contours, and relevant regions; test in airplane/offline mode.
- Store GPX **plus** critical waypoints, bearings/handrails, crossings, camps, and bailouts.
- Two apps on one phone are not independent redundancy. Remote/off-trail travel needs a separately powered device or paper map + compass and the skill to use it.
- Size power for duration, navigation time, temperature, and emergency reserve.
- GNSS does not need mobile data. Dense canopy, terrain masking, antenna orientation, and device quality can reduce accuracy; clouds alone do not normally disable it.

## River-crossing abort

Do not cross when footing/current is uncertain, the exit is poor, or downstream strainers, waterfalls, or constrictions raise consequences. Account for cold water and recent rain. Never rush. Use an alternate route or turn back. Border rivers are legal boundaries, not access options.

## Permits and borders

For a lawful border-zone or restricted-area hike:

- verify agency, access status, authorised route, ID, permits, and dates;
- keep current official proof available;
- flag solo + night + off-trail travel in a restricted strip as a hard compliance issue;
- use an official crossing point for any international itinerary.

Refuse unofficial crossings, avoiding controls, concealment, surveillance/communications evasion, or use of detention datasets to choose a place, season, time, river, ridge, or land cover. Do not copy coordinates or enforcement patterns from `docs/lib/`.

## Output

For `/navigation-plan`, save `result/<trip-slug>/navigation-plan.md`: access status, assumptions, terrain review, daily checkpoints/camps, crossings, turnaround/bailouts, maps/devices/power, comms/overdue plan, weather dependencies, official sources with verification dates, and unknowns.
