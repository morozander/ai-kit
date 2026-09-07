---
name: hydration-and-water-treatment
description: Chooses hiking water treatment (filter, chemical, boil), carry volume, and electrolytes from trip water availability and season. Use when the user asks about Sawyer, Katadyn, tablets, liters per day, or sparse water.
---

# Hydration and water treatment

Always reply in the language the user writes in.

Read profile and trip-params first. Never tell the user to skip treatment when `water_availability` is `sparse` or `unreliable`, or when `region_notes` mention livestock, villages, or unknown surface water.

## Carry vs treat

- `frequent`: capacity must still cover the longest **verified** dry interval plus reserve; filter is convenient.
- `sparse`: known carry between sources; map liters on the day plan; backup chemical or boil.
- `unreliable`: treat **everything**; backup method; do not plan on “looks clean.”

Daily drinking + cooking (freeze-dried) often lands around **2.5–4.5 L** in temperate mountains; desert and heat go higher. Adjust to daily ascent, hours, heat, and off-trail effort.

Assess each source: upstream people/livestock, settlements, runoff, flood/turbidity, stagnant water, viral risk, and official advisories. Clarity, smell, or mountain location never proves safety.

## Method choice

| Method | Strength | Weakness |
|--------|----------|----------|
| Hollow-fiber filter (Sawyer-class, Katadyn-class) | Fast, no taste, good for protozoa/bacteria | Freeze damage; clog in glacial silt; not a virus guarantee |
| Chemical (chlorine dioxide, etc.) | Light backup, works when filter dies | Pathogen-specific limits; follow label dose/contact time |
| Boil | Broad pathogen control | Fuel; slow; follow current public-health time/altitude guidance |

Default for forest/alpine multi-day: **filter as primary + chemical or boil backup**. Winter: filter may freeze — chemical/boil as primary, keep filter in a pocket.

Do not name a single “best” SKU. Compare **class** (inline squeeze vs pump vs bottle filter) to group size and silt. Ordinary hollow-fiber filters do not reliably remove viruses; freezing may permanently damage them; turbid water may need settling/prefiltering.

## Electrolytes

Scale electrolytes to heat, duration, sweat/salt-loss observations, and food sodium. Do not stack salt tablets on salty food without a reason. Cold: remind them to drink; electrolytes may still matter if intake is low.

## Group

`group_size` > 1: one primary filter can serve several people, but each person retains emergency water capacity and an independent backup treatment dose.

Coordinate cooking water with `skills/nutrition-planning/SKILL.md`.
