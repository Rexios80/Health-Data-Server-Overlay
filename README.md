# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch running the [Health Data Server app](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8).

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/PreviewImage.gif)

[Video of the overlay in action](https://www.youtube.com/watch?v=CFGlA7JWUFo)

### How to set up
1. [Download the latest release executable](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)
2. Double click the downloaded file to run it
    - On macOS, you will first need to run `chmod 777 HDS-Overlay-macos` in a terminal
    - On linux, you will first need to run `chmod 777 HDS-Overlay-linux` in a terminal
3. Windows will give you some prompts that you have to deal with
    - For the Winows Smartscreen prompt, click on "More info" and then "Run anyway"
    - For the Windows Firewall prompt, make sure to check both the boxes and then click "Allow access"
        - ![Firewall Dialog](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/firewall-dialog.png)
        - If this dialog does not show up, try moving the executable to your desktop and opening it from there
        - You will have to do this for new overlay versions as well
4. MacOS will not let you open the overlay the first time. After you try to open the overlay, go to `System Preferences > Security & Privacy > General` and click on "Open Anyway"
    - ![macOS Security Page](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/macos-security-page.png)
5. Open a browser and go to `localhost:8080`

You should see the overlay, but no numbers yet since the watch hasn't sent any.

### Connecting to the Apple Watch application
1. Make sure the Apple Watch and device running the overlay application are on the same network. If the watch is connected to an iPhone, you just need to make sure the iPhone is connected to the same network.
2. [Install the Health Data Server application on your Apple Watch](https://apps.apple.com/us/app/health-data-server/id1496042074)
   - THE APP REQUIRES WATCHOS 6+. The App Store will let you purchase it even if your watch can't run watchOS 6+, so make sure before buying.
   - You will need to use the [App Store ON the Apple Watch](https://support.apple.com/guide/watch/get-more-apps-apd99e3c6a68/watchos) to install the app. You can thank Apple for that.
3. Open the application
4. Type the IP address of the machine running the overlay application
   - The overlay application will list possible IP addresses of your machine on startup. If none of those work, you may have to find the IP address manually.
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: `192.168.xxx.xxx`
   - There is an input method in watchOS 6 that allows you to type in text fields from your iPhone. This is by far the easiest way to input the information into the watch application.
   - If you want to send data to an external server, you will need to input the full websocket URL ex: `ws://hostname:port/other/stuff`
5. Click the start button

You should soon see numbers in the webpage you opened earlier. This is the health data the watch is sending over your local network.

### Configuration
If you need to change either of the ports or want to change the images the application uses, you will need to create a config file. Create a file named `config.json` in the same folder as the application:
```
{
    "httpPort": 8080,
    "websocketPort": 3476,
    "websocketIp": "localhost",
    "hrImageFile": "hrImage.png",
    "calImageFile": "calImage.png",
    "animateHeartRateImage": "false",
    "discordRichPresenceEnabled": "false"
}
```
You only need to speficy the config options that you want to change. Make sure to not leave a trailing comma or the application will crash. If you change the websocketPort, you will have to append it to the IP address in the watch app ex: `192.168.xxx.xxx:3476`. Images need to be in the same folder as the application.

### Styling
If you need complex styling of the overlay, you can use the Custom CSS field on an OBS browser source. Use [styles.css](public/styles.css) as a reference of what can be changed.

[Some Custom CSS examples can be found in the wiki](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Custom-CSS-Examples)

### Notes
If you want to use this as a stream overlay, simply add the url used to see the data in a web browser as a browser source in your favorite streaming application.

If you are using an IP address instead of "localhost" in OBS, then you will have to include "http://" before it or it won't work: `http://192.168.xxx.xxx:8080`

### If you have problems
Try these [troubleshooting steps](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting) before asking for help
- Ask for help in the [support Discord server](https://discord.gg/FayYYcm)
- [Create an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/issues/new?assignees=&labels=&template=bug-report.md&title=)

### Please consider writing a review
Many people only leave reviews when they have a problem with an app. Even if many users don't have an issue, these negative reviews can turn off potential new users. If you enjoy this application, please consider leaving a review on the [App Store page](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8). Even a simple review helps a lot!

### Building it yourself
Most users won't need to do this, but here is how to build the application manually.

#### Prerequisites
   - [Node.js](https://nodejs.org/)
   - [Git](https://git-scm.com/)
   - [pkg](https://github.com/vercel/pkg)

#### Commands
   - `npm install`
   - `./buildscript.sh`
   - The generated files will be in the `output` folder
