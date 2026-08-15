import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from controller import AppController

def main():
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()

    qml_file = Path(__file__).parent / "Main.qml"

    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
