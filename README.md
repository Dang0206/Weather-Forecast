# 🌦 Weather Forecast Web App


A Flutter Web Application that provides real-time weather information using WeatherAPI
.
Users can search for cities/countries, view current weather conditions, 4-day forecasts, and manage their daily forecast email subscriptions.

Deployed with Firebase Hosting.

🚀 Features:

Search weather by city/country

Display current day weather: temperature, wind speed, humidity, condition, etc.

Show 4-day weather forecast and option to load more.

Temporary weather history stored for the day (can re-display after reloading app).

Register email to receive daily forecast.

Email confirmation required.

Ability to unsubscribe.

Deployment on Firebase Hosting.

🛠️ Technical Stack

Frontend: Flutter (Dart)

API Provider: WeatherAPI

State Management: Provider

Temporary weather history is stored locally using SharedPreferences.

Authentication/Subscription: Firebase Authentication 

Deployment: Firebase Hosting

# You can run project step by step: 

1.Install dependencies

flutter pub get


2.Run on web (Chrome)

flutter run -d chrome


3.Build web for deployment

flutter build web


4.Deploy to Firebase Hosting (if Firebase is already configured)

firebase deploy
# My video demo: 
https://youtu.be/jAX9ChUINTE
