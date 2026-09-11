Read `.agents/agents/hiking-tutor.md` routing is optional. Required reads:

1. `result/<trip-slug>/hiker-profile.yaml` and `trip-params.yaml`
2. `.agents/skills/packlist-generator/SKILL.md`
3. Skills it names (gear, nutrition, hydration, footcare, risk, navigation)
4. `.agents/skills/camp-hygiene-and-sanitation/SKILL.md`

If profile or trip-params are missing, run `/setup-profile` / `/plan-trip` first. Reply in the user's language.

Generate the categorized weighed list. Mark owned vs buy. Use grams; do not invent a fake total.

Report base, food, fuel, current water, maximum water capacity, worn weight, consumables, and grand departure weight. Check dry-sleep storage, wet-kit isolation, stove safety, toileting/waste, emergency no-cook food, item condition/tested status, and lawful ID/permits. Never add concealment or border-evasion items.

Save `result/<trip-slug>/packlist.md`.
