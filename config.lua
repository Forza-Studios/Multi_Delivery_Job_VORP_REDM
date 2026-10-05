Config = {}

-- ==========================================================================
-- Phase 1: Meet Contractor (blip + NPC only)
-- ==========================================================================

Config.Contractor = {
    model = "re_rallysetup_males_01",
    coords = vector4(-245.3929, 764.3901, 120.0174, 20.9424),
    scenario = "WORLD_HUMAN_SMOKE",
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

-- Hold-L prompt to take contracts when near the contractor.
Config.Prompt = {
    control = 0x80F28E95, -- L key
    text = "Take contracts",
    groupName = "Contractor",
    radius = 2.5,
    holdTime = 10000, -- 10 sec hold
}
