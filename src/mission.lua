-- Duration in minutes between players being killed.
Interval = tonumber(Map.LobbyOption("interval"))
-- Duration in minutes for last two players.
FinalInterval = tonumber(Map.LobbyOption("finalinterval"))
-- List of all players.
Players = {}

IsAlive = function(player)
    local actors = player.GetActors()
    return #actors > 1
end

GetRemainingPlayers = function()
    return Player.GetPlayers(function(player)
        return not player.IsNonCombatant and IsAlive(player)
    end)
end

NameDisplay = function(name)
    local displayName = ""
    for i = 1, #name do
        local byte = string.byte(name, i)
        if byte >= 32 and byte <= 126 then
            displayName = displayName..string.char(byte)
        else
            displayName = displayName.."?"
        end
    end
    return displayName
end

PickWinner = function()
    Players = GetRemainingPlayers()
    Media.Debug("There are "..#Players.." players remaining")
    -- There should be exactly 2 players.
    if #Players >= 2 then
        local worstPlayer = nil
        local worstScore = Players[1].Experience + 1
        local tiedScores = false
        for i = 1, #Players do
            Media.Debug("Testing score for "..NameDisplay(Players[i].Name))
            if IsAlive(Players[i]) then
                Media.Debug("  They are alive")
                if Players[i].Experience < worstScore then
                    worstScore = Players[i].Experience
                    Media.Debug("  They have the worst score so far: "..worstScore)
                    worstPlayer = Players[i]
                    tiedScores = false
                elseif Players[i].Experience == worstScore then
                    Media.Debug("  Their score ties for worst so far")
                    tiedScores = true
                end
            end
        end
        if not tiedScores then
            Media.DisplayMessage(NameDisplay(worstPlayer.Name).." was eliminated with the worst score of "..worstScore)
            worstPlayer.MarkFailedObjective(0)
            Players = GetRemainingPlayers()
        else
            Media.DisplayMessage("Tied worst scores of "..worstScore.." so no one eliminated")
        end
        if #Players >= 2 then
            Media.DisplayMessage(FinalInterval.." minutes until a winner will be picked")
            Trigger.AfterDelay(DateTime.Minutes(FinalInterval), PickWinner)
        end
    end
end

KillWorstPlayer = function()
    Players = GetRemainingPlayers()
    Media.Debug("There are "..#Players.." players remaining")
    if #Players > 2 then
        local worstPlayer = nil
        local worstScore = Players[1].Experience + 1
        local tiedScores = false
        for i = 1, #Players do
            Media.Debug("Testing score for "..NameDisplay(Players[i].Name))
            if IsAlive(Players[i]) then
                Media.Debug("  They are alive")
                if Players[i].Experience < worstScore then
                    worstScore = Players[i].Experience
                    Media.Debug("  They have the worst score so far: "..worstScore)
                    worstPlayer = Players[i]
                    tiedScores = false
                elseif Players[i].Experience == worstScore then
                    Media.Debug("  Their score ties for worst so far")
                    tiedScores = true
                end
            end
        end
        if not tiedScores then
            Media.DisplayMessage(NameDisplay(worstPlayer.Name).." was eliminated with the worst score of "..worstScore)
            worstPlayer.MarkFailedObjective(0)
            Players = GetRemainingPlayers()
        else
            Media.DisplayMessage("Tied worst scores of "..worstScore.." so no one eliminated")
        end
        if #Players > 2 then
            Media.DisplayMessage(Interval.." minutes until a player will be eliminated")
            Trigger.AfterDelay(DateTime.Minutes(Interval), KillWorstPlayer)
        end
    end
end

WorldLoaded = function()
    Players = GetRemainingPlayers()

    -- Set up finale callback.
    for i = 1, #Players do
        local player = Players[i]
        Trigger.OnPlayerLost(player, function(player)
            Players = GetRemainingPlayers()
            -- This seems to happen just before the player has actually lost, so there are still 3 players left.
            if #Players == 3 then
                Media.DisplayMessage(FinalInterval.." minutes until a winner will be picked")
                Trigger.AfterDelay(DateTime.Minutes(FinalInterval), PickWinner)
            end
        end)
    end

    Media.DisplayMessage("There are "..#Players.." players remaining")
    if #Players > 2 then
        Media.DisplayMessage(Interval.." minutes until a player will be eliminated")
        Trigger.AfterDelay(DateTime.Minutes(Interval), KillWorstPlayer)
    elseif #Players == 2 then
        Media.DisplayMessage(FinalInterval.." minutes until a winner will be picked")
        Trigger.AfterDelay(DateTime.Minutes(FinalInterval), PickWinner)
    end
end
