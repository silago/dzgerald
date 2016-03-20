#ifndef COMMONCLASS_H
#define COMMONCLASS_H

#include <QObject>
#include <QDebug>
#include <QtSql>
#include <QFileInfo>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QtWidgets/QMessageBox>




class CommonClass : public QObject
{
    Q_OBJECT
public:
    QSqlDatabase db;
    QObject *qml_object;
    QString card_id;
    explicit CommonClass(QObject *parent = 0);
    void append_qml(QObject *qml_object);
    void log(const QString &msg);
    void connectToBd();
    void showMessage(QString);
    float cardDiscount(QString);
    void userNotFound();
    void showSearchWindow();
    void listUsers(int offset);
    void getPayments();
signals:

public slots:
    void addUser(QString,QString,QString,QString);
    void searchByCardId(QString);
    void addPayment(QString);
    void cppSlot(const QString &msg) {
        qDebug() << "Called the C++ slot with message:" << msg;
    }
};

#endif // COMMONCLASS_H
