local cfg <const> = config.security
local hits = {}

local function warn(src, reason)
    if cfg.log then
        print(("[xsound] blocked sound event from %s: %s"):format(src or "?", reason))
    end
end

local function allowed(src)
    local win <const> = cfg.rate.windowMs
    local t <const> = GetGameTimer()
    local rec = hits[src]
    if not rec or (t - rec.start) > win then
        hits[src] = { start = t, n = 1 }
        return true
    end
    if rec.n >= cfg.rate.count then return false end
    rec.n = rec.n + 1
    return true
end

local function clampVolume(v)
    v = tonumber(v) or 0.0
    if v < 0.0 then v = 0.0 end
    if v > cfg.maxVolume then v = cfg.maxVolume end
    return v + 0.0
end

local function extOk(file)
    local ext = file:match("%.([%a%d]+)$")
    if not ext then return false end
    ext = ext:lower()
    for _, e in ipairs(cfg.allowedExt) do
        if e == ext then return true end
    end
    return false
end

local function sanitizeFile(file)
    if type(file) ~= "string" or #file == 0 or #file > 256 then return nil end
    if file:find("%.%.") or file:find("[/\\]%.") then return nil end
    if not file:match("^[%w%-%_%./]+$") then return nil end
    if not extOk(file) then return nil end
    return file
end

local function domainOk(url)
    if type(url) ~= "string" or #url == 0 or #url > 1024 then return false end
    local host = url:match("^%w+://([^/]+)") or url:match("^([^/]+)")
    if not host then return false end
    host = host:lower()
    for _, d in ipairs(cfg.allowedDomains) do
        if host == d or host:sub(-(#d + 1)) == ("." .. d) then return true end
    end
    return false
end

local function broadcastGate(src)
    if cfg.broadcastAce == "" then return true end
    return IsPlayerAceAllowed(src, cfg.broadcastAce)
end

local function check(src, kind, data)
    if not cfg.enabled then return true, data end
    if not allowed(src) then warn(src, "rate-limit"); return false end
    if kind == "broadcast" and not broadcastGate(src) then warn(src, "broadcast not permitted"); return false end

    local out = {}
    if data.file ~= nil then
        local f = sanitizeFile(data.file)
        if not f then warn(src, "bad file"); return false end
        out.file = f
    end
    if data.url ~= nil then
        if not domainOk(data.url) then warn(src, "bad url"); return false end
        out.url = data.url
    end
    if data.volume ~= nil then out.volume = clampVolume(data.volume) end
    if data.distance ~= nil then
        local d = tonumber(data.distance) or 0.0
        if d < 0.0 then d = 0.0 end
        if d > 500.0 then d = 500.0 end
        out.distance = d + 0.0
    end
    return true, out
end

Security = { check = check, allowed = allowed }

AddEventHandler("playerDropped", function()
    hits[source] = nil
end)
