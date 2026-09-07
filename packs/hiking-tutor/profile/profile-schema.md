# Hiker profile and trip params

Persistent data every skill and command must read before advising. YAML under `result/<trip-slug>/` is the source of truth. The ASCII card is for humans.

**Never invent values.** Leave `null` / empty lists if unknown. Walk `/setup-profile` and `/plan-trip` in sections — do not dump every field in one message.

Language of the session follows the user, not `preferences.language` (that field is `auto` unless they pin a language).

This is not medical or legal advice. `known_limitations` constrains load, pace, and gear. It is not a diagnosis.

---

## Hiker profile fields

Reusable across trips. Copy into each `result/<trip-slug>/hiker-profile.yaml` so a trip folder is self-contained. After `/trip-review`, merge lessons back into the latest profile.

### personal

| Field | Why it matters |
|-------|----------------|
| `name` | Address the person; optional |
| `age` | Recovery, cold tolerance, caloric baseline |
| `weight_kg` | Pack weight as % of body weight; energy estimate |
| `height_cm` | Pack fit, pole length |
| `sex` | Caloric baseline only (`m` / `f` / `unspecified`) |
| `fitness_level` | `beginner` / `intermediate` / `advanced` |
| `known_limitations` | Free-text list, e.g. "knee sensitivity on descents" |

### experience

| Field | Why it matters |
|-------|----------------|
| `years_hiking` | How aggressive to prescribe days/km |
| `longest_trip_days` | Caps first multi-day jump |
| `off_trail_experience` | bool — bushwhack, navigation, footwear |
| `cold_weather_experience` | bool — winter/shoulder layers and sleep system |
| `offline_navigation_experience` | `none` / `basic` / `competent` |
| `map_compass_experience` | `none` / `basic` / `competent` |
| `river_crossing_experience` | `none` / `basic` / `competent` |

### preferences

| Field | Why it matters |
|-------|----------------|
| `pack_philosophy` | `ultralight` / `traditional` / `comfort-first` |
| `language` | `auto` unless they pin a language code |
| `dietary_constraints` | Allergies, intolerances, ethics; avoid unnecessary medical detail |
| `food_gi_notes` | Foods already known to cause trail GI trouble |

### footcare

Record recurring hot spots, footwear-fit notes, tested sock system, and tested insole notes. These are fit and packing constraints, not diagnoses.

### gear_owned

List of items they already have (free text + optional `weight_g`, `condition`, `tested`, and `notes`). Gear and packlist skills must not re-buy these unless unsafe for the trip.

### training (optional)

| Field | Why it matters |
|-------|----------------|
| `lthr_bpm` | If they track HR; otherwise omit |
| `resting_hr_bpm` | Fatigue context only |
| `weekly_training_volume` | Free text, e.g. "3 runs + 1 ruck" |

---

## Trip params fields

One file per hike: `result/<trip-slug>/trip-params.yaml`.

| Field | Values / notes |
|-------|----------------|
| `slug` | Folder name, kebab-case |
| `name` | Human title |
| `start_date` | `YYYY-MM-DD` or `null` |
| `country_or_region` | Country and hiking region |
| `season` | `summer` / `shoulder` / `winter` |
| `region_terrain` | `alpine` / `forest` / `off-trail` / `desert` / `arctic` |
| `route_style` | `maintained-trail` / `mixed` / `off-trail` |
| `duration_days` | Integer |
| `distance_km` | Number or `null` |
| `elevation_gain_m` | **Total trip ascent**, number or `null` |
| `daily_elevation_gain_m` | Daily ascent only when known |
| `expected_daily_hours` | Planned time moving per day |
| `off_trail` | bool |
| `known_river_crossings` | List; empty if none known |
| `known_terrain_obstacles` | Blowdown, scrub, gullies, side-hills, etc. |
| `night_travel_planned` | bool |
| `group_size` | Integer (1 = solo) |
| `resupply_available` | bool |
| `water_availability` | `frequent` / `sparse` / `unreliable` |
| `longest_dry_water_interval_km` | Longest **verified** interval |
| `water_source_notes` | Livestock, settlements, runoff, stagnant water, turbidity |
| `expected_overnight_low_c` | Route-specific expected low |
| `weather_notes` / `rain_exposure` | Forecast uncertainty and persistent-rain exposure |
| `bug_pressure` | `low` / `moderate` / `high` |
| `campsite_or_shelter_constraints` | Site, refuge, hammock-tree, or no-camp limits |
| `stove_fire_restrictions` | Current official restrictions |
| `waste_disposal_rules` | Local cathole / pack-out requirements |
| `restricted_area_or_border` | `none` / `border-strip` / `protected-area` / `other` |
| `permits_or_access_status` | `not-needed` / `unverified` / `pending` / `verified` |
| `navigation_notes` | Map quality, bailout, and device notes |
| `budget_tier` | `low` / `mid` / `unconstrained` or `null` |
| `region_notes` | Lawful constraints: border zone, dogs, ticks, etc.; never covert-route notes |

---

## Derived checks (after both files exist)

- **Pack weight ceiling (starting heuristic):** ultralight ~10–15% body weight (base, no food/water); traditional ~15–20%; comfort-first may exceed. Food + water sit on top. Recalculate when `weight_kg` is known.
- **Energy (starting heuristic, not a prescription):** roughly 30–45 kcal/kg/day on loaded mountain days, scaled by duration, elevation, and fitness. State assumptions.
- **Risk flags:** solo + `off_trail`; `group_size` 1 + `water_availability` not `frequent`; `season: winter` + `cold_weather_experience: false`; no comms implied when risk skill finds none in `gear_owned`.
- **Navigation flags:** off-trail + no map/compass competence; remote route + one physical navigation device; crossing + no crossing experience; night + unfamiliar terrain; restricted area + unverified access; daily plan without daylight margin.

---

## ASCII card template

Save as `result/<trip-slug>/hiker-profile-card.md` after `/setup-profile` (and refresh after `/plan-trip` so trip lines are filled).

```
╔══════════════════════════════════════════════════╗
║  HIKER PROFILE                                   ║
╠══════════════════════════════════════════════════╣
║  Name:           [name or —]                     ║
║  Age:            [age]           Sex: [sex]      ║
║  Weight / height:[kg] kg / [cm] cm               ║
║  Fitness:        [level]                         ║
╠══════════════════════════════════════════════════╣
║  Hiking years:   [n]                             ║
║  Longest trip:   [n] days                        ║
║  Off-trail:      [yes/no]   Cold: [yes/no]       ║
║  Pack style:     [philosophy]                    ║
╠══════════════════════════════════════════════════╣
║  Limitations:    [list or none noted]            ║
║  Owned gear:     [count] items logged            ║
╚══════════════════════════════════════════════════╝

## Active trip
Slug: [slug]
[name] — [season], [duration_days] d, [distance_km] km, [terrain]
Off-trail: [yes/no]  Group: [n]  Water: [availability]  Resupply: [yes/no]
Notes: [region_notes or —]
```
