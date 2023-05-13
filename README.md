# IMessage
This application consists of nine full screens for searching and communicating with people, and the Firebase as a Backend-as-a-service solution for this project. The user can log in the application either through email and password or via Google, create their own profile. After successful authorization, he can search for people, add them as friends, chat with them, send them photos.

## Usage
For a simple test of my app you can use the login and password below in Sign up screen:  
Login: ***a@mail.ru***  
Password: ***123456***

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
Auth and profile setup viewControllers:  
At the auth stage, the app can show several types of errors to the user through alert.  
All fields must be filled in and the avatar picture uploaded for successful authorization

<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/8b9ff43d-2432-4bec-ba3d-214e654d97eb" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/9d49d26f-cf30-42a9-bf66-3f5d7ffff756" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/1fcecad2-0f49-4ffc-8166-bdeb824054a5" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/d25fd977-098b-407f-9343-4109c9c47eb4" width="200">  

------
Main viewControllers:  
ListenerRegistration is used for observing users and chats and getting actual data from the server.  
SearchBar is used for searching people by the input text.  
CAGradientLayer is used for custom buttons.    

<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/65d747cc-ac0f-4fba-952a-912c614f94e1" width="200">  
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/4a42cf60-6cae-4d52-a772-ff406c393cfc" width="200">  

---------
Extra viewControllers and real-time chat:  

<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/e3851c35-9dad-4ab3-aaf5-1ad20172ed57" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/7a8e5591-e76f-4408-a641-5c5efc40ef0c" width="200">
<img src= "https://github.com/VorkhlikArtem/IMessage/assets/115653999/59c13a43-f23f-4ff0-8d90-e92fe489c569" width="200">


