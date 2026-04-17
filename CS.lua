--========================================================
-- 🔥 LTA HUB (ONLINE FINAL)
--========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")

--========================================================
-- 🌐 BANCO ONLINE
--========================================================

local JSON_URL = "https://raw.githubusercontent.com/davilucasalves13k-png/Hdhd/main/scripts.json"

local ScriptsDB = {}

pcall(function()
    local data = game:HttpGet(JSON_URL)
    ScriptsDB = HttpService:JSONDecode(data)
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

    table.insert(InfoUI, TabInfo:CreateLabel("📌 "..script.Nome))
    table.insert(InfoUI, TabInfo:CreateLabel("📂 "..script.Categoria))
    table.insert(InfoUI, TabInfo:CreateLabel("📝 "..script.Desc))
    table.insert(InfoUI, TabInfo:CreateLabel("📅 "..script.Data))
    table.insert(InfoUI, TabInfo:CreateLabel("🔥 Usos: "..script.Usos))

    local btn = TabInfo:CreateButton({
        Name = "🚀 Executar",
        Callback = function()
            script.Usos = script.Usos + 1

            local ok,err = pcall(function()
                loadstring(game:HttpGet(script.Link))()
            end)

            if not ok then
                warn("Erro ao executar: "..script.Nome)
            end
        end
    })

    table.insert(InfoUI, btn)
end

--========================================================
-- 📦 LISTAR SCRIPTS
--========================================================

for _,s in ipairs(ScriptsDB) do
    TabScripts:CreateButton({
        Name = s.Nome,
        Callback = function()
            AbrirInfo(s)
        end
    })
end

--========================================================
-- 🔎 BUSCA INTELIGENTE
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
            if busca == "" or string.find(string.lower(s.Nome), busca) then
                local btn = TabBusca:CreateButton({
                    Name = s.Nome,
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
    Content = "Sistema carregado 😈",
    Duration = 5
})
