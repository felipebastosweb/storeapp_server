# storeapp_dlang
StoreApp written in D with access to the MongoDB database (Community)

This work aims to build a binary application for managing commercial stores (or small artisanal factories), which can run 32 and 64 bit computers with high performance, with the database, for hardware support reasons, must be on a 64-bit computer. It was observed in a previous analysis that most programming languages no longer support 32-bit computers, which does not happen with the D language, which is still compatible with this type of hardware. It was also observed that programming languages such as Ruby, which presents good performance in the development of the system by the team, presents a poor performance when running the system on 64-bit computers, thus making the computational cost very high. Therefore, the D programming language was chosen because it is a language with modern resources, is object-oriented, and presents excellent execution-time performance on both 32- and 64-bit hardware (i386 and amd64). This proved to be a very important factor in taking advantage of the computing power of devices such as netbooks and older computers in small stores. Or we were even allowed to think about using computing resources in poor countries through computer scraps. In this way, the social nature of this project is also made clear, which aims to cover the technological inclusion of all countries, especially the poorest or most needy populations.

# How to install
To install from source code, simply download this project (git clone), or download and extract it from the zip file, and when opening the console or shell in the project folder, run the dub --build command, if you just want compile or the dub command to compile and run. If you just want to download the binary file (storeapp.exe) just download the file in the releases section located on the right of this page --->>.

To update the project, simply download the storeapp.exe binary file in the releases section or download the project source code and do as already indicated to recompile.

storeapp
storeapp/dub.json
storeapp/public
storeapp/public/js
storeapp/public/css (bootstrap and bootstrap icons files)
storeapp/public/css/fonts (bootstrap icons files)
storeapp/source
storeapp/source/apis
storeapp/source/controllers
storeapp/source/models
storeapp/views

# Rotate
Run the dub command in the storeapp folder which will compile and run the .exe. Then, just run the .exe. If you don't want to compile again, just open the executable in your preferred shell or console (Command Prompt, Power Shell, etc.) using the command: .\storeapp.exe.

Open the http://localhost:8080 page in your browser.

# What already works
Here are some of the screens that are already working (it remains to print the other CRUD screens for these resources).

## Main screen
The main screen has the main system features
![Main screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/home.png)

## User List Screen
The user list screen displays users registered in the system
![User List Screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/users_index.png)

## Brand List Screen
This screen lists the product brands registered in the system
![Brand List Screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/brands_index.png)

## Supplier List Screen
The user list screen displays the suppliers registered in the system. The list of suppliers aims to help the retailer identify purchases of products for resale or production inputs.
![Supplier List Screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/suppliers_index.png)

## Product List Screen

![Supplier List Screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/products_index.png)

## Shopping List Screen

![Supplier List Screen](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/purchases_index.png)

# What will be produced soon
These are the next features to be developed in the system:
   - User Authentication and Permission
   - Addition of Items to the Purchase made
   - Purchase Payment Registration (payment method, payment date, card installment dates)
   - Purchase cancellation
   - Customer base
   - Customer Registration Growth Chart on the Home Screen
   - Order Registration
   - Order Growth Chart on the Home Screen
   - Adding Items to the Order placed by the Customer
   - Order Cancellation
   - Registration of Payments made to the Order
   - Registration of Accounts Payable
   - Registration of Accounts Receivable
