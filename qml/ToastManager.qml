
//ToastManager.qml
import QtQuick 6
 
Column{
 
    function show(text, duration) {
        var toast = toastComponent.createObject(toastManager);
        toast.selfDestroying = true;
        toast.show(text, duration);
    }

    function destory() {
      var toast = toastComponent.createObject(toastManager);
      toast.destory()
    }
 
    id: toastManager
 
    z: Infinity
    spacing: 5
    anchors.centerIn: parent
 
    property var toastComponent
 
    Component.onCompleted: toastComponent = Qt.createComponent("Toast.qml")
}