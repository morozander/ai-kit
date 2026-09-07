Read `profile/profile-schema.md` and `profile/trip-params.example.yaml`.

Reply in the user's language. Collect trip fields in sections:

1. Identity and timing: name, slug, start date, country/region, season.
2. Route: terrain, route style, duration, distance, **total** ascent, expected daily hours, off-trail, known crossings/obstacles, night travel.
3. Conditions: expected overnight low, weather/rain, bugs, campsite constraints.
4. Water and camp: availability, longest verified dry interval, source risks, stove/fire restrictions, waste rules.
5. Access and logistics: group, resupply, restricted area/border, permit status, navigation notes, budget, region notes.

Do not invent numbers. Slug: kebab-case from the trip name.

If the itinerary implies an unofficial state-border crossing, avoiding authorities, or routing from detention/patrol data, refuse it. Offer only a lawful route using authorised trails/access and official crossing points. When a border or restricted area is involved, require current official access status; do not infer “quiet” sectors.

Then:

1. Create `result/<trip-slug>/`.
2. Write `trip-params.yaml`.
3. If a hiker profile exists (this folder or `result/profile/`), copy it into this trip folder so the trip is self-contained, then refresh `hiker-profile-card.md` with the Active trip block.
4. If no profile exists, tell them to run `/setup-profile`.

Print the Active trip summary from the ASCII template. Suggest `/risk-assessment` or `/packlist` next.
