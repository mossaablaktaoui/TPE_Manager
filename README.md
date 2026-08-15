# TPE Manager QML project

This version uses the Qt Design Studio designer/developer split:

- `MainForm.ui.qml`: presentation only. No signal handlers, functions, JavaScript blocks, timers, or business logic.
- `Main.qml`: window, mock data, signal handlers, selection/edit/create/delete logic, and date actions.
- `Components/`: reusable visual controls.

## Open in Qt Design Studio

Open `TPEManager.qmlproject`.

- Run/preview the application from `Main.qml`.
- Open `MainForm.ui.qml` in Design mode / 2D view to edit the interface visually.

`MainForm.ui.qml` deliberately exports controls through `property alias` declarations. `Main.qml` uses those aliases to attach behavior without putting signal handlers in the `.ui.qml` file.

## Why the UI file is named MainForm.ui.qml

Qt treats `Main.qml` and `Main.ui.qml` as QML documents that would both represent a `Main` component. The standard Qt Design Studio pattern is therefore a distinct visual component name such as `MainForm.ui.qml`, instantiated by `Main.qml`.

## Build with Qt Creator / CMake

The project targets Qt 6.5+ and uses Qt Quick and Qt Quick Controls 2.
