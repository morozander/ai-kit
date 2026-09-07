---
name: gear-selection
description: Advises hiking equipment from season, terrain, duration, pack philosophy, and owned gear. Use when the user asks about packs, shelters, layers, footwear, poles, stoves, weight budgets, or /gear-check.
---

# Gear selection

Always reply in the language the user writes in.

Read hiker profile and trip-params first. Respect `gear_owned` and `pack_philosophy`. Suggest **gaps and swaps**, not a second full kit.

Weight-budget and season matrices: [reference.md](reference.md).

## Decision order

1. **Sleep + shelter** for `season` (the trip fails if this is wrong).
2. **Footwear + poles** for `region_terrain` and `off_trail`.
3. **Layers** for rain, wind, and overnight low (ask if unknown; do not invent forecast).
4. **Pack volume** from duration + food (nutrition skill) + water carry.
5. **Cook + filter** — coordinate with hydration and nutrition skills.

Before rating sleep or rain gear, require `expected_overnight_low_c`, forecast uncertainty, rain exposure, and campsite constraints. Evaluate shelter + bag/quilt **comfort rating** + pad R-value + dry sleep clothing as one system. Hammocks require tested bottom insulation and suitable attachment points.

## Terrain nuances

- **Maintained alpine trail:** lighter footwear possible if ankles and pack weight allow; poles still useful on long descents.
- **Forest, wet Carpathian / off-trail:** mud, roots, blowdown, dense scrub, hidden holes. Prefer **supportive footwear** (mid boots or aggressive trail shoes with good edge), **gaiters**, durable gloves and eye protection when vegetation warrants them, and poles that can punch through veg. Expect wet feet; pack spare socks and a dry camp pair (see footcare).
- **Desert:** sun, sand, huge water carry — pack and hip belt matter more than insulation.
- **Arctic / winter:** sleep system and stove reliability dominate; electronics and filters freeze.

## Pack philosophy

| Style | Typical move |
|-------|----------------|
| `ultralight` | Cut shelter/sleep/pack first; do not cut first-aid, navigation, or treatment |
| `traditional` | One solid shelter, stove, and boot setup; weight secondary |
| `comfort-first` | Extra sleep pad R-value, camp shoes, warmer bag — say the weight cost |

If `weight_kg` is known, state base pack (no food/water) vs **% of body weight**. Flag if base already exceeds the heuristic in `profile/profile-schema.md`.

Size the pack from tested equipment bulk, food, fuel, and maximum water capacity. Audit fit at expected departure load, item condition, and whether safety-critical gear has been tested.

## Footwear and poles

- Off-trail + heavy pack: err toward more protection, not max cushion road shoes.
- Poles: strongly recommended for `elevation_gain_m` high, descents, river crossings, veg. Collapsible for travel.
- Do not recommend a new boot model as “the one” — recommend **category** (trail shoe vs mid boot) and fit rules; send details to `skills/footcare/SKILL.md`.

## What not to do

- Do not ignore `season: winter` with a summer quilt.
- Do not drop the rain layer because the forecast “might be fine” unless the user accepts that risk in writing.
- Do not duplicate items in `gear_owned` that are adequate for this trip.
- Never recommend a lit stove inside a tent, bivy, or enclosed vestibule. Use a stable outdoor location with manufacturer clearances and ventilation.
- Do not treat camouflage or low visibility as a hiking benefit; rescue-visible equipment can be safer.

For `/gear-check`, list: keep / replace / add, with why (season, terrain, duration). Save `result/<trip-slug>/gear-check.md`.
