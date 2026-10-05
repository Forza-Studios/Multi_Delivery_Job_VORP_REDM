Config = {}

-- ==========================================================================
-- Phase 1: Meet Contractor (blip + drinking NPC only)
-- ==========================================================================

Config.Contractor = {
    model = "re_rallysetup_males_01",
    coords = vector4(-245.3929, 764.3901, 121.0174, 20.9424),
    -- Standing drinking scenario.
    scenario = "WORLD_HUMAN_DRINKING",
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
