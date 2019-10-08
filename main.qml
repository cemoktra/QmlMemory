import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.1

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Memory")

    Game {
        id: game
        gamesize: 6
    }

    Component.onCompleted: {
        game.finished.connect(onFinished)
    }

    function onFinished()
    {
        popuptext.text = game.humanMove ? "Human wins!" : "CPU wins!"
        popup.visible = true
    }

    ColorAnimation { id: coloranim; duration: 200; }
    NumberAnimation { id: numberanim; duration: 200; }

    Text {
        id: humanPointsText
        anchors.margins: 5
        anchors.left: parent.left
        anchors.top: parent.top
        text: "Player: " + game.humanPoints
        color: game.humanMove ? "blue" : "black"
        font.bold: game.humanMove
        font.pointSize: 20

        Behavior on color { animation: coloranim }
    }


    Text {
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top
        text: "CPU: " + game.cpuPoints
        horizontalAlignment: Text.AlignRight
        color: game.humanMove ? "black" : "blue"
        font.bold: !game.humanMove
        font.pointSize: 20

        Behavior on color { animation: coloranim }
    }

    Rectangle {
        id: popup
        visible: false
        anchors.fill: parent        
        z: 3
        Text {
            id: popuptext
            anchors.centerIn: parent
            text: ""
            font.pointSize: 24
        }
        MouseArea {
            anchors.fill: parent
            onClicked: { 
                game.newGame()
            }
        }
    }

    GridLayout {
        id: cardlayout
        columns: game.gamesize

        anchors.margins: 5
        anchors.left: parent.left
        anchors.top: humanPointsText.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Repeater {
            model: game.deck.cards
            Rectangle {
                id: cardrect
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: (modelData.isOpen || modelData.isFound) ? modelData.cardcolor : "transparent"
                border.color: "black"
                radius: 5
                opacity: modelData.isFound ? 0.25 : 1.0
                signal clickedCard(int card)

                Component.onCompleted: { clickedCard.connect(game.doMove) }

                Behavior on color { animation: coloranim }
                Behavior on opacity { animation: numberanim }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: { 
                        if (game.moveEnabled)
                        {
                            cardrect.clickedCard(index)
                        }
                    }
                }
            }
        }
    }
}

