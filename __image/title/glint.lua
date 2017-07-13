--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:454bb112dd584bd1743074241cc20d2a:91c7a458c9bde492be765fa628d4809d:1fab29ad0d6495516a82ef09e31e48ab$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- glint1
            x=1,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint2
            x=83,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint3
            x=165,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint4
            x=247,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint5
            x=329,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint6
            x=411,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint7
            x=493,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint8
            x=575,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glint9
            x=657,
            y=1,
            width=80,
            height=80,

        },
        {
            -- glinta
            x=739,
            y=1,
            width=80,
            height=80,

        },
    },
    
    sheetContentWidth = 820,
    sheetContentHeight = 82
}

SheetInfo.frameIndex =
{

    ["glint1"] = 1,
    ["glint2"] = 2,
    ["glint3"] = 3,
    ["glint4"] = 4,
    ["glint5"] = 5,
    ["glint6"] = 6,
    ["glint7"] = 7,
    ["glint8"] = 8,
    ["glint9"] = 9,
    ["glinta"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
