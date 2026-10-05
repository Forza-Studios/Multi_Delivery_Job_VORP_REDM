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

-- Jobs board data: only real jobs go here. Images use placehold.co holders.
Config.Jobs = {
    {
        id = "newspaper",
        name = "Newspaper Delivery",
        icon = "paper",
        desc = "Deliver fresh newspapers to doorsteps across town.",
        tagline = "Print. Ride. Deliver.",
        details = "Pick up the morning bundle from the press office and deliver newspapers to houses around town before the ink dries. Fast, complete routes earn better pay.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=NEWSPAPER",
        rewards = { "Money", "Job XP", "Tips", "Contacts" },
        -- Paper bundle pickup: props spawn here while this job is active.
        pickup = vector4(-185.5484, 641.8805, 113.5820, 40.8867),
        props = {
            { model = "p_group_newspaper01", offset = { x = 0.0, y = 0.0, z = 0.0 } },
            { model = "p_group_newspaper02", offset = { x = 0.7, y = 0.3, z = 0.0 } },
            { model = "p_group_newspaper03", offset = { x = -0.7, y = 0.3, z = 0.0 } },
        },
    },
}
