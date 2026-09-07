---
name: risk-and-safety
description: Sizes first-aid kits, comms, weather contingencies, and wildlife or dog encounter planning from trip length and group size. Use when the user asks about safety, PLB, first aid, storms, dogs, or /risk-assessment.
---

# Risk and safety

Always reply in the language the user writes in.

Read profile and trip-params. **Flag before packing** if: `group_size` is 1 and `off_trail` is true; water is `sparse`/`unreliable` and they have no treatment in `gear_owned`; `season: winter` and `cold_weather_experience` is false; no satellite/PLB/cell story on a remote trip; restricted access is unverified; a border river is proposed as a crossing; remote travel lacks independent navigation backup.

You are not emergency services. Plans reduce risk; they do not make a route “safe.”

## First aid (sizing)

Scale to `duration_days` and `group_size`. Core: blister care (footcare skill), familiar clinician/pharmacist-compatible OTC items, wound cleaning, tape, and personal prescribed medication.

Never prescribe antibiotics, injectable drugs, steroids, tick prophylaxis, or invasive procedures. Tourniquets and similar interventions require training.

Add for remote multi-day: more dressings, extra blister kit, tweezers, and a written emergency plan (where they go if they bail). Do not build a field hospital.

## Comms

- Cell: assume off in forest/alpine folds.
- Satellite messenger / PLB: strongly recommend for solo + off-trail or no resupply. If they refuse, record that as an accepted risk in the assessment.
- Share GPX and turnaround time with someone off-trail.

## Navigation, crossings, and overdue response

- Plan device failure and route-loss response: stop, establish position, use backup, backtrack only when safe, then bailout/communicate.
- Set hard turnaround, camp deadline, and overdue contact threshold.
- Apply the navigation skill's river/gully abort criteria; do not rush or use a border river as access.

## Weather

Have a **bad-weather alternative**: lower route, extra food, extra layer, earlier camp. `season: shoulder` and `winter` need hard abort triggers: wind/whiteout, post-rain high water, soaked sleeping insulation, or inability to keep critical layers dry. Poor weather is never a reason to continue unseen.

## Stove, sanitation, and water failure

- Never operate a stove in a tent, bivy, or enclosed vestibule; assess CO, fire, stability, and fuel leaks.
- Read `skills/camp-hygiene-and-sanitation/SKILL.md` for waste and contamination controls.
- Abort or change route if treatment capacity is lost and safe water/resupply is not assured.

## Animals and dogs

Forest/village edges: shepherd dogs — do not run; poles down, slow, give space. Wildlife: food storage, no cooking in the tent. This is regional; use `region_notes`.

## Borders and restricted areas

Provide only lawful route, permit/ID, official-checkpoint, and emergency guidance. Refuse unofficial crossing, evasion, concealment, or detention-data routing. Comms and rescue equipment do not legalise closed access.

## Output

Save `result/<trip-slug>/risk-assessment.md`: flags, first-aid list, comms plan, abort criteria, what is still unknown.
