
# 📰 News Express

A modern, responsive news application built with Flutter that delivers real-time top headlines across multiple categories. 





https://github.com/user-attachments/assets/d03102d2-5595-4672-85b6-f02a1bcff8b3











## ✨ Features

* **Global Search:** Find specific stories instantly by typing keywords to search through millions of articles.
* **Real-Time Data:** Fetches live news articles using the [NewsAPI](https://newsapi.org/).
* **Dynamic Categories:** Seamlessly switch between General, Technology, Sports, Business, and more.
* **Responsive UI:** Built with custom slivers (`CustomScrollView`, `SliverAppBar`) for a fluid, native-feeling scrolling experience.
* **Scalable UI Design:** Utilizes `flutter_screenutil` and `MediaQuery` to ensure pixel-perfect typography and spacing across varying screen densities
* **Dark / Light Modes:** Personalized viewing experience with easy toggling between themes. . 
* **Local Storage:** Remembers user preferences (like Theme mode) across sessions using persistent storage.
* **Robust Error Handling:** Safely handles broken image links, missing data, and loading states without crashing.
* **External Article Access:** Integrated `url_launcher` allowing users to jump from the app summary to the full source article in their native browser


## 🛠 Tech Stack & Tools
* **Framework:** Flutter / Dart
* **State Management:** BLoC / Cubit (`flutter_bloc`)
* **Networking:** `dio`
* **Packages:** `shimmer`,`Shared_prefrence`,`url_launcher`,`flutter_screenutil`
* **Architecture:** Feature-Driven Development (FDD)


## 🏗 Architecture 
This project is structured using a **Feature-First Architecture** combined with a clean separation of concerns. 

Instead of grouping files by their type (all models together, all screens together), files are grouped by the feature they belong to (e.g., `features/homescreen/`). Inside each feature, the logic is strictly separated into:
1. **Presentation Layer:** Stateless UI widgets and dynamic routing.
2. **Business Logic Layer:** Cubits handling state emission and API communication.
3. **Data Layer:** Repositories and Web Services managing data fetching and parsing.




## 🚀 Getting Started

To run this project locally, you will need a free API key from NewsAPI.

1. Clone the repository
2. Get a free API key at https://newsapi.org/
3. Open the project and navigate to the webservices.dart 
4. Insert your API key
5. flutter pub get
6. Run the app
