Config = {}

-- ==========================================================================
-- Phase 1: Meet Contractor (blip + seated NPC only)
-- ==========================================================================

Config.Contractor = {
    model = "re_rallysetup_males_01",
    coords = vector4(-243.0108, 770.7150, 118.0853, 43.0443),
    -- Chair sit scenario. Snaps to the nearby chair prop.
    scenario = "PROP_HUMAN_SEAT_CHAIR",
}

Config.Blip = {
    name = "Meet Contractor",
    sprite = 587827268,
    scale = 0.6,
    -- Pink blip colour
    modifier = "BLIP_MODIFIER_MP_COLOR_7",
    -- Base blip style (standard point blip, same pattern as other COI scripts)
    style = 1664425300,
}
