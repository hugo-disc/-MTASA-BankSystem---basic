local screen = { guiGetScreenSize() }
local x, y = screen[1] / 1920, screen[2] / 1080
local aberto = false
local window = 3

local element = createElement('editBox')
local elementRG = createElement('editBox')

function dxDraw()

    if window == 1 then
        dxDrawImage(x*614, y*316, x*787, y*442, 'assets/Deposito.png')
        dxDrawEditBox('', x*880, y*576, x*327, y*43, false, 20, element, 12, 12, 12, 0, 255, 255, 255, 255, 1.5)
        return
    end

    if window == 2 then
        dxDrawImage(x*614, y*316, x*787, y*442, 'assets/Saque.png')
        dxDrawEditBox('', x*880, y*576, x*327, y*43, false, 20, element, 12, 12, 12, 0, 255, 255, 255, 255, 1.5)
        return
    end

    if window == 3 then
        dxDrawImage(x*614, y*316, x*787, y*442, 'assets/Transfer.png')
        dxDrawEditBox('', x*880, y*576, x*327, y*43, false, 20, element, 12, 12, 12, 0, 255, 255, 255, 255, 1.5)
        dxDrawEditBox('', x*880, y*627, x*281, y*43, false, 20, elementRG, 12, 12, 12, 0, 255, 255, 255, 255, 1.5)
        return
    end
end

bindKey('F2', 'down', function()
    if aberto then
        showCursor(false)
        aberto = false
        removeEventHandler('onClientRender', root, dxDraw)
    else
        showCursor(true) 
        aberto = true
        addEventHandler('onClientRender', root, dxDraw)
        triggerServerEvent('bankRegister', localPlayer)
    end
end)

function finish( button, state )

    if aberto then
        
        if window == 3 then
            if posMouse(x*1131, y*627, x*40, y*41) then
                if button == 'left' and state == 'down' then
                    triggerServerEvent('bankTransfer', localPlayer, getElementData(element, 'text2'), getElementData(elementRG, 'text2'))
                end
            end
        end

        if posMouse(x*844, y*630, x*327, y*43) then
            if button == 'left' and state == 'down' then
                if window == 1 then
                    triggerServerEvent('bankDeposit', localPlayer, getElementData(element, 'text2'))
                end
                if window == 2 then
                    triggerServerEvent('bankWithdraw', localPlayer, getElementData(element, 'text2'))
                end
            end
        end
    end
end

function changeScreen( button, state )
    if aberto then
        if button == 'left' and state == 'down' then
            -- JANELA DEPOSITO
            if posMouse(x*691.92, y*485.68, x*25.22, y*25.22 ) then
                window = 1
            end
            -- JANELA SAQUE
            if posMouse(x*691.92, y*523.51, x*25.22, y*26.8 ) then
                window = 2
            end
            -- JANELA TRANSFERENCIA
            if posMouse(x*691.92, y*562.92, x*25.22, y*25.22 ) then
                window = 3
            end
        end
    end
end

-- ADD EVENT'S

addEventHandler('onClientClick', root, changeScreen) -- trocar aba
addEventHandler('onClientClick', root, finish) -- botao finalizar

--- UTILS

function posMouse(x,y,w,h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx*resx, my*resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end
