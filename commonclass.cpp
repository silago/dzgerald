#include "commonclass.h"


void CommonClass::log(const QString &msg) {
    qDebug() << msg;
}

void CommonClass::connectToBd()
{
    this->db = QSqlDatabase::addDatabase("QSQLITE");

    QString pathToDB = QDir::currentPath()+QString("/main.db");
    this->db.setDatabaseName(pathToDB);

    QFileInfo checkFile(pathToDB);

    if (checkFile.isFile()) {
        if (this->db.open()) {
            this->log("[+] Connected to Database File");
        }
        else {
            this->log("[!] Database File was not opened");
        }
    }
    else {
        this->log("[!] Database File does not exist");
    }
}

void CommonClass::append_qml(QObject *qml_object) {
    this->qml_object = qml_object;
}

CommonClass::CommonClass(QObject *parent) : QObject(parent)
{
    this->connectToBd();
}

void CommonClass::userNotFound() {


}

float CommonClass::cardDiscount(QString summ) {
    float s = summ.toFloat();
    if (s < 1000) {
        return 0.0;
    }
    if (s <= 2000) {
        return 0.03;
    }
    if (s <= 5000) {
        return 0.05;
    }
    if (s <= 7000) {
        return 0.10;
    }
    if (s <= 3000) {
        return 0.15;
    }
    if (s > 3000 ) {
        return 0.20;
    }
    return 0.0;
 }

void CommonClass::searchByCardId(QString card_id )
{
    QSqlQuery query;
    QString view_title;




    if (query.exec("SELECT id, name, phone, email, summ FROM customers WHERE card_id=\'" + card_id + "\' "))
    {
       if (query.next()) {
           this->card_id  = card_id;
           //this->log("user found");
           double discount = this->cardDiscount(query.value(4).toString());
           view_title = query.value(0).toString()
                   + " " + query.value(1).toString()
                   + " " + query.value(2).toString()
                   + " " + query.value(3).toString()
                   + " " + QString::number( discount );

           //this->showMessage((query.value(4).toString()));

           //this->showMessage(QString::number(discount));
           this->qml_object->findChild<QObject*>("iSumm")->setProperty("discount",discount);
           this->qml_object->findChild<QObject*>("search_view")->setProperty("visible",false);
           this->qml_object->findChild<QObject*>("user_info_view")->setProperty("visible",true);
           this->qml_object->findChild<QObject*>("showSearchWindow")->setProperty("visible",true);
           this->qml_object->findChild<QObject*>("user_info_caption")->setProperty("text",view_title);
           this->qml_object->findChild<QObject*>("add_payment_button")->setProperty("card_id",card_id);
           this->log(view_title);
           this->getPayments();
       }
       else {
           this->log("user not found");
           this->showMessage("Пользователь с такой картой не найден");
           this->userNotFound();
       }
    }

    // search in bd
    // set #user_info title
    // show view
}




void CommonClass::getPayments() {
    QSqlQuery query;
    QString card_id;
    QString title;
    card_id = this->card_id;
    //           this->qml_object->findChild<QObject*>("search_view")->setProperty("visible",false);
    QObject *list = this->qml_object->findChild<QObject*>("paymentsList");
    list->setProperty("lines",QString::number(0));


    int l = qvariant_cast<int>(list->property("lines"));
    //user_info_view_rectangle
    if (query.exec("SELECT * FROM orders WHERE card_id=\'" + card_id + "\' limit 3"))
    {
       while (query.next()) {
          ++l;
          list->setProperty("lines",QString::number(l));
          QObject *line = this->qml_object->findChild<QObject*>("paymentLine"+QString::number(l));
          if (line) {
                  title =  " " + query.value(2).toString() + " Руб. ";
                  line->setProperty("text",title);
                  this->log("found paymentLine"+QString::number(l));
          } else {
            this->log("could not find paymentLine"+QString::number(l));
          }
       }
    }
}

void CommonClass::showMessage(QString text) {
    QMessageBox msgBox;
    msgBox.setText(text);
    msgBox.exec();

}

void CommonClass::addUser(QString card_id, QString phone, QString email, QString name ) {
    QSqlQuery query;
    //this->db.open();
    if (query.exec("insert into customers  (card_id, phone, email, name) values ('"+card_id+"', '"+phone+"','"+email+"','"+name+"' ) "))
    {
           this->log("user created");
           this->showMessage("Пользователь успешно добавлен");

    } else {
        this->log(query.lastError().text());
        this->showMessage("Невозможно добавить пользователя: "+query.lastError().text());
    }
}

void CommonClass::addPayment(QString summ) {
    QSqlQuery query;
    //this->db.open();
    this->log("insert into orders  (card_id, summ) values ('"+this->card_id+"', "+summ+" ) ");
    if (query.exec("insert into orders  (card_id, summ) values ('"+this->card_id+"', "+summ+" ) "))
    {
            query.exec("update customers set summ = summ + " + summ );
           this->log("payment done");
    } else {
        this->log(query.lastError().text());
        this->showMessage("Ошибка при обновлении платежей: "+query.lastError().text());
    }
}



void CommonClass::showSearchWindow() {
    //show view
    return;
    this->qml_object->findChild<QObject*>("search_view")->setProperty("visible",true);
    this->qml_object->findChild<QObject*>("user_info_view")->setProperty("visible",false);
    this->qml_object->findChild<QObject*>("newUserItem")->setProperty("visible",false);
    this->qml_object->findChild<QObject*>("user_list_view")->setProperty("visible",false);

}

void CommonClass::listUsers(int offset = 0) {
    // get users with offset
    // update view data
    // show view
}
