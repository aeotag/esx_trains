Config = {}

-- Train configurations
Config.Trains = {
    {
        id = 1,
        name = "Metro Line 1",
        model = 'metrotrain',
        baseSpeed = 20.0,
        route = 'metro_route_1',
        announceAudio = true,
        spawnNPCs = true,
        startPosition = {
            x = -547.3447,
            y = -1286.2732,
            z = 25.3018
        },
        isLoop = true,
        doorOpenTime = 15000 -- Time in ms to keep doors open at stations
    },
    {
        id = 2,
        name = "Freight Line",
        model = 'freight',
        baseSpeed = 15.0,
        route = 'freight_route_1',
        announceAudio = false,
        spawnNPCs = false,
        startPosition = {
            x = 647.8699,
            y = -1785.8444,
            z = 23.5318
        },
        isLoop = true,
        doorOpenTime = 20000
    }
}

-- Speed zones (areas where trains should adjust speed)
Config.SpeedZones = {
    {
        coords = {x = -547.3447, y = -1286.2732, z = 25.3018},
        radius = 100.0,
        speed = 10.0,
        reason = "station_approach"
    },
    {
        coords = {x = 647.8699, y = -1785.8444, z = 23.5318},
        radius = 150.0,
        speed = 5.0,
        reason = "sharp_turn"
    }
}

-- Ticket system configuration
Config.TicketSystem = {
    enabled = true,
    prices = {
        single = 5,
        day = 15,
        week = 50
    },
    checkInterval = 300000, -- 5 minutes between ticket checks
    fineAmount = 150,
    policeNotification = true
}

-- NPC Configuration
Config.NPCs = {
    enabled = true,
    models = {
        's_m_m_lsmetro_01',
        'a_f_y_business_01',
        'a_m_y_business_01'
    },
    maxPerTrain = 5
}

-- Audio configuration
Config.Audio = {
    enabled = true,
    volume = 0.5,
    announcements = {
        station_arrival = 'audio/station_arrival.ogg',
        next_station = 'audio/next_station.ogg',
        ticket_check = 'audio/ticket_check.ogg',
        doors_opening = 'audio/doors_opening.ogg',
        doors_closing = 'audio/doors_closing.ogg'
    },
    announcementDistance = 50.0
}

-- Police alert configuration
Config.PoliceAlert = {
    enabled = true,
    shootingCooldown = 60000, -- 1 minute cooldown between shooting alerts
    ticketCheckCooldown = 300000 -- 5 minutes cooldown between ticket violation alerts
}

-- Display configuration
Config.Display = {
    enabled = true,
    updateInterval = 1000,
    maxDisplayDistance = 20.0
}

Config.Debug = false