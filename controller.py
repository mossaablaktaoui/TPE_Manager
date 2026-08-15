from PySide6.QtCore import QObject, Signal, Slot
from PySide6.QtQml import QmlElement, QmlSingleton


QML_IMPORT_NAME = "App.Backend"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
@QmlSingleton
class AppController(QObject):

    operationSaved = Signal(str)
    errorOccurred = Signal(str)

    @Slot(float)
    def createOperation(self, amount):
        print(f"Creating operation: {amount}")

        # Database / service logic here...

        self.operationSaved.emit(
            f"Operation saved: {amount:.2f}"
        )