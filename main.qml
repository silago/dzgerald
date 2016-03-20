import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.1

Window {
        id: wind
        visible: true


        Item {
            id: user_list_view
            objectName: "user_list_view"
            visible: false;

        }

        Button {
            id: showSearchWindow
            objectName:"showSearchWindow"
            text: qsTr("К поиску")
            z: 2
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 50
            onClicked: {
                search_view.visible=true;
                user_info_view.visible=false;
                newUserItem.visible=false;
                user_list_view.visible=false;
                showSearchWindow.visible=false;
            }
        }

        Item {
            id : user_info_view
            visible: false
            objectName: "user_info_view"
            anchors.fill : parent

            Rectangle {
                id: user_info_view_rectangle
                x: 0
                width: 640
                height: 36
                anchors.fill : parent

                Rectangle {
                    id: paymentsList
                    objectName: "paymentsList"
                    property int lines:0
                    anchors.horizontalCenterOffset: -60
                    anchors.verticalCenterOffset: -90
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    onLinesChanged: {
                        var l =  paymentsList.lines;
                        if (l==0) {
                            for(var i = paymentsList.children.length; i > 0 ; i--) {
                                    console.log("destroying: " + i)
                                    contentGrid.children[i-1].destroy()
                            }
                        }

                        Qt.createQmlObject(
                                    'import QtQuick 2.0; Text { objectName:"paymentLine'+l+'"; text:"exexe"; y:'+20*l+' }',
                                    paymentsList,
                                    'paymentLine'+l);
                        //Qt.createQmlObject(sc, user_info_view_rectangle, 'ouo1u'+l);
                        //Qt.createQmlObject(sc, user_info_view_rectangle, 'ouo2u'+l);
                        //Qt.createQmlObject(sc, user_info_view_rectangle, 'ouo3u'+l);
                        //Qt.createQmlObject(sc, user_info_view_rectangle, 'ouo4u'+l);
                        //Qt.createQmlObject(sc, user_info_view_rectangle, 'ouo5u'+l);
                    }
                }


                Text {
                    id: user_info_caption
                    objectName: "user_info_caption"
                    x: 14
                    y: 12
                    text: "Jane Doe"
                    anchors.verticalCenterOffset: -100
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "Courier"
                }

                Text {
                    id: last_payments_title
                    objectName: "last_payments_title"
                    x: 14
                    y: 12
                    text: "Последние покупки"
                    anchors.verticalCenterOffset: -80
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "Courier"
                }


                TextField {
                    id: iSumm
                    objectName: "iSumm"
                    x: 14
                    y: 39
                    width: 100
                    height: 30
                    anchors.horizontalCenterOffset: -30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    property real discount: 0
                    onTextChanged: {
                        summWithDiscount.text = '' + (iSumm.text - ( iSumm.text * iSumm.discount).toFixed(2));
                    }
                }
                Text {
                    id: text1
                    text:"Цена с учетом скидки: "
                    font.pointSize: 7
                    font.italic: false
                    textFormat: Text.PlainText
                    z: 23
                    anchors.horizontalCenterOffset: -30
                    anchors.verticalCenterOffset: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: summWithDiscount
                        width: 58
                        height: 30
                        font.pointSize: 7
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 120
                        z: 8
                    }
                }
                Button {
                    id: add_payment_button
                    objectName: "add_payment_button"
                    width: 33
                    height: 30
                    text: qsTr(" + ")
                    anchors.horizontalCenterOffset: 60
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        addPayment(summWithDiscount.text);

                    }
                    signal addPayment(string summ)
                }
            }

        }

        Item {

            id: newUserItem
            objectName: "newUserItem"
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            visible: false
            anchors.fill: parent;
            TextField {
                id:newUserCardId
                anchors.verticalCenterOffset: -120
                anchors.horizontalCenterOffset: 0
                width:100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "card_id"
            }
            TextField {
                id:newUserName
                placeholderText: "name"
                anchors.verticalCenterOffset: -90
                anchors.horizontalCenterOffset: 0
                width:100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:newUserEmail
                placeholderText: "email"
                anchors.verticalCenterOffset: -60
                anchors.horizontalCenterOffset: 0
                width:100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextField {
                id:newUserPhone
                placeholderText: "phone"
                width:100
                anchors.verticalCenterOffset: -30
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text:"Отправить"
                id:newUserButton
                objectName: "newUserButton"
                width:100
                anchors.verticalCenterOffset: -0
                anchors.horizontalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if (newUserCardId.text && newUserName.text && newUserEmail.text && newUserPhone.text) {
                        addUser(newUserCardId.text, newUserName.text, newUserEmail.text, newUserPhone.text);
                    }
                }
                signal addUser(string card_id, string name, string email, string phone)
            }

        }

        Item {

            id : search_view
            objectName: "search_view"
            visible: true
            Rectangle {
                id: rectangle1
                x: 132
                y: 221
                width: 389
                height: 84
                color: "#ffffff"
                transformOrigin: Item.Center

                border.color: "#cbcbcb"

            TextField {
                id: iCardNumber
                y: 9
                height: 20
                anchors.right: parent.right
                anchors.rightMargin: 80
                anchors.left: parent.left
                anchors.leftMargin: 40
                transformOrigin: Item.Left
                font.family: "Courier"
                font.pixelSize: 17
                placeholderText: "Поиск по номеру карты"
            }

            Button {
                id: showAddUserForm
                x: 37
                y: 36
                text: qsTr("Добавить карту")
                onClicked: {
                    search_view.visible=false;
                    showSearchWindow.visible=true;
                    user_info_view.visible=false;
                    newUserItem.visible=true;
                    user_list_view.visible=false;
                }
            }

}

            Rectangle {
                id: buttonRectangle
                x: 468
                y: 230
                width: 46
                height:20
                border.color: "#c4c4c4"
            }

            Text {
                id: searchButton
                x: 470
                y: 233
                text: qsTr("Найти")
                font.pixelSize: 12
            }

            MouseArea {
                id: searchButtonArea
                x: 470
                y: 233
                width: 44
                height: 14
                onClicked: {
                    qmlSignal(iCardNumber.text);
                }
                signal qmlSignal(string msg)
                objectName: "searchButtonArea"
            }
        }
}
