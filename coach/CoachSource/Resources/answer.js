window.renderAnswer = function (markdown) {
  const node = document.getElementById('answer');
  if (!markdown) { node.innerHTML = '<p class="empty">Your explanation will appear here.</p>'; return; }
  const top = window.scrollY;
  node.innerHTML = DOMPurify.sanitize(marked.parse(markdown, {gfm:true, breaks:false}), {
    ALLOWED_TAGS: ['p','br','strong','em','del','h1','h2','h3','h4','h5','h6','ul','ol','li','blockquote','pre','code','hr','table','thead','tbody','tr','th','td','a'],
    ALLOWED_ATTR: ['href','title','start'], ALLOW_DATA_ATTR: false
  });
  node.querySelectorAll('a').forEach(a => { if (!/^https?:\/\//i.test(a.getAttribute('href') || '')) a.removeAttribute('href'); });
  window.scrollTo(0, top);
};
window.renderAnswer('');

document.addEventListener('selectionchange', () => {
  const selection = window.getSelection();
  const text = selection && document.getElementById('answer').contains(selection.anchorNode) ? selection.toString() : '';
  window.webkit?.messageHandlers?.selection?.postMessage(text);
});
