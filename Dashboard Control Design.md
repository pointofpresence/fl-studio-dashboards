Dashboard Controls - Specification (version 1.0)
==================================

Contents
--------
1. Introduction
2. Remarks
3. The [Info] section
4. The [Properties] section
5. The [Items] section
6. Explanation of the specific controls



1. Introduction
---------------
A Dashboard control is defined in a file with a .ini extension. 

There can be several sections that describe it:
- info (has to be present)
- properties
- items (only for some types of controls)

Each section has one or more values. A value looks like this: 
    name=value

A Dashboard control can use other files. At the moment, only bitmaps (.bmp, .jpg and .tga) are supported. 
Other files are referenced by their filename, relative to the Artwork folder under the Dashboard 
folder or relative to the location of the .ini file.  

Here are some examples:
- relative to the Artwork folder :  somedir\somefile.bmp  ==> Artwork\somedir\somefile.bmp
- relative to the .ini file      :  .\somefile.bmp        ==> Artwork\folder that the .ini is in\somefile.bmp



2. Remarks
----------
- don't put your own controls or bitmaps in the Default folder!
- a control is identified by its name, so make sure to give it one that's both descriptive and unique
- preferably put all controls of a certain group in a directory away from the rest
- if you don't specify a background image for a control, it's transparent. Not all controls support this very well
- take a look at the provided controls, they'll show you most of what you need to know



3. The [Info] section
---------------------
These are the values that can be defined in this section:

- Name       : 
    The name of the control. This has to be unique. Other than that there are no restrictions.
    Required.
- Kind       : 
    The kind of control. These are the possible values:
        0 = DigiWheel     
        1 = Slider        
        2 = Wheel         
        3 = Panel         
        4 = Switch        
        5 = Label         
        6 = Image         
        7 = Selector      
        8 = Patch selector 
        9 = Page selector  
    Required.
- Default    : 
    Indicates if this control is the default control for its kind (Default=1) or not (Default=0). 
    A default control is the one that is used if a specific control of this kind can't be found (because the user doesn't have it installed).
    Optional.
- Background : 
    This is a reference to the image file that will be used as background for the control. 
    If a background is specified, it determines the control's width and height.
    If you want to allow the user to make a background transparent, you have to specify an 8-bit .bmp file.
    Not all controls will use this value (see the explanation of each control kind for more information).
    Optional.
- Foreground :
    This is a reference to the image file that will be used as foreground for the control. This could be a knob for a slider, for example.
    Not all controls will use this value (see the explanation of each control kind for more information).
    Optional.



4. The [Properties] section
---------------------------
This section defines the values to be used for the properties of a control. These are all optional.
A full list is provided with the explanation for each control kind. These are the properties that are common to all controls:

- Width            : The initial width of the control. This value is only used if the control doesn't have a background.
- Height           : The initial height of the control. This value is only used if the control doesn't have a background.
- Resize           : This determines if the control is resizeable (Resize=1) or not (Resize=0). By default, controls are NOT resizeable.
- Caption Position : The position of the caption. Possible values: Left, Top, Right, Bottom
- Show Caption     : Possible values: True, False
- Transparent      : Possible values: True, False



5. The [Items] section
----------------------
This section is only valid for selectors and patch selectors. It defines the values that will be available in the selector.
The values are specified as a long list with this format (the = character is required):
    valuename= 
For patch selector controls, this can also include the bank and program numbers:
    valuename=bank msb, bank lsb, program number

Here's an example:

[items]
100% Left=
50% Left=
Centered=
50% Right=
100% Right=



