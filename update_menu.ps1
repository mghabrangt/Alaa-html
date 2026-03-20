$pages = @('beyond_the_cage_simple_website.html', 'nutrition.html', 'enrichment.html', 'wing_clipping.html', 'cage_setup.html', 'common_mistakes.html')

$menuCssBlock = @'
  .menu-toggle { display: none; background: rgba(255,255,255,0.8); border: 1px solid rgba(47,58,53,.35); color: var(--text); font-size: 1rem; padding: 8px 12px; border-radius: 10px; cursor: pointer; margin-left: auto; }
  .menu { display: flex; align-items: center; gap: 18px; flex-wrap: wrap; }
  @media (max-width: 860px) {
    .menu-toggle { display: block; }
    .menu { display: none; flex-direction: column; width: 100%; margin-top: 10px; background: rgba(255,255,255,0.96); border-top: 1px solid var(--line); padding: 12px 16px; position: absolute; top: 70px; left: 0; right: 0; z-index: 1000; }
    .menu.open { display: flex; }
    .menu a { width: 100%; padding: 10px 0; border-bottom: 1px solid rgba(0,0,0,0.08); }
    .menu a:last-child { border-bottom: none; }
    .nav { position: relative; }
  }
'@

$scriptBlock = @'
<script>
const menuToggle = document.querySelector(".menu-toggle");
const navMenu = document.querySelector(".menu");
if (menuToggle && navMenu) {
  menuToggle.addEventListener("click", () => navMenu.classList.toggle("open"));
  window.addEventListener("resize", () => {
    if (window.innerWidth > 860) {
      navMenu.classList.remove("open");
    }
  });
}
</script>
'@

foreach ($p in $pages) {
    $path = Join-Path (Get-Location) $p
    if (-not (Test-Path $path)) {
        Write-Host "missing $p"
        continue
    }
    $text = Get-Content $path -Raw
    
    if ($text -notmatch 'class="menu-toggle"|class=''menu-toggle''') {
        if ($text -match '<nav class="menu"') {
            $text = $text -replace '<nav class="menu"', '    <button class="menu-toggle" aria-label="Toggle navigation menu">☰ Menu</button>`r`n    <nav class="menu"', 1
        } elseif ($text -match '<nav class=''menu''') {
            $text = $text -replace '<nav class=''menu''', '    <button class="menu-toggle" aria-label="Toggle navigation menu">☰ Menu</button>`r`n    <nav class=''menu''', 1
        }
    }

    if ($text -notmatch '\.menu-toggle\s*\{') {
        $text = $text -replace '</style>', "$menuCssBlock</style>", 1
    }

    if ($text -notmatch 'menuToggle') {
        $text = $text -replace '</body>', "$scriptBlock</body>", 1
    }

    Set-Content -Path $path -Value $text -Encoding UTF8
    Write-Host "updated $p"
}

Write-Host 'done'
