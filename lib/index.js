const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendOrderNotification = functions.firestore
    .document('orders/{orderId}')
    .onCreate((snap, context) => {
        const newOrder = snap.data();
        const payload = {
            notification: {
                title: 'Order Placed Successfully',
                body: `Your order for ${newOrder.item} has been placed successfully.`,
                sound: 'default'
            }
        };

        return admin.messaging().sendToDevice(newOrder.userToken, payload)
            .then(response => {
                console.log('Successfully sent message:', response);
            })
            .catch(error => {
                console.log('Error sending message:', error);
            });
    });