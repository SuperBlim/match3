--[[
    PauseState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PauseState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

PauseState = Class{__includes = BaseState}

function PauseState:init()
    -- nothing
end




--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]       
function PauseState:update(dt)
    if love.keyboard.wasPressed('e') then
    gStateMachine:change('play')
    end
end




function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Paused', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press "E" to unpause', 0, 100, VIRTUAL_WIDTH, 'center')
end