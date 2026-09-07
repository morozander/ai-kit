---
name: packlist-generator
description: Merges gear, nutrition, hydration, footcare, and safety skills into one categorized weighed hiking pack list. Use when the user wants a full packing list, base weight, or /packlist.
---

# Packlist generator

Always reply in the language the user writes in.

Read profile and trip-params, then load:

- `skills/gear-selection/SKILL.md` (+ reference if needed)
- `skills/nutrition-planning/SKILL.md` (food weight from duration)
- `skills/hydration-and-water-treatment/SKILL.md`
- `skills/footcare/SKILL.md`
- `skills/risk-and-safety/SKILL.md`
- `skills/navigation-and-permits/SKILL.md`
- `skills/camp-hygiene-and-sanitation/SKILL.md`

Do not emit a list until those constraints are applied. Mark every line **owned** vs **buy/borrow** from `gear_owned`.

## Categories (fixed order)

1. Worn (not in pack weight)
2. Pack
3. Shelter + sleep
4. Clothing (packed)
5. Cook + water treatment + fuel
6. Food (by day or as a lump with kcal)
7. Navigation + power
8. First aid + repair + footcare
9. Hygiene + sanitation
10. Other (permits, cash, ID)

## Weights

- Use grams. `null` if unknown — do not invent a 12.3 kg total from guessed lines.
- Subtotals: base, food, fuel, currently carried water, worn weight, consumables, and grand departure weight.
- Show maximum water capacity separately from currently carried water.
- If `weight_kg` is known, show pack as % body weight and flag over the schema heuristic.

## Nuances

- `off_trail` / forest: extra socks, tougher layers, poles, nav backup — from gear + footcare + nav skills.
- `resupply_available: false`: full food for `duration_days` + emergency dinner.
- Ultralight: still keep treatment, nav backup, and blister kit.
- Require a pack liner, sealed dry-sleep module, wet-item isolation, and a no-cook emergency meal where conditions justify them.
- Audit sleep adequacy, stove safety, waste/toileting compliance, item condition, and tested status.

Save `result/<trip-slug>/packlist.md` as a table plus totals and open questions.
