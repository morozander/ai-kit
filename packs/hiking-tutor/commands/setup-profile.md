Read `profile/profile-schema.md` and `profile/hiker-profile.example.yaml`. Follow them to onboard a hiker.

Reply in the language the user writes in. Walk required fields **one section at a time**: personal → hiking/navigation experience → preferences and dietary constraints → footcare/fit notes → gear_owned (including condition/tested) → optional training. Do not dump every question at once or collect unnecessary medical detail.

Do not invent values. If they skip a field, keep `null`.

After data is collected:

1. Write `result/<trip-slug>/hiker-profile.yaml`. If no trip exists yet, use slug `profile` so the folder is `result/profile/`.
2. Write the ASCII card from the schema to `result/<trip-slug>/hiker-profile-card.md`.
3. Suggest `/plan-trip` next if `trip-params.yaml` is missing.

If `result/<trip-slug>/hiker-profile.yaml` already exists, load it and only ask for blanks or confirmed updates.
