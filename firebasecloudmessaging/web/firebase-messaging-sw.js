importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBN0Ueq3pvzOqM6It4jYTlgRAaaOhNNCRk",
  authDomain: "fir-cloud-messaging-91374.firebaseapp.com",
  projectId: "fir-cloud-messaging-91374",
  storageBucket: "fir-cloud-messaging-91374.firebasestorage.app",
  messagingSenderId: "824599449446",
  appId: "1:824599449446:web:a03c9c9794f2e981af82a7"
});

// Retrieve messaging instance
const messaging = firebase.messaging();

// Handle background notifications
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Recibido mensaje en background:', payload);

  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png' // Asegúrate de tener este icono
  });
});
