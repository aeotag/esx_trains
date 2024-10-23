Stations = {}

Stations.List = {
    -- Metro Line 1 Stations
    {
        id = "central_station",
        name = "Central Station",
        line = 1,
        coords = {x = -547.3447, y = -1286.2732, z = 25.3018},
        platform = 1,
        ticketMachine = {x = -545.3447, y = -1286.2732, z = 25.3018},
        nextStations = {"union_square", "financial_district"},
        schedule = {
            startTime = 5, -- 5 AM
            endTime = 23, -- 11 PM
            frequency = 10 -- minutes between trains
        },
        announcements = {
            arrival = "central_station_arrival.ogg",
            departure = "central_station_departure.ogg"
        }
    },
    {
        id = "union_square",
        name = "Union Square",
        line = 1,
        coords = {x = 647.8699, y = -1785.8444, z = 23.5318},
        platform = 1,
        ticketMachine = {x = 649.8699, y = -1785.8444, z = 23.5318},
        nextStations = {"central_station", "beach_station"},
        schedule = {
            startTime = 5,
            endTime = 23,
            frequency = 10
        },
        announcements = {
            arrival = "union_square_arrival.ogg",
            departure = "union_square_departure.ogg"
        }
    }
}

-- Station utility functions
Stations.GetNextArrival = function(stationId)
    local station = nil
    for _, s in ipairs(Stations.List) do
        if s.id == stationId then
            station = s
            break
        end
    end
    
    if not station then return nil end
    
    local currentTime = os.time()
    local currentHour = tonumber(os.date("%H", currentTime))
    local currentMinute = tonumber(os.date("%M", currentTime))
    
    if currentHour < station.schedule.startTime or currentHour >= station.schedule.endTime then
        return nil
    end
    
    local nextMinute = math.ceil(currentMinute / station.schedule.frequency) * station.schedule.frequency
    local nextArrival = {
        hour = currentHour,
        minute = nextMinute
    }
    
    if nextMinute >= 60 then
        nextArrival.hour = nextArrival.hour + 1
        nextArrival.minute = nextArrival.minute - 60
    end
    
    return nextArrival
end

-- Get all stations for a specific line
Stations.GetLineStations = function(lineId)
    local lineStations = {}
    for _, station in ipairs(Stations.List) do
        if station.line == lineId then
            table.insert(lineStations, station)
        end
    end
    return lineStations
end

return Stations