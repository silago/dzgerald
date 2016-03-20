TEMPLATE = app

QT += qml quick sql widgets gui
CONFIG += c++11

SOURCES += main.cpp \
    commonclass.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    commonclass.h

DISTFILES += \
    main.db
