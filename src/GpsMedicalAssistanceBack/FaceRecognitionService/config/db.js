const mongoose = require('mongoose');

const MONGODB_URI =
  process.env.MONGODB_URI || 'mongodb://127.0.0.1/gps-medical-assistance';

module.exports = () => {
  const connect = () => {
    mongoose
      .connect(MONGODB_URI)
      .then(() => {
        console.log('DB connected and server us running.');
      })
      .catch((err) => {
        console.log(err);
      });
  };

  // Retry the initial connection so the face service can start before MongoDB is ready.
  connect();
  mongoose.connection.on('disconnected', () => {
    setTimeout(connect, 5000);
  });
};
