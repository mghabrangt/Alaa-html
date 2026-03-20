from pathlib import Path

pages = [
    'beyond_the_cage_simple_website.html',
    'nutrition.html',
    'enrichment.html',
    'wing_clipping.html',
    'cage_setup.html',
    'common_mistakes.html',
]

menu_css = '''  .menu-toggle { display: none; background: rgba(255,255,255,0.8); border: 1px solid rgba(47,58,53,.35); color: var(--text); font-size: 1rem; padding: 8px 12px; border-radius: 10px; cursor: pointer; margin-left: auto; }
  .menu { display: flex; align-items: center; gap: 18px; flex-wrap: wrap; }
  @media (max-width: 860px) {
    .menu-toggle { display: block; }
    .menu { display: none; flex-direction: column; width: 100%; margin-top: 10px; background: rgba(255,255,255,0.96); border-top: 1px solid var(--line); padding: 12px 16px; position: absolute; top: 70px; left: 0; right: 0; z-index: 1000; }
    .menu.open { display: flex; }
    .menu a { width: 100%; padding: 10px 0; border-bottom: 1px solid rgba(0,0,0,0.08); }
    .menu a:last-child { border-bottom: none; }
    .nav { position: relative; }
  }
'''

menu_script = '''<script>
const menuToggle = document.querySelector('.menu-toggle');
const navMenu = document.querySelector('.menu');
if (menuToggle && navMenu) {
  menuToggle.addEventListener('click', () => navMenu.classList.toggle('open'));
  window.addEventListener('resize', () => {
    if (window.innerWidth > 860) {
      navMenu.classList.remove('open');
    }
  });
}
</script>'''

for p in pages:
    path = Path(p)
    if not path.exists():
        print('missing', p)
        continue
    text = path.read_text(encoding='utf-8')
    if 'class="menu-toggle"' not in text and "class='menu-toggle'" not in text:
        if '<nav class="menu"' in text:
            text = text.replace('<nav class="menu"', '    <button class="menu-toggle" aria-label="Toggle navigation menu">☰ Menu</button>\n    <nav class="menu"', 1)
        elif "<nav class='menu'" in text:
            text = text.replace("<nav class='menu'", "    <button class='menu-toggle' aria-label='Toggle navigation menu'>☰ Menu</button>\n    <nav class='menu'", 1)

    if '.menu-toggle' not in text:
        text = text.replace('</style>', menu_css + '\n</style>', 1)

    if 'menuToggle' not in text:
        if '</body>' in text:
            text = text.replace('</body>', menu_script + '\n</body>', 1)

    path.write_text(text, encoding='utf-8')
    print('updated', p)

print('done')
