const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const POINTS = {
  'phone': 10,
  'laptop': 15,
  'charger': 5,
  'battery': 8,
  'tablet': 12,
  'earphones': 6,
  'headphones': 6,
  'usb': 4,
  'flash drive': 4,
  'power bank': 7,
  'mouse': 5,
  'keyboard': 5,
};

exports.onDropOffConfirmed = functions.firestore
  .document('dropOffs/{dropOffId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before.status !== 'confirmed' && after.status === 'confirmed') {
      const userRef = admin.firestore().collection('users').doc(after.userId);
      const userSnap = await userRef.get();
      if (!userSnap.exists) return null;
      const user = userSnap.data();
      const points = after.pointsEarned || POINTS[(after.itemName || '').toLowerCase()] || 5;
      const newTotal = (user.totalPoints || 0) + points;
      await userRef.update({ totalPoints: newTotal });
      // Badge logic (example: 100 points = "Recycler Lv1")
      const badges = user.badges || [];
      if (newTotal >= 100 && !badges.includes('Recycler Lv1')) {
        badges.push('Recycler Lv1');
      }
      if (newTotal >= 250 && !badges.includes('Recycler Lv2')) {
        badges.push('Recycler Lv2');
      }
      if (newTotal >= 500 && !badges.includes('Recycler Lv3')) {
        badges.push('Recycler Lv3');
      }
      await userRef.update({ badges });
      // Secret reward for top 1
      const topUsers = await admin.firestore().collection('users').orderBy('totalPoints', 'desc').limit(1).get();
      if (!topUsers.empty && topUsers.docs[0].id === after.userId) {
        await userRef.update({ secretReward: true, rewardClaimedAt: admin.firestore.FieldValue.serverTimestamp() });
      }
    }
    return null;
  });

// Challenge completion logic can be added similarly
