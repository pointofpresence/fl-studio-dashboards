# Коллекция полезностей для FL Studio

## Пресеты Dashboard

### Установка

1. Скачайте архив с репозиторием (или клонируйте)
2. Скопируйте папки из `Artwork` в
   `[папка Image-Line folder]/[папка FL Studio folder]/Plugins/Fruity/Generators/Dashboard/Artwork/`
3. Скопируйте файлы из `Dashboard` в
   `[папка Image-Line folder]/[папка FL Studio folder]/Data/Patches/Plugin presets/Generators/Dashboard/`


### Пресеты

<% dashboardPresets.forEach(function(preset) { %>
### <%- preset.name %>
<a href="<%= preset.path %>?raw=true">Скачать</a>
<% if(preset.image) { %>
<img src="<%= preset.image %>" />
<% } %>
<% }); %>


## Пресеты MIDI Out

### Установка

Скачайте файл пресета и поместите в `[папка Image-Line]/[папка FL Studio]/Data/Patches/Plugin presets/Generators/MIDI Out/`.


### Пресеты

<% midiOutPresets.forEach(function(preset) { %>
### <%- preset.name %>
<a href="<%= preset.path %>?raw=true">Скачать</a>
<% if(preset.image) { %>
<img src="<%= preset.image %>" />
<% } %>
<% }); %>


## Пресеты Control Surface

### Установка

Скачайте файл пресета и поместите в `[папка Image-Line]/[папка FL Studio]/Data/Patches/Plugin presets/Effects/Control Surface/`.


### Пресеты

<% controlSurfacePresets.forEach(function(preset) { %>
### <%- preset.name %>
<a href="<%= preset.path %>?raw=true">Скачать</a>
<% if(preset.image) { %>
<img src="<%= preset.image %>" />
<% } %>
<% }); %>


## Пресеты Patcher (генератор)

### Установка

Скачайте файл пресета и поместите в `[папка Image-Line]/[папка FL Studio]/Data/Patches/Plugin presets/Generators/Patcher/`.


### Пресеты

<% patcherGeneratorPresets.forEach(function(preset) { %>
### <%- preset.name %>
<a href="<%= preset.path %>?raw=true">Скачать</a>
<% if(preset.image) { %>
<img src="<%= preset.image %>" />
<% } %>
<% }); %>


## Пресеты Patcher (эффект)

### Установка

Скачайте файл пресета и поместите в `[папка Image-Line]/[папка FL Studio]/Data/Patches/Plugin presets/Effects/Patcher/`.


### Пресеты

<% patcherEffectPresets.forEach(function(preset) { %>
### <%- preset.name %>
<a href="<%= preset.path %>?raw=true">Скачать</a>
<% if(preset.image) { %>
<img src="<%= preset.image %>" />
<% } %>
<% }); %>
