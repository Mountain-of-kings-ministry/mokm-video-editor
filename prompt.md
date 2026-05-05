the code base for the software is in ./code you will find it and all it cmake files.

if you read ​README.md​  you will see am working on a professional level video editor for low end devices, and android devices tooo, all versions of android so projects can be transfareable.

what i need you to work on is the ​MediaBinPage.qml​ 
so that it can stop using demo data and start reading from file, and make sure any file selected have a preview of file on the right side like a splitview so befor importing to the time line in video editor you know what you are importing, ​EditorPage.qml​ .

when you right click any media file it shoul show context menu and ask preview or import to track, if import to track then it should list all existing track and still add this to the top of list add to new track.

if you pay attension to the theme color ​Theme.qml​  and the ​Sidebar.qml​  you will see how the buttons got colored for their images, i need you to make sure every icons are colored. as forground then other colors can follow as defined in theme.

when you read the  ​providers​ 

​functions​  you will understand the project structure better, so you can add providers and funtions where they belong.

and make sure to link the vcpkg ​vcpkg-configuration.json​ ​vcpkg.json​  and install needed packages to make the system i described above work properly with no errors.