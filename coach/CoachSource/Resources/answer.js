window.renderAnswer = function (markdown) {
  const node = document.getElementById('answer');
  if (!markdown) { node.innerHTML = '<p class="empty">Your explanation will appear here.</p>'; return; }
  const top = window.scrollY;
  node.innerHTML = DOMPurify.sanitize(marked.parse(markdown, {gfm:true, breaks:false}), {
    ALLOWED_TAGS: ['p','br','strong','em','del','h1','h2','h3','h4','h5','h6','ul','ol','li','blockquote','pre','code','hr','table','thead','tbody','tr','th','td','a'],
    ALLOWED_ATTR: ['href','title','start'], ALLOW_DATA_ATTR: false
  });
  node.querySelectorAll('a').forEach(a => { if (!/^https?:\/\//i.test(a.getAttribute('href') || '')) a.removeAttribute('href'); });
  // Add native speech controls only after sanitizing model-generated markup.
  const walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT);
  const texts = [];
  while (walker.nextNode()) texts.push(walker.currentNode);
  texts.forEach(text => {
    if (text.parentElement.closest('pre, code, a')) return;
    const pattern = /\b(US|UK)\s*\/[^/\n]+\//g;
    const matches = [...text.textContent.matchAll(pattern)];
    if (!matches.length) return;
    const fragment = document.createDocumentFragment();
    let offset = 0;
    matches.forEach(match => {
      fragment.append(document.createTextNode(text.textContent.slice(offset, match.index)));
      const group = document.createElement('span');
      group.style.whiteSpace = 'nowrap';
      group.append(document.createTextNode(match[0] + ' '));
      const button = document.createElement('button');
      const accent = match[1];
      button.textContent = '🔊';
      button.title = accent === 'US' ? 'American pronunciation' : 'British pronunciation';
      button.setAttribute('aria-label', button.title);
      button.onclick = () => window.webkit?.messageHandlers?.pronounce?.postMessage(accent);
      group.append(button); fragment.append(group);
      offset = match.index + match[0].length;
    });
    fragment.append(document.createTextNode(text.textContent.slice(offset)));
    text.replaceWith(fragment);
  });
  window.scrollTo(0, top);
};
window.renderAnswer('');

document.addEventListener('selectionchange', () => {
  const selection = window.getSelection();
  const text = selection && document.getElementById('answer').contains(selection.anchorNode) ? selection.toString() : '';
  window.webkit?.messageHandlers?.selection?.postMessage(text);
});
