# SwiftUI
<h1> SwiftUI Kaamera ning foto salvestus

<h2> Camera Model

- AVFoundation
  >AVFoundation on iOS-i, macOS-i, watchOS-i ja tvOS-i ajapõhise audiovisuaalse meediumiga töötamise raamistik. AVFoundationi abil saate hõlpsalt mängida, luua ja redigeerida QuickTime-filme ja MPEG-4-faile, mängida HLS-voogusid ja luua rakendustes võimsaid meediumifunktsioone.


- NSObject
  >NSObject'i kaudu pärivad objektid käitusaja süsteemi põhiliidese ja võime käituda Objective-C objektidena.
  
- AVPhotoCaptureDelegate
  >Meetodid progressi jälgimiseks ja fotode jäädvustamise tulemuste saamiseks.

<h3> Funktsioonid

- checkAuthorization - proovib ligipääsu videoks saada, et oleks võimalus, nii öelda kaamerat live'is liigutada
- setUp - seadistab kaamera konfiguratsiooni tarkvaralisel poolel
- retakePicture - võimaldab teha pildi ümber
- photoOutput -  peatab kaamera preview ning salvestab fotoandmeid muutujase
- savePic - salvestab fotoandmeid pildina "Saved Photo" albumisse

<h3> Camera Preview

- seadisatab kaamera sessiooni
