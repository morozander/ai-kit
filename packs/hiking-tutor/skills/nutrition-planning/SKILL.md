---
name: nutrition-planning
description: Plans hiking calories, macros, freeze-dried vs trail food, electrolytes, and supplement timing from hiker profile and trip params. Use when the user asks about food, meals, calories, freeze-dried rations, snacks, or /nutrition-plan.
---

# Nutrition planning

Always reply in the language the user writes in.

Read `result/<trip-slug>/hiker-profile.yaml` and `trip-params.yaml` first. If they are missing, tell the user to run `/setup-profile` and `/plan-trip`. Never invent age, weight, or duration.

This is not medical advice and not a prescription. `known_limitations` only constrains the plan (e.g. easier food, lower fiber). Flag iron, nitrates, and collagen as optional context.

Detailed density tables: [reference.md](reference.md).

## Energy estimate

State assumptions. Do not pretend precision.

1. If `weight_kg` is known, start at **~35 kcal/kg/day** for loaded mountain walking.
2. Adjust:
   - `fitness_level: beginner`: use a broad range and validate against prior appetite and work rate.
   - High `daily_elevation_gain_m`, `off_trail: true`, or `region_terrain: alpine` / `arctic`: toward 40–45. Do not treat total `elevation_gain_m` as daily ascent.
   - Short days, `forest` on trail, low gain: toward 30–34.
3. If `weight_kg` is unknown, give a **range** (e.g. 2800–4200 kcal/day) and ask for weight before a gram-accurate food list.
4. Multiply by `duration_days`. Add **one emergency dinner** (freeze-dried or equivalent) if `resupply_available: false` and duration ≥ 3.

## Density and packing

| Trip | Target |
|------|--------|
| 1–2 days, frequent shops | Fresh + some dense snacks OK |
| 3–5 days, no resupply | Aim near **400–500 kcal/100 g** overall when weight matters |
| 6+ days or sparse water (fuel limited) | Prefer freeze-dried dinners; olive oil / nut butter for calories |

- **Freeze-dried:** light, fast, needs reliable water + stove. Best when `water_availability` is `frequent` or they carry treat-and-cook water.
- **Traditional (kasha, pasta, hard cheese, smoked meat, tortillas):** cheaper, heavier, more fiber/salt control. Fine for 2–4 days if pack philosophy is not ultralight.
- Mix: freeze-dried dinners + homemade breakfasts/snacks is the usual Carpathian / forest multi-day pattern.
- Include one tested no-cook meal for stove/fuel failure.

## Macros (starting split)

- Carbohydrate: majority of trail calories (breakfast, snacks, dinner starch).
- Fat: density (nuts, oil, cheese, chocolate). Increase on cold `season: winter` / `shoulder`.
- Protein: ~1.2–1.6 g/kg/day if `weight_kg` known, from mixes, meat, dairy, or freeze-dried meals — not a bodybuilding plan.

On multi-day trips, **blunt fiber** the last 24 h before start and keep trail fiber moderate (less raw salad, bran, huge dried-fruit bombs) to cut GI distress. Do not eliminate all fiber.

Plan regular fueling during long movement rather than one or two fixed snack stops. Use prior tolerance and effort; if giving carbohydrate-per-hour guidance, present a range and label it an experiment to test before the trip. Use package sodium values rather than prescribing salt by teaspoon.

## Electrolytes and water

Cross-read `.agents/skills/hydration-and-water-treatment/SKILL.md` when water is `sparse` or `unreliable`.

- Hot alpine / sweat: electrolytes in at least one bottle or a dedicated mix; do not chase salt tabs as a default.
- Cold: people under-drink; still plan 2–4 L treated water/day depending on sources.

## Optional supplement context (not prescriptions)

Only mention if the user asks or already uses them:

- **Electrolyte mixes:** during long hot days, not a substitute for food.
- **Vitamin C / collagen:** sometimes used for connective tissue; timing with meals is personal; do not claim injury prevention.
- **Iron:** if they mention low iron, say trail food is a poor place to experiment — timing away from tea/coffee is a common nutrition note, not treatment.
- **Nitrates / beetroot:** possible aerobic aid in training, weak case for remote multi-day logistics (weight, GI). Skip unless they already use it.

## Day-by-day output

For `/nutrition-plan`, produce:

1. Daily kcal target and grams of food (approx).
2. Breakfast / snacks / dinner per day, with kcal and packed weight when possible.
3. Water needed to rehydrate freeze-dried meals.
4. Resupply day if `resupply_available: true`.
5. What they already own that counts as food kit (stove, pot) from `gear_owned`.
6. Planned boils/simmers, fuel estimate, no-cook fallback, and hot-weather perishability.

Save to `result/<trip-slug>/nutrition-plan.md`.
