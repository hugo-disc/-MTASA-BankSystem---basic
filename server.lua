local db = dbConnect('sqlite', 'banco.sqlite')
dbExec(db, 'CREATE TABLE IF not EXISTS usuarios (login, money)')

local function deposit(value)
        local player = source
        if tonumber(value) then
        
            if tonumber(value) < 0 or tonumber(value) == -0 then
                exports['infobox']:addBox(player, 'Quantia inválida!', 'error')
                return
            end
    
            local poll = dbPoll(dbQuery(db, 'SELECT * FROM usuarios WHERE login = ?', getAccountName(getPlayerAccount(player))), -1)

            local playerBankMoney = poll[1]['money']
    
            if getPlayerMoney(player) < tonumber(value) then
                exports['infobox']:addBox(player, 'Você não possui essa quantia para depositar!', 'error')
                return
            end
    
            dbExec(db, 'UPDATE usuarios SET money = ? WHERE login = ?', tonumber(playerBankMoney) + tonumber(value), getAccountName(getPlayerAccount(player)))
            givePlayerMoney(player, value)
            exports['infobox']:addBox(player, 'Você depositou R$ '..value..' com sucesso!', 'success')
    
        else
            exports['infobox']:addBox(player, 'O valor inserido não é um número!', 'error')
            return
    end
end

local function withdraw(value)
    local player = source
    if tonumber(value) then
        
        if tonumber(value) < 0 or tonumber(value) == -0 then
            exports['infobox']:addBox(player, 'Quantia inválida!', 'error')
            return
        end

        local poll = dbPoll(dbQuery(db, 'SELECT * FROM usuarios WHERE login = ?', getAccountName(getPlayerAccount(player))), -1)

        local playerBankMoney = poll[1]['money']

        if tonumber(playerBankMoney) < tonumber(value) then
            exports['infobox']:addBox(player, 'Você não possui essa quantia para retirar!', 'error')
            return
        end

        dbExec(db, 'UPDATE usuarios SET money = ? WHERE login = ?', tonumber(playerBankMoney) - tonumber(value), getAccountName(getPlayerAccount(player)))
        givePlayerMoney(player, value)
        exports['infobox']:addBox(player, 'Você realizou o saque de R$ '..value..' com sucesso!', 'success')

    else
        exports['infobox']:addBox(player, 'O valor inserido não é um número!', 'error')
        return
    end

end

local function transfer(value, id)
    local player = source

    if tonumber(value) then
        if tonumber(value) < 0 or tonumber(value) == -0 then
            exports['infobox']:addBox(player, 'Quantia inválida!', 'error')
            return
        end

        if idGetPlayer(id) then
            local playerInfo = idGetPlayer(id)
            local userBank = dbPoll(dbQuery(db, 'SELECT * FROM usuarios WHERE login = ?', getAccountName(getPlayerAccount(player))), -1)
            local targetBank = dbPoll(dbQuery(db, 'SELECT * FROM usuarios WHERE login = ?', getAccountName(getPlayerAccount(playerInfo))), -1)


            if getElementData(source, 'ID') == tonumber(id) then
                exports['infobox']:addBox(player, 'Você não pode se enviar dinheiro!', 'error')
                return 
            end

            if #targetBank == 0 then
                exports['infobox']:addBox(player, 'O usuário ainda não se registrou no banco!', 'info')
                return
            end

            if tonumber(userBank[1]['money']) < tonumber(value) then
                exports['infobox']:addBox(player, 'Você não possui essa quantia no banco!', 'error')
                return
            end

            dbExec(db, 'UPDATE usuarios SET money = ? WHERE login = ?', tonumber(userBank[1]['money'])-tonumber(value), getAccountName(getPlayerAccount(player)) )
            dbExec(db, 'UPDATE usuarios SET money = ? WHERE login = ?', tonumber(targetBank[1]['money'])+tonumber(value), getAccountName(getPlayerAccount(playerInfo)))

            exports['infobox']:addBox(player, 'Você transferiu o valor de R$ '.. value ..' com sucesso!\nAgora possui R$ '..tonumber(userBank[1]['money'])-tonumber(value), 'success') 
        else
            exports['infobox']:addBox(player, 'O portador do RG inserido não está na cidade!', 'warning')
            
        end
    else
        exports['infobox']:addBox(player, 'O valor inserido precisa ser um número!', 'error')
    end
    
end

local function bankRegister()

    local poll = dbPoll(dbQuery(db, 'SELECT * FROM usuarios WHERE login = ?', getAccountName( getPlayerAccount(source) )), -1)

    if #poll == 0 then
            dbExec(db, 'INSERT INTO usuarios VALUES (?, ?)', getAccountName(getPlayerAccount(source)), 0)
        return 
    end

end

-- FUNÇÕES UTÉIS

function idGetPlayer(id)
    local jogador = false

    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'ID') == tonumber(id) then
            jogador = v
            break;
        end
    end

    return jogador
end

-- ADD EVENT'S

addEvent('bankDeposit', true)
addEvent('bankWithdraw', true)
addEvent('bankTransfer', true)
addEvent('bankRegister', true)

addEventHandler('bankDeposit', root, deposit)
addEventHandler('bankWithdraw', root, withdraw)
addEventHandler('bankTransfer', root, transfer)
addEventHandler('bankRegister', root, bankRegister)