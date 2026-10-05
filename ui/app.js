// Frontier Jobs board. Renders real jobs sent by client, tracks active contract.
let jobs = [];
let selectedId = null;
let activeFilter = 'all';
let activeJobId = null;

function postNUI(endpoint, data = {}) {
  const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'coi_multi_job';
  return fetch(`https://${resourceName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  }).catch(() => {});
}

function escapeHtml(s) {
  return String(s == null ? '' : s)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;')
    .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

// Fallback art if placehold.co is unreachable in-game.
function imgFallback(el, label) {
  el.onerror = null;
  el.src = 'data:image/svg+xml;utf8,' + encodeURIComponent(
    `<svg xmlns="http://www.w3.org/2000/svg" width="600" height="400"><rect width="100%" height="100%" fill="#2a2118"/><text x="50%" y="52%" fill="#d9b36a" font-size="42" text-anchor="middle" font-family="Georgia">${label}</text></svg>`
  );
}

function rewardIcon(name) {
  const n = String(name || '').toLowerCase();
  if (n.includes('money') || n.includes('$')) return '$';
  if (n.includes('xp')) return 'XP';
  if (n.includes('hide') || n.includes('leather')) return 'H';
  if (n.includes('meat')) return 'M';
  return name ? name.charAt(0).toUpperCase() : '?';
}

function navIcon(icon) {
  const map = { paper: '&#9998;', paw: '&#9679;', pick: '&#9874;', wheat: '&#10087;', cart: '&#9785;', star: '&#9733;', target: '&#9678;', bottle: '&#9749;', hammer: '&#9874;', shake: '&#9990;' };
  return map[icon] || '&#9670;';
}

// Rebuild sidebar from the real jobs list (All Jobs + one button per job).
function renderNav() {
  const nav = document.getElementById('job-nav');
  nav.innerHTML = '';
  const all = document.createElement('button');
  all.className = 'nav-item' + (activeFilter === 'all' ? ' active' : '');
  all.setAttribute('data-filter', 'all');
  all.innerHTML = `<span class="nav-ico">&#9783;</span>All Jobs`;
  all.addEventListener('click', () => setFilter('all'));
  nav.appendChild(all);
  jobs.forEach((job) => {
    const b = document.createElement('button');
    b.className = 'nav-item' + (activeFilter === job.id ? ' active' : '');
    b.setAttribute('data-filter', job.id);
    b.innerHTML = `<span class="nav-ico">${navIcon(job.icon)}</span>${escapeHtml(job.name)}`;
    b.addEventListener('click', () => setFilter(job.id));
    nav.appendChild(b);
  });
}

function setFilter(f) {
  activeFilter = f;
  renderNav();
  const list = activeFilter === 'all' ? jobs : jobs.filter(j => j.id === activeFilter);
  if (list.length) selectJob(list[0].id);
  else renderGrid();
}

function renderGrid() {
  const grid = document.getElementById('job-grid');
  grid.innerHTML = '';
  const list = activeFilter === 'all' ? jobs : jobs.filter(j => j.id === activeFilter);
  list.forEach((job) => {
    const card = document.createElement('div');
    card.className = 'job-card' + (job.id === selectedId ? ' selected' : '');
    const activeTag = job.id === activeJobId ? ' <span class="lvl">ACTIVE</span>' : '';
    card.innerHTML = `
      <img src="${escapeHtml(job.image)}" alt="${escapeHtml(job.name)}">
      <div class="card-body">
        <h4>${escapeHtml(job.name).toUpperCase()}</h4>
        <p>${escapeHtml(job.desc)}</p>
        <span class="lvl">Lv ${job.level || 1}</span>${activeTag}
        <span class="chev">&#10095;</span>
      </div>`;
    const img = card.querySelector('img');
    img.onerror = () => imgFallback(img, job.name.toUpperCase());
    card.addEventListener('click', () => selectJob(job.id));
    grid.appendChild(card);
  });
}

function renderDetail(job) {
  if (!job) return;
  const img = document.getElementById('detail-img');
  img.src = job.image;
  img.onerror = () => imgFallback(img, job.name.toUpperCase());
  document.getElementById('detail-name').textContent = job.name.toUpperCase();
  document.getElementById('detail-tagline').textContent = job.tagline || '';
  document.getElementById('detail-desc').textContent = job.details || job.desc || '';
  document.getElementById('detail-req-text').textContent = job.requirement || '';
  const rw = document.getElementById('detail-rewards');
  rw.innerHTML = '';
  (job.rewards || []).forEach((r) => {
    const d = document.createElement('div');
    d.className = 'reward';
    d.innerHTML = `<div class="r-ico">${escapeHtml(rewardIcon(r))}</div>${escapeHtml(r)}`;
    rw.appendChild(d);
  });
  // START vs CANCEL depending on whether this job is the active contract.
  const isActive = job.id === activeJobId;
  document.getElementById('btn-start').classList.toggle('hidden', isActive);
  document.getElementById('btn-cancel').classList.toggle('hidden', !isActive);
}

function renderPill() {
  const pill = document.getElementById('active-pill');
  const job = jobs.find(j => j.id === activeJobId);
  if (!job) {
    // Keep the name if we only got an id (e.g. pill update without full list).
    if (!activeJobId) { pill.classList.add('hidden'); return; }
    document.getElementById('pill-text').textContent = 'ACTIVE: ' + String(activeJobId).toUpperCase();
    pill.classList.remove('hidden');
    return;
  }
  document.getElementById('pill-text').textContent = 'ACTIVE: ' + job.name.toUpperCase();
  pill.classList.remove('hidden');
}

function selectJob(id) {
  selectedId = id;
  const job = jobs.find(j => j.id === id);
  renderGrid();
  if (job) renderDetail(job);
}

function openBoard(data) {
  jobs = data.jobs || [];
  if (data.activeJobId !== undefined) activeJobId = data.activeJobId;
  activeFilter = 'all';
  renderNav();
  selectedId = jobs.length ? jobs[0].id : null;
  renderGrid();
  const first = jobs.find(j => j.id === selectedId);
  if (first) renderDetail(first);
  renderPill();
  document.getElementById('jobs-board').classList.remove('hidden');
}

function closeBoard() {
  document.getElementById('jobs-board').classList.add('hidden');
  postNUI('closeJobs');
}

function hideBoard() {
  document.getElementById('jobs-board').classList.add('hidden');
}

document.getElementById('btn-close').addEventListener('click', closeBoard);

document.getElementById('btn-start').addEventListener('click', () => {
  if (!selectedId) return;
  hideBoard(); // close immediately, client confirms with closeJobs as well
  postNUI('startJob', { jobId: selectedId });
});

document.getElementById('btn-cancel').addEventListener('click', () => {
  hideBoard(); // close immediately, client confirms with closeJobs as well
  postNUI('cancelJob', { jobId: selectedId });
});

document.getElementById('pill-cancel').addEventListener('click', () => {
  hideBoard();
  postNUI('cancelJob', {});
});

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && !document.getElementById('jobs-board').classList.contains('hidden')) {
    closeBoard();
  }
});

window.addEventListener('message', (e) => {
  const data = e.data || {};
  if (data.action === 'openJobs') openBoard(data);
  if (data.action === 'closeJobs') document.getElementById('jobs-board').classList.add('hidden');
  if (data.action === 'setActiveJob') {
    activeJobId = data.activeJobId || null;
    if (data.jobs) { jobs = data.jobs; renderNav(); }
    renderGrid();
    const sel = jobs.find(j => j.id === selectedId);
    if (sel) renderDetail(sel);
    renderPill();
  }
});
