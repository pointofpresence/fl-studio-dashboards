set source=G:\__documents\Image-Line\FL Studio

set dest=H:\FL Studio 20\Plugins\Fruity\Generators\Dashboard

RD /S /Q "%dest%\MIDI Out"
robocopy "%source%\Presets\Plugin presets\Generators\MIDI Out" "%dest%\MIDI Out" /e
RD /S /Q "%dest%\MIDI Out\Old"

RD /S /Q "%dest%\Dashboard"
robocopy "%source%\Presets\Plugin presets\Generators\Dashboard" "%dest%\Dashboard" /e
RD /S /Q "%dest%\Dashboard\Old"

RD /S /Q "%dest%\Control Surface"
robocopy "%source%\Presets\Plugin presets\Effects\Control Surface" "%dest%\Control Surface" /e
RD /S /Q "%dest%\Control Surface\Old"

RD /S /Q "%dest%\Patcher (generator)"
robocopy "%source%\Presets\Plugin presets\Generators\Patcher" "%dest%\Patcher (generator)" /e
RD /S /Q "%dest%\Patcher (generator)\Old"

RD /S /Q "%dest%\Patcher (effect)"
robocopy "%source%\Presets\Plugin presets\Effects\Patcher" "%dest%\Patcher (effect)" /e
RD /S /Q "%dest%\Patcher (effect)\Old"

node ./utils/genreadme.js
