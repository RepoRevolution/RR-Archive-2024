local GUI, MenuType, OpenedMenus, CurrentNameSpace = {}, "default", 0, nil
GUI.Time = 0

local function openMenu(namespace, name, data)
    CurrentNameSpace = namespace
    OpenedMenus = OpenedMenus + 1
    SendNUIMessage({
        action = "openMenu",
        namespace = namespace,
        name = name,
        data = data,
    })
end

local function closeMenu(namespace, name)
    CurrentNameSpace = namespace
    OpenedMenus = OpenedMenus - 1
    if OpenedMenus < 0 then
        OpenedMenus = 0
    end
    SendNUIMessage({
        action = "closeMenu",
        namespace = namespace,
        name = name,
    })
end

AddEventHandler("onResourceStop", function(resource)
    if GetCurrentResourceName() == resource and OpenedMenus > 0 then
        ESX.UI.Menu.CloseAll()
    elseif CurrentNameSpace ~= nil and CurrentNameSpace == resource and OpenedMenus > 0 then
        ESX.UI.Menu.CloseAll()
    end
end)

ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

RegisterNUICallback("menu_submit", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
    if menu.submit ~= nil then
        menu.submit(data, menu)
    end
    cb("OK")
end)

RegisterNUICallback("menu_cancel", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

    if menu.cancel ~= nil then
        menu.cancel(data, menu)
    end
    cb("OK")
end)

RegisterNUICallback("menu_change", function(data, cb)
    local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

    for i = 1, #data.elements, 1 do
        menu.setElement(i, "value", data.elements[i].value)

        if data.elements[i].selected then
            menu.setElement(i, "selected", true)
        else
            menu.setElement(i, "selected", false)
        end
    end

    if menu.change ~= nil then
        menu.change(data, menu)
    end
    cb("OK")
end)

ESX.RegisterInput("menu_default_enter", "[ESX-MENU] Wybierz", "keyboard", "RETURN", function()
    if OpenedMenus > 0 and (GetGameTimer() - GUI.Time) > 200 then
        SendNUIMessage({
            action = "controlPressed",
            control = "ENTER",
        })
        GUI.Time = GetGameTimer()
    end
end)

ESX.RegisterInput("menu_default_backspace", "[ESX-MENU] Zamknij", "keyboard", "BACK", function()
    if OpenedMenus > 0 then
        SendNUIMessage({
            action = "controlPressed",
            control = "BACKSPACE",
        })
        GUI.Time = GetGameTimer()
    end
end)

ESX.RegisterInput("menu_default_top", "[ESX-MENU] W górę", "keyboard", "UP", function()
    if OpenedMenus > 0 then
        SendNUIMessage({
            action = "controlPressed",
            control = "TOP",
        })
        GUI.Time = GetGameTimer()
    end
end)

ESX.RegisterInput("menu_default_down", "[ESX-MENU] W dół", "keyboard", "DOWN", function()
    if OpenedMenus > 0 then
        SendNUIMessage({
            action = "controlPressed",
            control = "DOWN",
        })
        GUI.Time = GetGameTimer()
    end
end)

ESX.RegisterInput("menu_default_left", "[ESX-MENU] W lewo", "keyboard", "LEFT", function()
    if OpenedMenus > 0 then
        SendNUIMessage({
            action = "controlPressed",
            control = "LEFT",
        })
        GUI.Time = GetGameTimer()
    end
end)

ESX.RegisterInput("menu_default_right", "[ESX-MENU] W prawo", "keyboard", "RIGHT", function()
    if OpenedMenus > 0 then
        SendNUIMessage({
            action = "controlPressed",
            control = "RIGHT",
        })
        GUI.Time = GetGameTimer()
    end
end)
