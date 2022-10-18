function Initialize()
    -- Load variables
    emptyBox = SKIN:GetVariable('EmptyBox')
    checkedBox = SKIN:GetVariable('CheckedBox')
    uncheckedStyle = SKIN:GetVariable('UncheckedStyle')
    checkedStyle = SKIN:GetVariable('CheckedStyle')
    SKIN:Bang('SetVariable', 'IsMouseHovering', 0)


    -- Get current day from measure (ex. 'Saturday')
    measureDay = SKIN:GetMeasure('MeasureDay')
    currentDay = measureDay:GetStringValue()

    -- Define Meter/Variable names
    maxItems = 9
    itemBox = "ItemBox"
    itemText = "ItemText"
    boxState = "BoxState"

    -- Task definition. Modify to make these relevant to you!
    taskTable = {}
    taskTable["Everyday"] = {"Scoop Litter Box", "Chop Out"}
    taskTable["Monday"] = {"do Laundry", "Swiffer floor"}
    taskTable["Tuesday"] = {"Run Dishwasher", "Vacuum Carpet"}
    taskTable["Wednesday"] = {"Unload Dishwasher"}
    taskTable["Thursday"] = {"Handle Home Chef", "Take Recycling Out"}
    taskTable["Friday"] = {"Wash Sheets", "Clean Toilet"}
    taskTable["Saturday"] = {}
    taskTable["Sunday"] = {}

    
    InitMeters()
    LoadDay()
end

function Update()
    -- If the current day is different from the measure value
    if currentDay ~= measureDay:GetStringValue() then
        -- We've reached midnight and it's a new day. Reload the list
        LoadDay()
        return 
    end

    -- Only update boxes when mouse is hoving over the skin to maximize performance
    if SKIN:GetVariable('IsMouseHovering') == '1' then
        UpdateBoxes()
    end


end

function LoadDay()
    currentDay = measureDay:GetStringValue()

    -- Create a table containing the tasks for today (Everyday tasks + current day tasks)
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
            -- Hide this list item
            SKIN:Bang('!HideMeter', itemBox..i)
            SKIN:Bang('!HideMeter', itemText..i)
        else
            -- Show this list item, set text value
            SKIN:Bang('!ShowMeter', itemBox..i)
            SKIN:Bang('!ShowMeter', itemText..i)
            SKIN:Bang('!SetOption', itemText..i, 'Text', value)
        end
        SKIN:Bang('!SetVariable', boxState..i, 0)
    end

    UpdateBoxes()


end

function UpdateBoxes()
    -- For all boxes, sets box image and text style based on the box state (checked or unchecked)
    for i=1,maxItems do
        if SKIN:GetVariable(boxState..i) == '0' then
            SKIN:Bang('!SetOption', itemBox..i, 'ImageName', emptyBox)
            SKIN:Bang('!SetOption', itemText..i, 'MeterStyle', uncheckedStyle)
        else
            SKIN:Bang('!SetOption', itemBox..i, 'ImageName', checkedBox)
            SKIN:Bang('!SetOption', itemText..i, 'MeterStyle', checkedStyle)
        end
    end
end

function InitMeters()

    boxSize = SKIN:GetVariable('BoxSize')
    boxTextGapSize = SKIN:GetVariable('BoxTextGapSize')

    for i=1,maxItems do
        box = itemBox..i
        text = itemText..i
        state = boxState..i

        --create box state variable for this box (1 or 0)
        SKIN:Bang('SetVariable', state, 0)
        --set options for box
        mouseActionString = '[!SetVariable '..state..' (1-#'..state..'#)]'
        SKIN:Bang('!SetOption', box, 'LeftMouseUpAction', mouseActionString)
        SKIN:Bang('!SetOption', box, 'ImageName', emptyBox)
        SKIN:Bang('!SetOption', box, 'DynamicVariables', 1)
        SKIN:Bang('!SetOption', box, 'W', boxSize)
        SKIN:Bang('!SetOption', box, 'H', boxSize)
        SKIN:Bang('!SetOption', box, 'X', 0)
        SKIN:Bang('!SetOption', box, 'Y', boxSize * i)
        --set options for text
        SKIN:Bang('!SetOption', text, 'X', boxSize + boxTextGapSize)
        SKIN:Bang('!SetOption', text, 'Y', boxSize * i)
        SKIN:Bang('!SetOption', text, 'MeterStyle', uncheckedStyle)


    end
end