#protoplug 1.4.0

Get it [here](https://github.com/pac-dev/protoplug/releases).

Very belated release with innumerable bugixes (thanks to the JUCE update), and finally proper support on macOS 64-bit (thanks to the LuaJIT update).

Brief install instructions:

Linux: Arch Linux users have an AUR package. Alternatively, the above "linux64" binaries were built on Ubuntu 16 but should work on other distros with libstdc++5. Extract ProtoplugFiles somewhere in your home folder, and place the .so plugins in your Linux VST folder, typically ~/.vst.

Windows: Extract the release zip to your VST folder (eg. C:\Program Files\Cubase\VSTPlugins). You can now load protoplug in your host.

Mac: Open the dmg, drag the plugins to your plugin folder (typically /Users/<username>/Library/Audio/Plug-Ins/<plugin type>), and drag ProtoplugFiles somewhere into your documents.
