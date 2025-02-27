; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Route Generator"
!define PRODUCT_VERSION "1.10.0"
!define PRODUCT_PUBLISHER "MJProductions"
!define PRODUCT_WEB_SITE "http://www.routegenerator.net"
!define PRODUCT_DIR_REGKEY "Software\MJProductions\Route Generator"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "MUI2.nsh"
!include "x64.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "routegen.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "routegen\LICENSE"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\routegen.exe"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\README.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "routegen-win64-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES64\Route Generator"

; Registry key to check for current installation directory (so if you install again, it will
; overwrite the old one automatically)
; !!!!!!!!!!!!!!!!!!!!!NOTE!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
; This function will read from the 32 bits registry! This is fine, because previous versions of RG were 32 bits.
; The current installer will write to 64 bits registry (Post section)! So we can't use InstallDirRegKey, next time.
; We probably have to read this key manually from the 64 bits registry in the .onInit function, but also still
; take into account that 32 bits versions are still out there.
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" "Install_Dir"
ShowInstDetails show
ShowUnInstDetails show

; Request application privileges for Windows Vista
RequestExecutionLevel admin

Section "Route Generator" MainInstall
  SetOutPath "$INSTDIR\bmp2avi"
  SetOverwrite try
  File "redist\bmp2avi\bmp2avi.*"
  SetOutPath "$INSTDIR\doc"
  File "redist\doc\*.*"
  SetOutPath "$INSTDIR\ffmpeg"
  File /r "redist\ffmpeg\*.*"
  SetOutPath "$INSTDIR"
  File "redist\google-maps-template.html"
  SetOutPath "$INSTDIR\imageformats"
  File "redist\imageformats\*.*"
  SetOutPath "$INSTDIR"
  File "redist\icudtl.dat"
  File "redist\qtwebengine*.*"
  SetOutPath "$INSTDIR\platforms"
  File "redist\platforms\*.*"
  SetOutPath "$INSTDIR\styles"
  File "redist\styles\*.*"
  SetOutPath "$INSTDIR\vehicles"
  File "redist\vehicles\*.*"
  SetOutPath "$INSTDIR"
  File "redist\*.*"

  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\Route Generator"
  CreateShortCut "$SMPROGRAMS\Route Generator\Route Generator.lnk" "$INSTDIR\routegen.exe"

SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  SetShellVarContext all
  CreateShortCut "$SMPROGRAMS\Route Generator\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\Route Generator\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section -Post
  SetRegView 64
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "Install_Dir" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function .onInit
  ${If} ${RunningX64}
    IfFileExists $INSTDIR\Uninstall.exe alreadyInstalled theEnd

    alreadyInstalled:
      MessageBox MB_YESNO "Route Generator already installed. Uninstall first? (Recommended)" IDYES unInstall IDNO noUninstall
      unInstall:
        Exec $INSTDIR\Uninstall.exe
        # If 32 bits version is still installed INSTDIR will point to Program Files(x86), but for 64 bit it should point to Program Files
        StrCpy $INSTDIR "$PROGRAMFILES64\Route Generator"
        Goto theEnd
      noUnInstall:
        DetailPrint "Old version will be overwritten"
      theEnd:
    
  ${Else}
    MessageBox MB_ICONSTOP|MB_OK "Unfortunately Route Generator does not work on 32 bits Windows!"
    Abort ; causes installer to quit.
  ${EndIf}

FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall 
  SetRegView 64
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\routegen.exe"
  Delete "$INSTDIR\README.txt"
  Delete "$INSTDIR\LICENSE"
  Delete "$INSTDIR\icudtl.dat"
  Delete "$INSTDIR\msvcp140.dll"
  Delete "$INSTDIR\msvcp140_1.dll"
  Delete "$INSTDIR\qtwebengine_devtools_resources.pak"
  Delete "$INSTDIR\qtwebengine_resources.pak"
  Delete "$INSTDIR\qtwebengine_resources_100p.pak"
  Delete "$INSTDIR\qtwebengine_resources_200p.pak"  
  Delete "$INSTDIR\qt5core.dll"
  Delete "$INSTDIR\qt5gui.dll"
  Delete "$INSTDIR\qt5network.dll"
  Delete "$INSTDIR\qt5positioning.dll"
  Delete "$INSTDIR\qt5printsupport.dll"
  Delete "$INSTDIR\qt5serialport.dll"
  Delete "$INSTDIR\qt5qml.dll"
  Delete "$INSTDIR\qt5qmlmodels.dll"
  Delete "$INSTDIR\qt5quick.dll"
  Delete "$INSTDIR\qt5quickwidgets.dll"
  Delete "$INSTDIR\qt5svg.dll"
  Delete "$INSTDIR\qt5webchannel.dll"
  Delete "$INSTDIR\qt5webenginecore.dll"
  Delete "$INSTDIR\qt5webenginewidgets.dll"
  Delete "$INSTDIR\qt5widgets.dll"
  Delete "$INSTDIR\qtwebengineprocess.exe"
  Delete "$INSTDIR\google-maps-template.html"
  Delete "$INSTDIR\Uninstall.exe"
 
  RMDir /r "$INSTDIR\vehicles"
  RMDir /r "$INSTDIR\imageformats"
  RMDir /r "$INSTDIR\styles"
  RMDir /r "$INSTDIR\platforms"
  RMDir /r "$INSTDIR\ffmpeg\presets"
  RMDir /r "$INSTDIR\ffmpeg\doc"
  RMDir /r "$INSTDIR\ffmpeg\bin"
  RMDir /r "$INSTDIR\ffmpeg"
  RMDir /r "$INSTDIR\doc"
  RMDir /r "$INSTDIR\bmp2avi"
  RMDir "$INSTDIR"

  SetShellVarContext all
  Delete "$SMPROGRAMS\Route Generator\Uninstall.lnk"
  Delete "$SMPROGRAMS\Route Generator\Website.lnk"
  Delete "$SMPROGRAMS\Route Generator\Route Generator.lnk"
  RMDir "$SMPROGRAMS\Route Generator"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
