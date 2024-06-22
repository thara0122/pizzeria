const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendOrderStatusNotification = functions.firestore
  .document('orders/{orderId}')
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.status !== previousValue.status) {
      const userId = newValue.userId;
      const status = newValue.status;
      
      const message = {
        notification: {
          title: 'Pizzeria Order Status',
          body: `Your order status is now ${status}`
        },
        topic: 'order_status_' + userId
      };

      return admin.messaging().send(message)
        .then((response) => {
          console.log('Successfully sent message:', response);
          return null;
        })
        .catch((error) => {
          console.error('Error sending message:', error);
          return null;
        });
    } else {
      return null;
    }
  });
