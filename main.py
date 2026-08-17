import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from ui.main_window.model import MainWindowModel


def main():
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("TPEManager")
    app.setOrganizationDomain("local.tpemanager")
    app.setApplicationName("TPE Manager")
    engine = QQmlApplicationEngine()
    qml_file = Path(__file__).parent / "ui/main_window/Main.qml"
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        raise RuntimeError(f"Failed to load QML root object: {qml_file}")

    root = engine.rootObjects()[0]
    model = MainWindowModel(root)
    root.setProperty("model", model)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