6. Explanation of the specific controls
---------------------------------------
There are currently ten different control kinds. 
There are two main types of controls: those that can be used as a controller (midi or internal controller) and those that can't. 

    A. DigiWheel (kind=0)
    °°°°°°°°°°°°°°°°°°°°°
    - like a wheel, but it displays a different image for each value
    - can be used as a controller
    - the background is used for the border around the control
    - the foreground is used for the values (see the supplied digiwheel controls)
    [properties]
    - Border     : specificies the border around the control as follows:
                       Border=left, top, right, bottom
    - Move Speed : the speed at which values change when you move the mouse (higher value = faster)

    B. Slider (kind=1)
    °°°°°°°°°°°°°°°°°°
    - an up/down slider control
    - can be used as a controller
    - the foreground is used as the knob of the slider. Most of the time, this is a .tga file which can be transparent.
    [properties]
    - Move Speed : the speed at which values change when you move the mouse (higher value = faster)

    C. Wheel (kind=2)
    °°°°°°°°°°°°°°°°°
    - a wheel control with a line as indicator of the value
    - can be used as a controller
    - the foreground isn't used
    [properties]
    - Line Length   : the length of the indicator line, as a percentage of the width/height of the control
    - Line Color    : the color of the indicator line as a hexadecimal RGB (red-green-blue) value
                      Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green
    - Line Width    : the width of the indicator line. Possible values: Normal, Thick
    - Move Speed    : the speed at which values change when you move the mouse (higher value = faster)
    - Pressed Color : the color of the indicator line when the mousebutton is pressed as a hexadecimal RGB value
                      Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green

    D. Panel (kind=3)
    °°°°°°°°°°°°°°°°°
    - this is what's used as the background of a dashboard
    - the foreground isn't used
    [properties]
    - Border       : specificies the border around the control as follows:
                         Border=left, top, right, bottom
    - Grid Color   : the color of the grid as a hexadecimal RGB value
                     Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green
    - Grid Size    : the number of pixels between positions of the grid
    - Snap to grid : Determines whether control positions are snapped to the grid (Snap to grid=True) or not (Snap to grid=False)
    - Label Color  : The color of the caption labels for all controls
    - LabelFont    : The name of the font that is used for caption labels of controls

    E. Switch (kind=4)
    °°°°°°°°°°°°°°°°°°
    - this is a button which can be either up or down
    - can be used as a controller
    - the foreground should contain two images, one for up and one for down
    - the background isn't used
    [properties]
    - FX Attack  : Possible values: 1..256
    - FX Blink   : Possible values: Not, On press, On over
    - FX Release : Possible values: 1..256
    - FX Type    : Possible values: None, Blend, Color
    - FX When    : Possible values: On over, On press, Not

    F. Label (kind=5)
    °°°°°°°°°°°°°°°°°
    - this is simple a control that displayes text, nothing more
    - Background and Foreground aren't used
    [properties]
    - Font       : the name of the font to use
    - Font Color : the color for the font, as a hexadecimal RGB value
                   Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green
    - Font Size  : the size of the font

    G. Image (kind=6)
    °°°°°°°°°°°°°°°°°
    - this control simply displays an image
    - Foreground isn't used

    H. Selector (kind=7)
    °°°°°°°°°°°°°°°°°°°°
    - this is a combobox control, it will show a list of values when the user clicks on it
    - the list of values is read from the [items] section of the .ini file
    - Foreground isn't used
    - can be used as a controller
    [properties]
    - Font Color : the color of the control's text (not the caption) as a hexadecimal RGV value
                   Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green

    I. Patch selector (kind=8)
    °°°°°°°°°°°°°°°°°°°°°°°°°°
    - this control allows the user to select a patch from a list of predefined values
    - the list of values is read from the [items] section of the .ini file
    - each value should have bank msb, bank lsb and program number information appended (see the description of the [items] section above)
    - Foreground isn't used
    [properties]
    - Font Color : the color of the control's text (not the caption) as a hexadecimal RGV value
                   Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green

    J. Page selector (kind=9)
    °°°°°°°°°°°°°°°°°°°°°°°°°
    - this is a special type of control. Its only function is to select pages on the dashboard, if there are any
    - Foreground isn't used
    [properties]
    - Font Color : the color of the control's text (not the caption) as a hexadecimal RGV value
                   Examples: $FFFFFF is white, $0000FF is red, $FF0000 is blue, $00FF00 is green
