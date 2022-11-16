const _ = require('lodash');
const path = require('path');
const fs = require('fs-extra');

const ENCODING = 'utf8';
const CONTROL_SURFACE_DIR = 'Control Surface';
const MIDI_OUT_DIR = 'MIDI Out';
const DASHBOARD_DIR = 'Dashboard';
const PATCHER_GENERATOR_DIR = 'Patcher (generator)';
const PATCHER_EFFECT_DIR = 'Patcher (effect)';
const root = path.resolve(__dirname, '..');
const utils = __dirname;

const getDirCollection = (dir) => {
  return (fs.readdirSync(path.resolve(root, dir)) || [])
    .filter(file => file.endsWith('.fst'))
    .map(preset => ({
      name: path.basename(preset, path.extname(preset)),
      path: `${dir}/${preset}`,
      image: fs.existsSync(path.resolve(root, dir, `${preset}.png`))
        ? `${dir}/${preset}.png`
        : undefined,
    }));
};

const tpl = fs.readFileSync(path.resolve(utils, 'README_TPL.md'), ENCODING);

compiled = _.template(tpl);

const res = compiled({
  midiOutPresets: getDirCollection(MIDI_OUT_DIR),
  controlSurfacePresets: getDirCollection(CONTROL_SURFACE_DIR),
  dashboardPresets: getDirCollection(DASHBOARD_DIR),
  patcherGeneratorPresets: getDirCollection(PATCHER_GENERATOR_DIR),
  patcherEffectPresets: getDirCollection(PATCHER_EFFECT_DIR),
});

fs.writeFileSync(path.resolve(root, 'README.md'), res, ENCODING);

