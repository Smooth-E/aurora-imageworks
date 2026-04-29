TARGET = moe.smoothie.imageworks

CONFIG += auroraapp

SOURCES += src/moe.smoothie.imageworks.cpp \

DISTFILES += \
    qml/moe.smoothie.imageworks.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ChannelBench.qml \
    qml/pages/CollageBench.qml \
    qml/pages/ColorcurveBench.qml \
    qml/pages/EffectsBench.qml \
    qml/pages/FilterBench.qml \
    qml/pages/FirstPage.qml \
    qml/pages/InfoPage.qml \
    qml/pages/MetadataPage.qml \
    qml/pages/NewPage.qml \
    qml/pages/PixelBench.qml \
    qml/pages/RenamePage.qml \
    qml/pages/SavePage.qml \
    qml/pages/ViewPage.qml \
    qml/pages/perspectivetransformhelper.js \
    rpm/moe.smoothie.imageworks.spec \
    translations/*.ts \
    moe.smoothie.imageworks.desktop \
    rpm/moe.smoothie.imageworks.changes

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += auroraapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/moe.smoothie.imageworks-*.ts

HEADERS +=

libdir = /usr/share/$$TARGET/lib
libexecdir = /usr/libexec/$$TARGET
cpython_version = "3.8"

message(Building for architecture $$QT_ARCH)
equals(QT_ARCH, arm64) {
    vendor = vendor/aarch64
    lib_subdir = lib64
}
# qmake in Aurora Platform SDK armv7hl prefix reports QT_ARCH as just arm...
equals(QT_ARCH, arm) {
    # But cmake, which we use for building cpython, reports it as armv7l
    vendor = vendor/armv7l
    lib_subdir = lib
}
message(Selected vendor dir $$vendor)

vendored_bin.path = $$libexecdir
vendored_bin.files = $$vendor/bin/python3 \
                     $$vendor/bin/python$$cpython_version \

vendored_lib.path = $$libdir
vendored_lib.files = $$vendor/lib/python$$cpython_version \
                     $$vendor/lib/*.so*

pyotherside.path = $$libdir/
pyotherside.files = $$vendor/usr/$$lib_subdir/qt5

INSTALLS += vendored_bin vendored_lib pyotherside
