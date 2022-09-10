import QtQuick 6
import QtQuick.Window 2.15
import QtQuick.Controls 6
import QtQuick.Controls.Material 2.15

ApplicationWindow{
    id: window
    width: 400
    height: 580
    visible: true
    title: qsTr("合约靓号")

    // SET FLAGS
    flags: Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint | Qt.CustomizeWindowHint | Qt.MSWindowsFixedSizeDialogHint | Qt.WindowTitleHint

    // SET MATERIAL STYLE
    Material.theme: Material.Dark
    Material.accent: Material.Orange


    // CREATE TOP BAR
    Rectangle{
        id: topBar
        height: 40
        color: Material.color(Material.Orange)
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
        }
        radius: 20



      Rectangle {
          color: Material.color(Material.Orange)
          height: topBar.radius
          anchors{
              left: parent.left
              right: parent.right
              top: parent.top
          }
      }
      
      Text{
          text: qsTr("合约靓号")
          anchors.verticalCenter: parent.verticalCenter
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: "#ffffff"
          anchors.horizontalCenter: parent.horizontalCenter
          font.pointSize: 10
      }
    }




    // IMAGE IMPORT
    Image{
        id: image
        width: 200
        height: 200
        source: "../images/logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topBar.bottom
        anchors.topMargin: 60
    }

    // TEXT FIELD USERNAME
/*    TextField{
        id: usernameField
        width: 300
        text: qsTr("")
        selectByMouse: true
        placeholderText: qsTr("直接点击登录即可！")
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: image.bottom
        anchors.topMargin: 60
    }*/


    // BUTTON LOGIN
    Button{
        id: buttonLogin
        width: 300
        text: qsTr("点击进入")
        anchors.top: image.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: backend.checkLogin("")
    }


    Connections {
        target: backend

        // CUSTOM PROPERTIES
        property string username: ""
        // property string password: ""
        function onSignalUser(myUser){ username = myUser }
        // function onSignalPass(myPass){ password = myPass }

        // FUNTION OPEN NEW WINDOW (APP WINDOW)
        function onSignalLogin(boolValue) {
            if(boolValue){
                var component = Qt.createComponent("app.qml")
                var win = component.createObject()
                win.textUsername = username
                win.show()
                visible = false
            } else{
                usernameField.Material.foreground = Material.Pink
                usernameField.Material.accent = Material.Pink
            }
        }
    }
}