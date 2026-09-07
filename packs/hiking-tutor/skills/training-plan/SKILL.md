---
name: training-plan
description: Builds a hike-specific periodized training block (base, build, peak, taper) with rucking and optional HR zones. Use when the user asks how to train for a trek, rucking, weekly volume, or /training-plan.
---

# Training plan (hiking / rucking)

Always reply in the language the user writes in.

Read profile (fitness, age, limitations, optional `lthr_bpm`, weekly volume) and trip-params (duration, distance, gain, off-trail). This is **not** the running-tutor marathon RLP plan. Do not copy 24-week marathon mesocycles here.

If they report sharp pain, do not prescribe a build. Send them to a clinician.

## Structure

Four phases, length scaled to time available (typical 8–16 weeks; compress if the trip is sooner):

| Phase | Focus |
|-------|--------|
| Base | Easy hiking / walking, unweighted then light pack, joints and feet |
| Build | Longer days, more elevation, pack toward expected trip base + a food day |
| Peak | One weekend near trip difficulty (not the full duration if untrained) |
| Taper | 7–10 days easier before departure |

Session types:

- Easy walk/hike (conversational).
- Hill repeats or stair/ruck climbs if they have no mountains.
- One longer outing per week; increase duration ~10–20% only if they recovered.
- Strength: posterior chain, single-leg, core — 2 short sessions/week if joints allow.
- Terrain practice in controlled conditions: side slopes, wet roots, moderate blowdown, and foot placement.
- Daylight navigation drills with offline maps plus the independent backup.
- A shakedown using actual footwear, loaded pack, rain system, shelter, and water treatment.
- River-crossing practice only in controlled, low-consequence conditions with appropriate instruction.

## Load rules

- Match `fitness_level`. Beginners: no jump from 0 to a 7-day off-trail peak.
- `longest_trip_days` should not be more than ~2× the longest recent outing without extra time in build.
- Pack weight in training: progress toward expected **base + one day’s food/water**, not a surprise 20 kg on week one.
- Track time-on-feet and repeated-day recovery, not distance alone.
- If `lthr_bpm` is present, easy work stays well below threshold (use it as a ceiling, not a running-zone table reprint). If absent, use talk-test.

## Output

Save `result/<trip-slug>/training-plan.md`: weeks, sessions, pack weight targets, and a note on what to skip given `known_limitations`.
