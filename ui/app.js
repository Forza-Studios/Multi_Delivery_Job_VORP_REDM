// Frontier Jobs board - UI only. Renders jobs sent by client, posts back selections.
let jobs = [];
let selectedId = null;
let activeFilter = 'all';

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

function renderGrid() {
  const grid = document.getElementById('job-grid');
  grid.innerHTML = '';
  const list = activeFilter === 'all' ? jobs : jobs.filter(j => j.id === activeFilter);
  list.forEach((job) => {
    const card = document.createElement('div');
    card.className = 'job-card' + (job.id === selectedId ? ' selected' : '');
    card.innerHTML = `
      <img src="${escapeHtml(job.image)}" alt="${escapeHtml(job.name)}">
      <div class="card-body">
        <h4>${escapeHtml(job.name).toUpperCase()}</h4>
        <p>${escapeHtml(job.desc)}</p>
        <span class="lvl">Lv ${job.level || 1}</span>
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
}

function selectJob(id) {
  selectedId = id;
  const job = jobs.find(j => j.id === id);
  renderGrid();
  if (job) renderDetail(job);
}

function openBoard(data) {
  jobs = data.jobs || [];
  activeFilter = 'all';
  document.querySelectorAll('.nav-item').forEach(b => {
    b.classList.toggle('active', b.getAttribute('data-filter') === 'all');
  });
  selectedId = jobs.length ? jobs[0].id : null;
  renderGrid();
  const first = jobs.find(j => j.id === selectedId);
  if (first) renderDetail(first);
  document.getElementById('jobs-board').classList.remove('hidden');
}

function closeBoard() {
  document.getElementById('jobs-board').classList.add('hidden');
  postNUI('closeJobs');
}

document.querySelectorAll('.nav-item').forEach((btn) => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.nav-item').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    activeFilter = btn.getAttribute('data-filter');
    const list = activeFilter === 'all' ? jobs : jobs.filter(j => j.id === activeFilter);
    if (list.length) selectJob(list[0].id);
    else renderGrid();
  });
});

document.getElementById('btn-close').addEventListener('click', closeBoard);

document.getElementById('btn-start').addEventListener('click', () => {
  if (!selectedId) return;
  postNUI('startJob', { jobId: selectedId });
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
});
