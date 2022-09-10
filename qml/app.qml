import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window
    width: 600
    height: 500
    visible: true
    title: qsTr("App Home")
    ToastManager{ id: toast }

    // SET MATERIAL STYLE
    Material.theme: Material.Dark
    Material.accent: Material.Orange


    // CUSTOM PROPERTIES
    property string textUsername: "User"
    property string textPassword: "Pass"


    TextField{
        id: input
        width: 300
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("期待的号码")
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.top: window.bottom
        // anchors.margins: 60
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 40
        }
    }

    ButtonGroup {
        id: buttonGroup
        buttons: row.children
    }

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: input.bottom
        anchors.topMargin: 20
            RadioButton {
                id: radio1
                checked: true
                text: qsTr("前缀")
            }

            RadioButton {
                id: radio2
                text: qsTr("后缀")
            }

            RadioButton {
                id: radio3
                text: qsTr("前缀+后缀")
            }
    }

    Row{
        id: generateRow
        anchors{
            top: row.bottom
        }
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 25

        Button{
            id: buttonGenerate
            width: 150
            text: qsTr("生成合约靓号")
            Material.background: Material.Orange
            Material.foreground: Material.color(Material.BlueGrey)
            onClicked: {
                backend.generateContract(input.text, radio1.checked, radio2.checked)
            }
            // onClicked: console.log("clicked:")
        }
    }



    Row {
        id: privateKeyRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: generateRow.bottom
        anchors.topMargin: 20

        Label {
            id: privateKeyLable
            text: "Private key: "
            anchors.top: parent.bottom
        }
        Label {
            id: privateKey
            text: ""
            anchors.top: parent.bottom
        }
    }

    Row {
        id: addressRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: privateKeyRow.bottom
        anchors.topMargin: 20

        Label {
            id: addressLabel
            text: "address: "
            anchors.top: parent.bottom
        }
        Label {
            id: address
            text: ""
            anchors.top: parent.bottom
        }
    }

    Row {
        id: contractAddressRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: addressRow.bottom
        anchors.topMargin: 20

        Label {
            id: contractAddressLable
            text: "Contract Address: "
            anchors.top: parent.bottom
        }
        Label {
            id: contractAddress
            text: ""
            anchors.top: parent.bottom
        }
    }


    Row {
        id: copyRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: contractAddressRow.bottom
        anchors.topMargin: 20
        spacing: 25
        Button{
            id: copyPrivateKey
            width: 100
            text: qsTr("复制私钥")
            Material.foreground: Material.color(Material.BlueGrey)
            Material.background: Material.Orange
            onClicked: {
                backend.copyToClipboard('privateKey')
                toast.show("复制成功")
            }
        }

        Button{
            id: copyPublicKey
            width: 100
            text: qsTr("复制账户地址")
            Material.foreground: Material.color(Material.BlueGrey)
            Material.background: Material.Orange
            onClicked: {
                backend.copyToClipboard('address')
                toast.show("复制成功")
            }
        }


        Button{
            id: copyAddress
            width: 100
            text: qsTr("复制合约地址")
            Material.background: Material.Orange
            Material.foreground: Material.color(Material.BlueGrey)
            onClicked: {
                backend.copyToClipboard('contractAddress')
                toast.show("复制成功")
            }
        }
    }



    Connections {
        target: backend

        function onSignalPrivateKey(myPrivateKey){
            privateKey.text = myPrivateKey
        }
        function onSignalAddress(myAddress){
            address.text = myAddress
        }
        function onSignalContractAddress(myContractAddress){
            contractAddress.text = myContractAddress
        }
        function onSignalStart(flag) {
            if(flag == true) {
                buttonGenerate.enabled=false;
                buttonGenerate.text = "生成中...."
            }
            else {
                buttonGenerate.enabled=true;
                buttonGenerate.text = "生成合约靓号"
            }
        }
    }
}
