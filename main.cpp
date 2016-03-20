#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QtSql>
#include "commonclass.h"
/* definition
 * main window:
 *
 *          [ search by card name ]  <search>
 *                       <show all> <add new>
 *
 * card window:
 *
 *
 *         [ card_id ] 12312 123123123
 *         [ email   ] fooo@bar.ru
 *         [ name    ] Jane Doe
 *         [ summ    ] 20123 rub
 *         [ discount] 5%
 *         < append new >
 *
 */





int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;    
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject *rootObject = engine.rootObjects().first();
    QObject *searchButtonArea = rootObject->findChild<QObject*>("searchButtonArea");
    QObject *add_payment_button = rootObject->findChild<QObject*>("add_payment_button");
    QObject *new_user_button = rootObject->findChild<QObject*>("newUserButton");

    CommonClass myClass;
    myClass.append_qml(rootObject);
    //QObject::connect(item,SIGNAL(qmlSignal(QString)),&myClass,SLOT(cppSlot(QString)));
    QObject::connect(searchButtonArea,SIGNAL(qmlSignal(QString)),&myClass,SLOT(searchByCardId(QString)));
    QObject::connect(add_payment_button,SIGNAL(addPayment(QString)),&myClass,SLOT(addPayment(QString)));
    //newUserButton
    QObject::connect(new_user_button,SIGNAL(addUser(QString,QString,QString,QString)),&myClass,SLOT(addUser(QString,QString,QString,QString)));
    //showSearchWindow
    //QObject::connect(showSearchWindow,SIGNAL(addUser()),&myClass,SLOT(showSearchWindow()));
    return app.exec();
}
