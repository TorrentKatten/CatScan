DEADMINES = {"Deadmines", "Dead Mines", "DM", "VanCleef", "Van Cleef"}
RAGEFIRE_CHASM = {"Ragefire Chasm", "RFC"}
WAILING_CAVERNS = {"Wailing Caversn", "WC"}
ZUL_FARRAK = {"Zul'Farrak", "Zulfarrak", "ZF"}
ZUL_GURUB = {"Zul'Gurub", "ZG", "Hakkar"}

SELECTION = {}

DEFAULT_CHAT_FRAME:AddMessage("CatScan Loaded!")

function CS_OnLoad()
    local frame = getglobal("CatScanFrame")
    frame:RegisterEvent("CHAT_MSG_CHANNEL")

    CS_add_to_selection(DEADMINES)
    CS_add_to_selection(RAGEFIRE_CHASM)
    CS_add_to_selection(WAILING_CAVERNS)
    CS_add_to_selection(ZUL_FARRAK)
    CS_add_to_selection(ZUL_GURUB)
    table.foreach(SELECTION, print)
end

function CS_add_to_selection(selected)
    for k, v in pairs(selected) do
        table.insert(SELECTION, string.lower(v))
    end
end

function CS_EventHandler(self, event, ...)
    if (event == "CHAT_MSG_CHANNEL") then
        local chat_message,
            author,
            language,
            channel,
            target_player,
            chat_flag,
            zone_id,
            channel_number,
            channel_name,
            line_id,
            sender_guid = ...
        CS_ChatMessageHandler(
            chat_message,
            author,
            language,
            channel,
            target_player,
            chat_flag,
            zone_id,
            channel_number,
            channel_name,
            line_id,
            sender_guid
        )
    end
end

function CS_ChatMessageHandler(
    chat_message,
    author,
    language,
    channel,
    target_player,
    chat_flag,
    zone_id,
    channel_number,
    channel_name,
    line_id,
    sender_guid)
    if (isBoost(chat_message)) then
        DEFAULT_CHAT_FRAME:AddMessage("Boost filtered out")
    elseif (isLFG(chat_message) and isSelected(chat_message, SELECTION)) then
        message(chat_message)
    end
end

function isBoost(chat_message)
    DEFAULT_CHAT_FRAME:AddMessage("checking boost")
    if (string.find(string.lower(chat_message), "boost")) then
        return true
    else
        return false
    end
end

function isLFG(chat_message)
    DEFAULT_CHAT_FRAME:AddMessage("checking LFG/LFM")
    if (string.find(string.lower(chat_message), "lfg") or string.find(string.lower(chat_message), "lfm")) then
        return true
    else
        return false
    end
end

function isSelected(chat_message)
    DEFAULT_CHAT_FRAME:AddMessage("checking selection")
    for token in string.gmatch(string.lower(chat_message), "[^%s]+") do
        DEFAULT_CHAT_FRAME:AddMessage("checking selection" .. token)
        if (tContains(SELECTION, token)) then
            return true
        end
    end
    return false
end