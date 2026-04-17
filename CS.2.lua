--========================================================
-- 🔥 LTA HUB FINAL (ONLINE + FALLBACK)
--========================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local HttpService = game:GetService("HttpService")

--========================================================
-- 🌐 CONFIG
--========================================================

local JSON_URL = "https://raw.githubusercontent.com/davilucasalves13k-png/Hdhd/main/scripts.json"

-- fallback (caso JSON falhe)
local ScriptsDB = {
    {
        Nome = "Infinite Yield",
        Categoria = "Admin",
        Desc = "Comandos admin",
        Data = "2023",
        Usos = 99999,
        Link = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
    }
}

--========================================================
-- 📡 CARREGAR JSON
--========================================================

pcall(function()
    local data = game:HttpGet(JSON_URL)
    local decoded = HttpService:JSONDecode(data)

    if decoded and #decoded > 0 then
        ScriptsDB = decoded
    end
end)

--========================================================
-- 🎨 UI
--========================================================

local Window = Rayfield:CreateWindow({
    Name = "🔥 LTA Hub",
    LoadingTitle = "Inicializando LTA Hub...",
    ConfigurationSaving = {Enabled = false}
})

local TabScripts = Window:CreateTab("📦 Scripts")
local TabBusca = Window:CreateTab("🔎 Buscar")
local TabInfo = Window:CreateTab("📄 Info")

--========================================================
-- 📄 INFO
--========================================================

local InfoUI = {}

local function LimparInfo()
    for _,v in pairs(InfoUI) do
        pcall(function() v:Destroy() end)
    end
    InfoUI = {}
end

local function AbrirInfo(script)
    LimparInfo()

    table.insert(InfoUI, TabInfo:CreateLabel("📌 "..(script.Nome or "N/A")))
    table.insert(InfoUI, TabInfo:CreateLabel("📂 "..(script.Categoria or "N/A")))
    table.insert(InfoUI, TabInfo:CreateLabel("📝 "..(script.Desc or "Sem descrição")))
    table.insert(InfoUI, TabInfo:CreateLabel("📅 "..(script.Data or "?")))
    table.insert(InfoUI, TabInfo:CreateLabel("🔥 Usos: "..(script.Usos or 0)))

    local btn = TabInfo:CreateButton({
        Name = "🚀 Executar",
        Callback = function()
            local ok,err = pcall(function()
                loadstring(game:HttpGet(script.Link))()
            end)

            if not ok then
                warn("Erro ao executar: "..tostring(script.Nome))
            end
        end
    })

    table.insert(InfoUI, btn)
end

--========================================================
-- 📦 LISTA
--========================================================

for _,s in ipairs(ScriptsDB) do
    TabScripts:CreateButton({
        Name = s.Nome or "Script",
        Callback = function()
            AbrirInfo(s)
        end
    })
end

--========================================================
-- 🔎 BUSCA
--========================================================

local Resultados = {}

local function LimparBusca()
    for _,v in pairs(Resultados) do
        pcall(function() v:Destroy() end)
    end
    Resultados = {}
end

TabBusca:CreateInput({
    Name = "Pesquisar",
    PlaceholderText = "Digite qualquer coisa...",
    Callback = function(text)
        LimparBusca()

        local busca = string.lower(text or "")

        for _,s in ipairs(ScriptsDB) do
            if busca == "" or string.find(string.lower(s.Nome or ""), busca) then
                local btn = TabBusca:CreateButton({
                    Name = s.Nome or "Script",
                    Callback = function()
                        AbrirInfo(s)
                    end
                })

                table.insert(Resultados, btn)
            end
        end
    end
})

--========================================================
-- 🚀 START
--========================================================

Rayfield:Notify({
    Title = "LTA Hub",
    Content = "Hub carregado com sucesso 😈",
    Duration = 5
})
