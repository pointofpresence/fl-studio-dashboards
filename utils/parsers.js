// USER bank //////////////////////////////////////////////////////////////////

{
  const msb = 87;
  const lsbCount = 2;
  const type = 'PCMS';

  const a = [];
  for(lsb = 0; lsb <= lsbCount - 1; lsb++) {
    for(patch = 0; patch <= 127; patch++) {
      a.push(
        `No assign\\USER:${type}:${String(lsb * 128 + patch + 1).padStart(4, '0')}:INIT TONE=${msb},${lsb},${patch}`);
    }
  }

  copy(a.join('\n'));
}

// INTEGRA-7 ext to fa-06 /////////////////////////////////////////////

{
  const rep = [
    ['PLS', 'Pulsating'],
    ['POLYKEY', 'Synth PolyKey'],
    ['Syn.LD', 'Synth Lead'],
    ['Syn.PAD', 'Synth Pad/Strings'],
    ['Syn.BS', 'Synth Bass'],
    ['Syn.BRS', 'Synth Brass'],
    ['BELL', 'Bell'],
    ['BELLPAD', 'Synth Bellpad'],
    ['SFX', 'Synth FX'],
    ['FX', 'Synth FX'],
    ['Syn.SEQ', 'Synth Seq/Pop'],
    ['DRM', 'Drums'],
    ['VOX', 'Vox/Choir'],
    ['Ac.PNO', 'Vox/Choir'],
    ['EP1', 'E.Piano1'],
    ['EP2', 'E.Piano2'],
    ['HPCD', 'Harpsichord'],
    ['E.ORG', 'Vox/Choir'],
  ];

  const data = `1|SL-JP8 1|POLYKEY  |...`.split('\n');
  const start = 395;
  const msb = 95;
  const ext = 'Dream Rack Shorty';
  const type = 'SNS';

  copy(data.map((i, idx) => {
    const offset = Math.floor((idx + start - 1) / 128);
    const lsb = offset;
    const patch = (idx + start - 1) - 128 * offset;
    const parts = i.trim().split('|');

    parts.splice(-1, 1);

    let cat = String(parts.splice(-1, 1)).trim();
    const name = String(parts.splice(-1, 1)).trim();
    const num = String(parts.splice(0, 1)).trim();

    rep.forEach(r => {
      if (r[0] == cat) {
        cat = r[1];
      }
    });

    return `${cat}\\USER:${type}:${String(idx + start).padStart(4, '0')}:${name} (${ext})=${msb},${lsb},${patch}`;
  }).join('\n'));
}

//////// FA-06 standard ///////////////////////////////////////////////////////

{
  const type = 'PCMS';
  const bank = 'Ex11';
  let cat; //= 'Drums'
  let name;

  const cats = [
    'Pipe Organ',
    'Synth Pad/Strings',
    'Orchestral',
    'Solo Strings',
    'Plucked/Stroke',
    'Synth FX',
    'Sound FX',
    'Synth Brass',
    'Vox/Choir',
    'Beat&Groove',
    'Ac.Piano',
    'Pop Piano',
    'E.Grand Piano',
    'E.Piano1',
    'E.Piano2',
    'Harpsichord',
    'Clav',
    'Synth Bellpad',
    'Bell',
    'Mallet',
    'E.Organ',
    'Ac.Guitar',
    'E.Guitar',
    'Dist.Guitar',
    'Synth Bass',
    'Ensemble Strings',
    'Synth Pad/Strings',
    'Flute',
    'Solo Brass',
    'Ensemble Brass',
    'Sax',
    'Wind',
    'Synth Lead',
    'Synth PolyKey',
    'Synth Seq/Pop',
    'Pulsating',
    'Hit',
    'Ac.Bass',
    'E.Bass',
    'Accordion',
    'Percussion',
    'Harmonica',
    'Recorder',
    'Celesta',
    'Scat',
  ];

  copy(`1 JP+OB Str Synth Pad/Strings 93 27 1`
    .split('\n')
    .map((i, idx) => {
      let prepared = i.trim();
      let msb = prepared.split(' ').splice(-3, 1);

      if (!cat) {
        cats.forEach(c => {
          if (!prepared.includes('@')) {
            prepared = prepared.replace(` ${c} ${msb} `, ` @${c} ${msb} `);
          }
        });
      }

      const parts = prepared.split(' ');
      const patch = Number(parts.splice(-1, 1)) - 1;
      const lsb = parts.splice(-1, 1);

      msb = parts.splice(-1, 1);

      const num = String(parts.splice(0, 1)).padStart(4, '0');
      let newcat = '';

      if (cat) {
        name = parts.join(' ');
      } else {
        const nameparts = parts.join(' ').split('@');

        name = nameparts[0].trim();

        if (!nameparts[1]) {
          copy(nameparts[0]);
          throw new Error(nameparts[0] + ' ' + num);
        }

        newcat = nameparts[1].trim();
      }

      return `${cat || newcat}\\${bank}:${type}:${num}:${name}=${msb},${lsb},${patch}`;
    })
    .join('\n'),
  );
}

///////// GM2 integra-7 ///////////////////////////////////////////////////////

{
  const type = 'PCMS';
  const bank = 'GM2';

  copy(`1 Piano 1 121 0 1 @Ac.Piano`
    .split('\n')
    .map((i, idx) => {
      const firstparts = i.split('@');
      const cat = firstparts[1].trim();
      const parts = firstparts[0].trim().split(' ');
      const patch = Number(parts.splice(-1, 1)) - 1;
      const lsb = parts.splice(-1, 1);
      const msb = parts.splice(-1, 1);
      const num = String(parts.splice(0, 1)).padStart(4, '0');
      const name = parts.join(' ');

      return `${cat}\\${bank}:${type}:${num}:${name}=${msb},${lsb},${patch}`;
    })
    .join('\n'),
  );
}

///// JD-XI

{
  const bank = '';
  let cat = 'Analog';
  let name;

  const cats = [
    'Strings/Pad', 'Lead', 'Bass', 'Keyboard', 'FX/Other', 'Seq', 'Brass',
  ];

  copy(`001 Toxic Bass 1 94 64 1`
    .split('\n')
    .map((i, idx) => {
      let prepared = i.trim();
      let msb = prepared.split(' ').splice(-3, 1);

      if (!cat) {
        cats.forEach(c => {
          if (!prepared.includes('@')) {
            prepared = prepared.replace(` ${c} ${msb} `, ` @${c} ${msb} `);
          }
        });
      }

      const parts = prepared.split(' ');
      const patch = Number(parts.splice(-1, 1)) - 1;
      const lsb = parts.splice(-1, 1);
      msb = parts.splice(-1, 1);
      const num = String(parts.splice(0, 1));
      let newcat = '';

      if (cat) {
        name = parts.join(' ');
      } else {
        const nameparts = parts.join(' ').split('@');

        name = nameparts[0].trim();

        if (!nameparts[1]) {
          copy(nameparts[0]);
          throw new Error(nameparts[0] + ' ' + num);
        }

        newcat = nameparts[1].trim();
      }

      return `${cat || newcat}\\${bank}:${num}:${name}=${msb},${lsb},${patch}`;
    })
    .join('\n'),
  );
}
