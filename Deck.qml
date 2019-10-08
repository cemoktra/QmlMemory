import QtQuick 2.0
import "iwanthue/index.js" as IWantHue

Item {
    id: deck
    property int decksize
    property int cardsleft: 0
    property list<Card> cards

    function createCards()
    {
        var settings = {
            colorFilter: null,
            colorSpace: 'fancy-dark',
            clustering: 'k-means',
            quality: 50,
            ultraPrecision: false,
            distance: 'euclidean',
            seed: null
        };
        var colors = IWantHue.generatePalette(decksize / 2, settings)
        
        for (var i = 0; i < decksize;i++)
        {
            var component = Qt.createComponent("Card.qml")
            var card = component.createObject(deck, { 
                cardcolor: colors[i % (decksize / 2)], 
                isOpen: false, 
                isFound: false
            })
            
            if (i >= cards.length)
                cards.push(card)
            else
                cards[i] = card
        }
        shuffle()

        cardsleft = decksize
    }

    function shuffle()
    {
        var counter = cards.length;
        while (counter > 0) {
            var index = Math.floor(Math.random() * counter);
            counter--;

            var temp = cards[counter].cardcolor;
            cards[counter].cardcolor = cards[index].cardcolor;
            cards[index].cardcolor = temp;
        }
    }

    onDecksizeChanged: {
        createCards()
    }

    function anyCardsLeft()
    {
        return cardsleft > 0
    }
}