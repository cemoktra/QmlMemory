import QtQuick 2.0
import "cpu.js" as CPU

Item {
    property int humanPoints: 0;
    property int cpuPoints: 0;
    property int gamesize: 3;
    property int move: 0
    property bool moveEnabled: true
    property int wait: 1000
    
    property alias deck : gamedeck
    property bool humanMove: true

    Deck {
        id: gamedeck
    }

    signal signalNextPlayer()
    signal finished()
    signal signalCpuMove()
    signal signalNextMove()

    Component.onCompleted: {
        var varx = gamesize *  gamesize;
        if (varx % 2 == 1)
        {
            varx--
        }
        gamedeck.decksize = varx
        signalNextPlayer.connect(nextPlayerTimer)
        signalCpuMove.connect(cpuMove)
        signalNextMove.connect(nextMove)
    }

    function newGame()
    {
        humanPoints = 0
        cpuPoints = 0
        move = 0
        moveEnabled = true
        humanMove = true
        deck.createCards()
        CPU.reset()
    }

    function doMove(card)
    {
        if (move >= 2 || deck.cards[card].isFound || deck.cards[card].isOpen) {
            return false
        }
        deck.cards[card].isOpen = true
        move++

        if (move == 2) {
            moveEnabled = false
            CPU.updateKnowledge()
            if (hasScoredOnMove()) {
                move = 0                
                if (humanMove) {
                    humanPoints++
                    
                } else {
                    cpuPoints++
                }
                if (!checkEnd()) {
                    signalNextMove()
                }
            } else {
                signalNextPlayer()
            }
        }

        return true;
    }    

    function nextMoveTimer()
    {
        nextMove()
    }

    function nextMove()
    {
        for (var i = 0; i < deck.decksize;i++)
        {
            deck.cards[i].isOpen = false
        }
        if (humanMove) {
            moveEnabled = true
        } else {
            cpuMove()
        }
    }

    function cpuMove()
    {
        if (move == 0) {
            CPU.doCPUMoveOne()
            var timer = new createTimer();
            timer.interval = wait;
            timer.repeat = false;
            timer.triggered.connect(signalCpuMove)
            timer.start()

        } else {
            CPU.doCPUMoveTwo()
        }
    }

    function nextPlayerTimer()
    {
        var timer = new createTimer();
        timer.interval = wait;
        timer.repeat = false;
        timer.triggered.connect(nextPlayer)
        timer.start()        
    }

    function nextPlayer()
    {
        humanMove = !humanMove
        move = 0
        moveEnabled = true
        for (var i = 0; i < deck.decksize;i++)
        {
            deck.cards[i].isOpen = false
        }

        if (!humanMove)
        {
            signalCpuMove()
        }
    }

    function hasScoredOnMove()
    {
        var index = undefined

        for (var i = 0; i < deck.decksize;i++)
        {
            if (index == undefined && deck.cards[i].isOpen) {
                index = i
            } else if (deck.cards[i].isOpen && deck.cards[index].cardcolor == deck.cards[i].cardcolor) {
                deck.cards[index].isFound = true
                deck.cards[i].isFound = true
                deck.cardsleft = deck.cardsleft - 2
                return true
            }
        }
        return false
    }

    function checkEnd() {
        if (!deck.anyCardsLeft()) {
            finished()
            return true
        }
        return false
    }

    function createTimer() {
        return Qt.createQmlObject("import QtQuick 2.0; Timer {}", deck);
    }
}