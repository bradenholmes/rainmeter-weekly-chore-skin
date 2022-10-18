function Initialize()
    measureDay = SKIN:GetMeasure('MeasureDay')
    currentDay = measureDay:GetStringValue()

    emptyBox = SKIN:GetVariable('EmptyBox')
    checkedBox = SKIN:GetVariable('CheckedBox')

    maxItems = 6
    itemBox = "ItemBox"
    itemText = "ItemText"
    boxState = "BoxState"


    taskTable = {}
    taskTable["Everyday"] = {"Scoop Litter Box", "Chop Out"}
    taskTable["Monday"] = {"do Laundry", "Swiffer floor"}
    taskTable["Tuesday"] = {"Run Dishwasher", "Vacuum Carpet"}
    taskTable["Wednesday"] = {"Unload Dishwasher"}
    taskTable["Thursday"] = {"Handle Home Chef", "Take Recycling Out"}
    taskTable["Friday"] = {"Wash Sheets", "Clean Toilet"}
    taskTable["Saturday"] = {}
    taskTable["Sunday"] = {}

    LoadDay()
end

function Update()
    if currentDay ~= measureDay:GetStringValue() then
       LoadDay()
       return 
    end

    if SKIN:GetVariable('IsMouseHovering') == '1' then
        UpdateBoxes()
    end


end

function LoadDay()
    currentDay = measureDay:GetStringValue()
    itemTable = {}
    for _,v in ipairs(taskTable["Everyday"]) do
        table.insert(itemTable, v)
    end
    for _,v in ipairs(taskTable[currentDay]) do
        table.insert(itemTable, v)
    end

    for i=1,maxItems do
        value = itemTable[i]
        if value == nil then
            SKIN:Bang('!HideMeter', itemBox..i)
            SKIN:Bang('!HideMeter', itemText..i)
        else
            SKIN:Bang('!ShowMeter', itemBox..i)
            SKIN:Bang('!ShowMeter', itemText..i)
            SKIN:Bang('!SetOption', itemText..i, 'Text', value)
        end
        SKIN:Bang('!SetVariable', boxState..i, 0)
    end

    UpdateBoxes()


end

function UpdateBoxes()
    for i=1,maxItems do
        if SKIN:GetVariable(boxState..i) == '0' then
            SKIN:Bang('!SetOption', itemBox..i, 'ImageName', emptyBox)
            SKIN:Bang('!SetOption', itemText..i, 'MeterStyle', 'UncheckedText')
        else
            SKIN:Bang('!SetOption', itemBox..i, 'ImageName', checkedBox)
            SKIN:Bang('!SetOption', itemText..i, 'MeterStyle', 'CheckedText')
        end
    end
end