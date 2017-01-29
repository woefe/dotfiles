-- This module is havily inspired by https://github.com/jorenheit/awesome_alttab
-- but it has many fancy features removed and introduces instant switching of
-- windows

local mouse = mouse
local table = table
local keygrabber = keygrabber
local awful = require('awful')
local client = client
local pairs = pairs
local screen = screen

module("simpletab")


local function cycle(altTabTable, altTabIndex, dir)
    -- Switch to next client
    --altTabIndex = ((altTabIndex + dir) % #altTabTable) + 1
    altTabIndex = altTabIndex + dir
    if altTabIndex > #altTabTable then
        altTabIndex = 1 -- wrap around
    elseif altTabIndex < 1 then
        altTabIndex = #altTabTable -- wrap around
    end

    altTabTable[altTabIndex].minimized = false

    client.focus = altTabTable[altTabIndex]
    client.focus:raise()

    return altTabIndex
end

local function restore(altTabTable, altTabMinimized, altTabIndex)
    -- Raise clients in order to restore history
    local c
    for i = 1, altTabIndex - 1 do
        c = altTabTable[altTabIndex - i]
        if not altTabMinimized[i] then
            c:raise()
            client.focus = c
        end
    end

    -- restore minimized clients
    for i = 1, #altTabTable do
        if i ~= altTabIndex and altTabMinimized[i] then
            altTabTable[i].minimized = true
        end
    end
end

local function getClients()
    -- Get focus history for current tag
    local s = awful.screen.focused()
    local idx = 0
    local c = awful.client.focus.history.get(s, idx)
    local clients = {}

    while c do
        table.insert(clients, c)
        idx = idx + 1
        c = awful.client.focus.history.get(s, idx)
    end

    -- Minimized clients will not appear in the focus history
    -- Find them by cycling through all clients, and adding them to the list
    -- if not already there.
    -- This will preserve the history AND enable you to focus on minimized clients

    local t = s.selected_tag
    local all = client.get(s)

    for i = 1, #all do
        local c = all[i]
        local ctags = c:tags();

        -- check if the client is on the current tagcolor
        local isCurrentTag = false
        for j = 1, #ctags do
            if t == ctags[j] then
                isCurrentTag = true
                break
            end
        end

        if isCurrentTag then
            -- check if client is already in the history
            -- if not, add it
            local addToTable = true
            for k = 1, #clients do
                if clients[k] == c then
                    addToTable = false
                    break
                end
            end


            if addToTable then
                table.insert(clients, c)
            end
        end
    end

    return clients
end

local function getClientsMinimizedState(clients)
    minimized = {}
    for _,c in pairs(clients) do
        table.insert(minimized, c.minimized)
    end

    return minimized
end

local function switch(dir, alt, tab, shift_tab)

    local altTabTable = getClients()
    local altTabMinimized = getClientsMinimizedState(altTabTable)
    local altTabIndex = 1

    if #altTabTable == 0 then
        return
    elseif #altTabTable == 1 then
        altTabTable[1].minimized = false
        altTabTable[1]:raise()
        return
    end

    -- Now that we have collected all windows, we should run a keygrabber
    -- as long as the user is alt-tabbing:
    keygrabber.run(
    function (mod, key, event)
        -- Move to next client on each Tab-press
        if key == tab and event == "press" then
            altTabIndex = cycle(altTabTable, altTabIndex, 1)

        -- Move to previous client on Shift-Tab
        elseif key == shift_tab and event == "press" then
            altTabIndex = cycle(altTabTable, altTabIndex, -1)

        -- Stop alt-tabbing when the alt-key is released or any other key is pressed
        elseif (key == alt and event == "release") or event == "press" then

            restore(altTabTable, altTabMinimized, altTabIndex)

            -- raise chosen client on top of all
            c = altTabTable[altTabIndex]
            c:raise()
            client.focus = c

            keygrabber.stop()
        end
    end)
   -- switch to next client
   altTabIndex = cycle(altTabTable, altTabIndex, dir)

end -- function altTab

return {switch = switch}
