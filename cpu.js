var knowledgeMap = new Map()
var knowledgeAgeMap = new Map()
var card1 = -1
var aging = 0.1

function doCPUMoveOne()
{
    for (var key1 of knowledgeMap.keys()) {
        for (var key2 of knowledgeMap.keys()) {
            var item1 = knowledgeMap.get(key1)
            var item2 = knowledgeMap.get(key2)
            if (key1 != key2) {
                if (item1 != undefined && item1 == item2) {
                    var age = knowledgeAgeMap.get(key1)
                    if (normalRand.pickCorrectCard(1.0 - age == undefined ? 1.0 : age < 0.00001 ? 0.0 : age) && game.doMove(key1)) {
                        print("CPU MOVE 1: picked correct card based on map. card1 = " + key1 + ", card2 = " + key2 + ", age = " + age)
                        card1 = key1
                        return;
                    } else {
                        print("CPU MOVE 1: go to random even if knowledge about cards. age = " + age)
                        break;
                    }
                }
            }
        }
    }

    do {
        card1 = parseInt(Math.random() * gamedeck.decksize)
    } while (!game.doMove(card1));
}

function doCPUMoveTwo()
{
    if (card1 >= 0)
    {
        var firstcolor = deck.cards[card1].cardcolor
        
        for (var key of knowledgeMap.keys()) {
            if (key != card1) {
                var item = knowledgeMap.get(key)
                if (item == firstcolor) {
                    var age = knowledgeAgeMap.get(key)
                    if (normalRand.pickCorrectCard(1.0 - age == undefined ? 1.0 : age < 0.00001 ? 0.0 : age) && game.doMove(key)) {
                        print("CPU MOVE 2: picked correct card based on map. card1 = " + card1 + ", card2 = " + key + ", age = " + age)
                        return;
                    } else {
                        print("CPU MOVE 2: go to random even if knowledge about cards. age = " + age)
                        break;
                    }
                }
            }
        }
        card1 = -1
    }
    
    do {
        var card = parseInt(Math.random() * gamedeck.decksize)
    } while (!game.doMove(card));
}

function updateKnowledge()
{
    for (var i = 0; i < deck.decksize; i++)
    {
        var item = knowledgeAgeMap.get(i)
        if (item != undefined) {
            knowledgeAgeMap.set(i, item - aging)
        }
        if (deck.cards[i].isOpen) {
            knowledgeMap.set(i, deck.cards[i].cardcolor)
            knowledgeAgeMap.set(i, 1.0)
        }
        if (deck.cards[i].isFound || knowledgeAgeMap.get(i) <= 0.00001) {
            knowledgeMap.delete(i)
            knowledgeAgeMap.delete(i)
        }
    }

    print("======================================================")
    for (var key of knowledgeMap.keys()) {
        var item = knowledgeMap.get(key)
        print("key = " + key + ", item = " + item + ", age = " + knowledgeAgeMap.get(key))
    }
    print("======================================================")
}

function reset()
{
    knowledgeMap = new Map()
    knowledgeAgeMap = new Map()    
}