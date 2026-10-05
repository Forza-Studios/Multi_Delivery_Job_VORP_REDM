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

-- Jobs board data (UI only for now). Images use placehold.co holders.
Config.Jobs = {
    {
        id = "hunting",
        name = "Hunting",
        icon = "paw",
        desc = "Track and hunt wildlife for valuable resources.",
        tagline = "Track. Hunt. Survive.",
        details = "Hunt various wildlife across the frontier and sell their hides, meat and rare materials to earn money and experience.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=HUNTING",
        rewards = { "Money", "Job XP", "Animal Hides", "Meat" },
    },
    {
        id = "mining",
        name = "Mining",
        icon = "pick",
        desc = "Extract precious ores from the land.",
        tagline = "Dig. Haul. Profit.",
        details = "Swing your pick in the frontier mines, haul ore back to town and sell it for steady money and experience.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=MINING",
        rewards = { "Money", "Job XP", "Ore", "Stone" },
    },
    {
        id = "farming",
        name = "Farming",
        icon = "wheat",
        desc = "Grow and sell crops to earn steady income.",
        tagline = "Sow. Reap. Earn.",
        details = "Plant, tend and harvest crops across the frontier and sell your produce for a steady income.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=FARMING",
        rewards = { "Money", "Job XP", "Crops", "Seeds" },
    },
    {
        id = "trading",
        name = "Trading",
        icon = "cart",
        desc = "Transport goods across the frontier.",
        tagline = "Haul. Trade. Prosper.",
        details = "Run trade wagons between towns, deliver goods on time and build your trading reputation.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=TRADING",
        rewards = { "Money", "Job XP", "Goods", "Supplies" },
    },
    {
        id = "law",
        name = "Law & Order",
        icon = "star",
        desc = "Keep the towns safe and uphold the law.",
        tagline = "Serve. Protect. Uphold.",
        details = "Patrol the towns, answer calls for help and keep the peace to earn the badge and the pay.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=LAW+%26+ORDER",
        rewards = { "Money", "Job XP", "Badge", "Respect" },
    },
    {
        id = "bounty",
        name = "Bounty Hunting",
        icon = "target",
        desc = "Capture outlaws and bring them to justice.",
        tagline = "Track. Capture. Collect.",
        details = "Pick up bounty posters, track down outlaws dead or alive and collect the reward.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=BOUNTY",
        rewards = { "Money", "Job XP", "Bounties", "Notoriety" },
    },
    {
        id = "moonshining",
        name = "Moonshining",
        icon = "bottle",
        desc = "Brew and sell moonshine.",
        tagline = "Brew. Hide. Sell.",
        details = "Run a hidden still, brew moonshine and sell it under the nose of the law.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=MOONSHINE",
        rewards = { "Money", "Job XP", "Moonshine", "Mash" },
    },
    {
        id = "crafting",
        name = "Crafting",
        icon = "hammer",
        desc = "Create useful items and equipment.",
        tagline = "Forge. Build. Supply.",
        details = "Gather materials and craft weapons, tools and equipment for yourself and others.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=CRAFTING",
        rewards = { "Money", "Job XP", "Materials", "Blueprints" },
    },
    {
        id = "services",
        name = "Services",
        icon = "shake",
        desc = "Offer various services to the community.",
        tagline = "Help. Serve. Earn.",
        details = "Take on odd jobs and services for townsfolk across the frontier.",
        requirement = "None - Available for everyone",
        level = 1,
        image = "https://placehold.co/600x400/2a2118/d9b36a?text=SERVICES",
        rewards = { "Money", "Job XP", "Tips", "Contacts" },
    },
}
