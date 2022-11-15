# FL Studio MIDI Dashboards

## Installation instructions:

Download the .zip file... unpack.

1) Place folders from `Artwork` into:
   `[your Image-Line folder]/[your FL Studio folder]/Plugins/Fruity/Generators/Dashboard/Artwork/`

2) Place files from `Dashboard` into:
   `[your Image-Line folder]/[your FL Studio folder]/Data/Patches/Plugin presets/Generators/Dashboard/`

3) Place files from `MIDI Out` into:
   `[your Image-Line folder]/[your FL Studio folder]/Data/Patches/Plugin presets/Generators/MIDI Out/`


## Dashboard presets

### Roland JP-08

author: ReSampled

![Roland JP-08 dashboard](images/dashboard_roland_jp_08.png)
  

### Roland SE-02 

author: penneyfour from forum.image-line.com

![Roland SE-02 dashboard](images/dashboard_roland_se_02.png)


### Roland SH-01A (patchlist only)

author: ReSampled

![Roland SH-01A](images/dashboard_sh-01a.png)


### Roland FA-06/07/08 (Tones, patchlist only)

author: ReSampled

![Roland FA-06/07/08 Tone](images/dashboard_fa06_tone.png)


### Roland FA-06/07/08 (Studio Set, patchlist only)

author: ReSampled

![Roland FA-06/07/08 Studio Set](images/dashboard_fa06_ss.png)


### Roland INTEGRA-7 (Tones, patchlist only)

author: ReSampled

![Roland INTEGRA-7](images/dashboard_integra-7_melodic.png)


### Roland JD-XI (patchlist only)

author: ReSampled

![Roland JD-XI](images/dashboard_jd-xi.png)


### M-AUDIO Venom (patchlist only)

author: ReSampled

![M-AUDIO Venom](images/dashboard_m-audio_venom.png)


## MIDI Out presets

<% midiOutPresets.forEach(function(preset) { %>* <a href="<%= preset.path %>"><%- preset.name %></a><%= '\n' %><% }); %>
