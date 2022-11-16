module.exports = function(data) {
  const config = {
    cascade: 'true',
    firstLevel: 2,
    menuTitle: '## Содержание',
    placeholder: '<!--mdMenu-->',
    maxLevel: 2,
  };

  // Matches to all headers in document (by default: /#{2,6}\s.+/g)
  const headerRegexp = new RegExp('#{' + config.firstLevel + ',6}\\s.+', 'g');

  // todo: check this regexp if more than 1 menu are on a page
  // Matches to placeholders with/without menu (by default: /<!--mdMenu-->[\s\S]*<!--mdMenu-->/)
  const menuRegexp = new RegExp(config.placeholder);

  const content = data.toString();
  const headersArr = content.match(headerRegexp);
  const br = '\r\n';
  let menu;
  let res;

  if (headersArr === null || !headersArr.length) {
    console.log('No headers were found.');
    return;
  }

  menu = headersArr
    // Remove title of menu from menu (config.menuTitle)
    .filter(function(header) {
      return header !== config.menuTitle;
    })
    // Getting md links
    .map(function(header) {
      let tabs = '';
      let link;

      if (config.cascade === 'true') {
        // Detect level of header
        const level = (header.match(/#/g) || []).length;

        if (level > config.maxLevel) {
          return '';
        }

        // Save tabs if needed
        tabs = new Array(level - config.firstLevel + 1).join('\t') + '* ';
      }

      // Normalize header
      header = header.replace(/#{1,6}\s/g, '').trim();
      // Create links like md parser does
      link = '#' + header.replace(/[&\/]/g, '').replace(/\s/g, '-').toLowerCase();

      return tabs + '[' + header + '](' + link + ')';
    })
    // Concat
    .filter(a => a)
    .join('\r\n');

  if (config.menuTitle) {
    menu = config.placeholder + br + config.menuTitle + br + menu + br + config.placeholder;
  } else {
    menu = config.placeholder + br + menu + br + config.placeholder;
  }

  // If no placeholders - paste in the beginning of document
  if (content.indexOf(config.placeholder) !== -1) {
    res = content.replace(menuRegexp, menu);
  } else {
    res = menu + br + br + content;
  }

  return res;
};
