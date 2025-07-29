const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

admin.initializeApp();

exports.sendChatNotification = onDocumentCreated("messages/{messageId}", async (event) => {
  logger.info("Function triggered by new message creation.");

  const snapshot = event.data;

  if (!snapshot) {
    logger.warn("No data associated with the event, exiting function.");
    return;
  }

  const newMessage = snapshot.data();
  const senderId = newMessage.senderID;

  if (!senderId) {
    logger.error("Message is missing senderID, exiting.");
    return;
  }

  let senderName = "Unknown";

  try {
    const senderDoc = await admin.firestore().collection("users").doc(senderId).get();
    
    if (senderDoc.exists) {
      senderName = senderDoc.data().name;
    } else {
      logger.warn(`Sender with ID ${senderId} not found in users collection.`);
    }
  } catch (error) {
    logger.error("Failed to retrieve sender document:", error);
  }

  logger.info(`Message is from ${senderName} (ID: ${senderId})`);

  const usersSnapshot = await admin.firestore().collection("users").get();
  const tokens = [];

  usersSnapshot.forEach((userDoc) => {
    const user = userDoc.data();

    if (userDoc.id !== senderId && user.fcmToken != null) {
      tokens.push(user.fcmToken);
    }
  });

  if (tokens.length === 0) {
    logger.info("No other users with FCM tokens found to notify.");
    return;
  }

  logger.info(`Preparing to send notification to ${tokens.length} tokens.`);

  const payload = {
    notification: {
      title: `New message from ${senderName}`,
      body: newMessage.messageContent,
    },
    data: {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "screen": "/chatroom",
    },
    tokens: tokens,
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(payload);

    if (response.failureCount > 0) {
      response.responses.forEach((response, index) => {
        if (!response.success) {
          const failedToken = tokens[index];
          logger.error(`Failed to send to token: ${failedToken}`, response.error);
        }
      });
      logger.error("Error sending notifications:", error);
    } 
    else 
    {
        logger.info("Notifications sent successfully.", {response});
    }

  } catch (error) {
    logger.error("Error sending notifications:", error);
  }
});

    