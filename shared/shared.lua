J0 = {
    maxContracts = 8,
    moneyPerMile = 10,
    xpPerMile = 20,
    timePerMile = 8.5,
    
    Carts = {
        CART03 = { box_amount = 1, box_model = "p_chair_crate02x", cart_model = -1347283941 },
        CART06 = { box_amount = 1, box_model = "p_chair_crate02x", cart_model = 219205323 },
    },

    locations = {
        {
            name = "Valentine Frontier Delivery", 
            coords = vector4(-232.4925, 635.0405, 113.2936, 261.8642),  
            BoxDepo = vector4(-180.4367, 649.1989, 112.5790, 58.6727),
            spawn = {
                coords = vector3(-187.3921, 650.9539, 112.4330),
                heading = 324.1803
            },
            delivery = {
                coords = vector3(-189.8405, 641.9016, 113.3665),
                heading = 315.7911
            }
        },
       
       
       
       
        
       
        
        
        
    },
    
    getLevelConfig = function(playerLevel)
        local bonus = playerLevel * 2
        return {
            level = playerLevel,
            minDistance = 5.0,
            maxDistance = 15.0,
            baseReward = 20 + bonus,
            baseXP = 40 + bonus,
            timeMultiplier = 1.0
        }
    end,

    calculateDistance = function(coord1, coord2)
        local meters = GetDistanceBetweenCoords(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, true)
        return meters / 1609.34
    end,
    
    generateContract = function(playerLevel, contractIdCounter, fromLocation)
        local toLocation = J0.locations[math.random(1, #J0.locations)]
        while toLocation == fromLocation do toLocation = J0.locations[math.random(1, #J0.locations)] end
        
        local distance = J0.calculateDistance(fromLocation.coords, toLocation.coords)
        local reward = math.floor(distance * J0.moneyPerMile)
        local xp = math.floor(distance * J0.xpPerMile)
        local timeLimit = math.max(15, math.min(60, math.floor(distance * J0.timePerMile)))
        
        local cartNames = {}
        for cartName, cartData in pairs(J0.Carts) do table.insert(cartNames, cartName) end
        local selectedCart = cartNames[math.random(1, #cartNames)]
        
        return {
            id = contractIdCounter,
            name = "Delivery Contract #" .. contractIdCounter,
            from = fromLocation.name,
            to = toLocation.name,
            fromCoords = fromLocation.coords,
            toCoords = toLocation.coords,
            reward = reward,
            xp = xp,
            distance = math.floor(distance * 10) / 10,
            timeLimit = timeLimit,
            requiredLevel = playerLevel,
            selectedCart = selectedCart,
            available = true,
            generatedAt = GetGameTimer()
        }
    end,
    
    generateNewContracts = function(playerLevel, maxContracts, fromLocation)
        local contracts = {}
        local count = math.min(maxContracts or J0.maxContracts, #J0.locations * 2)
        for i = 1, count do table.insert(contracts, J0.generateContract(playerLevel, i, fromLocation)) end
        return contracts
    end,
    
    contractCache = {},
    
    getCachedContracts = function(cacheKey)
        if J0.contractCache[cacheKey] then return J0.contractCache[cacheKey] end
        return nil
    end,
    
    cacheContracts = function(cacheKey, contracts)
        J0.contractCache[cacheKey] = contracts
    end
}