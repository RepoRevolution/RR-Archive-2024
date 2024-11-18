if GetResourceState('ox_inventory'):find('miss') then return end

Config.OxInventory = true

---@override
ESX.ShowInventory = nil

---@override
ESX.UI.ShowInventoryItemNotification = nil

function Client.StartServerSyncLoop() end ---@diagnostic disable-line: duplicate-set-field

function Client.StartDroppedItemsLoop() end ---@diagnostic disable-line: duplicate-set-field
