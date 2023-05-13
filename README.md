# IMessage
This application consists of nine full screens for searching and communicating with people, and the Firebase as a Backend-as-a-service solution for this project. The user can log in the application either through email and password or via Google, create their own profile. After successful authorization, he can search for people, add them as friends, chat with them, send them photos.
## Technology Stack
* UICollectionView Compositional Layout and UICollectionView Diffable DataSource
* AutoLayout programmatically using NSLayoutAnchor and StackViews
* Architecture: MVC
* CocoaPods
* Firebase:
  * FirebaseAuth (Email/Google Authentication)
  * Firestore (for storing user's info and data about active and waiting chats)    
  * Storage (to store users' avatars and pictures sent in chats) 
* MessageKit + InputBarAccessoryView (for real-time chat with images and text messages)
* SDWebImage 5.0 (for asynchronous image loading and caching)

## Description and overview
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/8b9ff43d-2432-4bec-ba3d-214e654d97eb" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/9d49d26f-cf30-42a9-bf66-3f5d7ffff756" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/1fcecad2-0f49-4ffc-8166-bdeb824054a5" width="200">
