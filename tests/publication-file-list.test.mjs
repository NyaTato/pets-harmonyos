import test from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { realpathSync, readFileSync, statSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// NOTE: path allowlist only. It cannot prove asset licensing,
// nor can it prove that file contents are free of credentials.
const root = fileURLToPath(new URL('../', import.meta.url));

function listCandidates() {
  const out = execFileSync(
    'git',
    ['ls-files', '--cached', '--others', '--exclude-standard', '-z'],
    { cwd: root, encoding: 'buffer', maxBuffer: 10 * 1024 * 1024 },
  );
  return out
    .toString('utf8')
    .split('\0')
    .filter((s) => s.length > 0)
    .map((s) => s.replace(/\\/g, '/').replace(/^\.\//, ''));
}

const BLOCKED_DIRS = new Set([
  'build',
  'node_modules',
  'oh_modules',
  '.hvigor',
  '.hvigor-user-home',
  '.ohpm-home',
  '.build-temp',
  '.idea',
  '.vscode',
  '.asset_backup',
]);

function violationFor(rel) {
  const lower = rel.replace(/\\/g, '/').replace(/^\.\//, '').toLowerCase();
  const segs = lower.split('/');
  const base = segs[segs.length - 1];
  if (base === 'local.properties') return 'local.properties';
  if (/^\.env([._-].*)?$/.test(base)) return '.env variant';
  if (/\.(p12|pfx|jks|keystore|pem|key)$/.test(lower)) return 'private-key/cert';
  if (/\.(hap|hsp|har)$/.test(lower)) return 'package-output';
  for (const seg of segs) {
    if (BLOCKED_DIRS.has(seg)) return `dir:${seg}`;
  }
  if (lower === 'html' || lower.startsWith('html/')) return 'root html/';
  return null;
}

function resolveRootReal() {
  // Fail closed: never fall back to an unverified path. Throws when the
  // project root cannot be resolved; callers treat that as a failure.
  return realpathSync(root);
}

function isResolvedOutsideRoot(resolvedAbs, rootReal) {
  const rel = path.relative(rootReal, resolvedAbs);
  if (rel === '') return false;
  return rel === '..' || rel.startsWith(`..${path.sep}`) || path.isAbsolute(rel);
}

// ---- High-confidence secret content gate (small scope, stdlib only) ----
// Only covers a few high-confidence shapes; it does not claim to find every
// key from every service. Reports only relative path + rule name, never any
// matched snippet or file content. No generic password matching on purpose:
// repo mock credentials are demo data.
const MAX_TEXT_BYTES = 2 * 1024 * 1024;
const SKIPPABLE_IMAGE_RE = /\.(jpg|jpeg|png|webp|gif|ico)$/i;
const SECRET_RULES = [
  { name: 'pem-private-key', pattern: new RegExp('-----' + 'BEGIN (?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY' + '-----') },
  { name: 'sk-token', pattern: new RegExp('\\b' + 's' + 'k-[A-Za-z0-9_\\-]{20,}\\b') },
  {
    name: 'github-token',
    pattern: new RegExp('\\b(?:' + 'gh' + 'p_[A-Za-z0-9]{36,}' + '|' + 'github_' + 'pat_[A-Za-z0-9_]{22,}' + ')\\b'),
  },
  { name: 'aws-access-key', pattern: new RegExp('\\b' + 'AK' + 'IA[0-9A-Z]{16}\\b') },
];

function findSecretRules(text) {
  const hits = [];
  for (const { name, pattern } of SECRET_RULES) {
    pattern.lastIndex = 0;
    if (pattern.test(text)) hits.push(name);
  }
  return hits;
}

function isSkippableImage(rel) {
  return SKIPPABLE_IMAGE_RE.test(rel);
}

function contentViolationForWithRoot(rel, rootDir) {
  let rootReal;
  try {
    rootReal = realpathSync(rootDir);
  } catch (err) {
    const kind = (err && (err.code || err.name)) || 'unknown';
    return `${rel} (unresolvable-root:${kind})`;
  }
  const abs = path.join(rootDir, rel);
  let real;
  try {
    real = realpathSync(abs);
  } catch (err) {
    const kind = (err && (err.code || err.name)) || 'unknown';
    return `${rel} (unresolvable:${kind})`;
  }
  if (isResolvedOutsideRoot(real, rootReal)) {
    return `${rel} (outside-root)`;
  }
  if (isSkippableImage(rel)) return null;
  let size = NaN;
  try {
    size = statSync(real).size;
  } catch (err) {
    const kind = (err && (err.code || err.name)) || 'unknown';
    return `${rel} (unreadable:${kind})`;
  }
  if (!Number.isFinite(size) || size > MAX_TEXT_BYTES) {
    return `${rel} (oversize)`;
  }
  let buf;
  try {
    buf = readFileSync(real);
  } catch (err) {
    const kind = (err && (err.code || err.name)) || 'unknown';
    return `${rel} (unreadable:${kind})`;
  }
  if (buf.length > MAX_TEXT_BYTES) return `${rel} (oversize)`;
  if (buf.includes(0)) return `${rel} (suspected-binary)`;
  const text = buf.toString('utf8');
  const hits = findSecretRules(text);
  if (hits.length === 0) return null;
  return `${rel} (${hits.join(',')})`;
}

function contentViolationFor(rel) {
  return contentViolationForWithRoot(rel, root);
}

// Fictitious samples are assembled at runtime so no continuous simulated
// secret literal is stored in the repo.
function buildFictitiousSamples() {
  return {
    pem: '-----' + 'BEGIN ' + 'RSA PRIVATE KEY' + '-----' + '\ntest-only-fictitious',
    sk: 's' + 'k-' + 'A'.repeat(32),
    ghp: 'gh' + 'p_' + 'a'.repeat(36),
    pat: 'github_' + 'pat_' + 'b'.repeat(22),
    aws: 'AK' + 'IA' + 'C'.repeat(16),
  };
}

test('publication candidates are non-empty and include .gitignore', () => {
  const candidates = listCandidates();
  assert.ok(candidates.length > 0, 'candidate list is empty');
  assert.ok(candidates.includes('.gitignore'), 'candidate list misses .gitignore');
});

test('candidates contain no local config, keys, or build outputs', () => {
  const bad = [];
  for (const rel of listCandidates()) {
    const rule = violationFor(rel);
    if (rule) bad.push(`${rel} (${rule})`);
  }
  assert.deepStrictEqual(bad, [], `forbidden candidates:\n${bad.join('\n')}`);
});

test('candidates do not link outside the project', () => {
  const rootReal = resolveRootReal();
  const problems = [];
  for (const rel of listCandidates()) {
    const abs = path.join(root, rel);
    let real = null;
    let failure = null;
    try {
      real = realpathSync(abs);
    } catch (err) {
      const kind = (err && (err.code || err.name)) || 'unknown';
      failure = `${rel} (unresolvable:${kind})`;
    }
    if (failure) {
      problems.push(failure);
    } else if (isResolvedOutsideRoot(real, rootReal)) {
      problems.push(`${rel} (outside-root)`);
    }
  }
  assert.deepStrictEqual(problems, [], `outside/unresolvable:\n${problems.join('\n')}`);
});

test('resolved boundary check works on sample paths', () => {
  const fakeRoot = path.resolve('fake-repo-root');
  assert.equal(isResolvedOutsideRoot(path.join(fakeRoot, 'entry', 'Index.ets'), fakeRoot), false);
  assert.equal(isResolvedOutsideRoot(fakeRoot, fakeRoot), false);
  assert.equal(isResolvedOutsideRoot(path.resolve(fakeRoot, '..', 'outside.txt'), fakeRoot), true);
  assert.equal(isResolvedOutsideRoot(`${fakeRoot}-other/file.txt`, fakeRoot), true);
});

test('deny/allow rules work on sample paths', () => {
  for (const p of [
    'entry/debug.p12',
    'Entry/Debug.P12',
    'cert/sign.PFX',
    'local.properties',
    'LOCAL.PROPERTIES',
    'entry/local.properties',
    '.env',
    '.ENV.local',
    '.env.local',
    'entry/build/output.txt',
    'BUILD/output.txt',
    'debug.HAP',
    'dist/app.har',
    '.asset_backup/icon.png',
    'HTML/index.html',
  ]) {
    assert.ok(violationFor(p), `should deny ${p}`);
  }
  for (const p of [
    'entry/src/main/ets/pages/Index.ets',
    'entry/src/main/resources/rawfile/pets/cat01.jpg',
    'entry/src/main/resources/rawfile/avatars/avatar01.jpg',
    'build-profile.json5',
    '.gitignore',
  ]) {
    assert.equal(violationFor(p), null, `should allow ${p}`);
  }
});

test('secret detector hits fictitious samples built at runtime', () => {
  const s = buildFictitiousSamples();
  assert.deepStrictEqual(findSecretRules(s.pem), ['pem-private-key']);
  assert.deepStrictEqual(findSecretRules(s.sk), ['sk-token']);
  assert.deepStrictEqual(findSecretRules(s.ghp), ['github-token']);
  assert.deepStrictEqual(findSecretRules(s.pat), ['github-token']);
  assert.deepStrictEqual(findSecretRules(s.aws), ['aws-access-key']);
});

test('secret detector ignores ordinary explanatory text and demo fields', () => {
  const benign = [
    'This page explains what an API Key is and how to request one.',
    'See help at https://example.com/docs for details.',
    'password: mock-demo-placeholder',
    'username: demo-user',
  ];
  for (const text of benign) {
    assert.deepStrictEqual(findSecretRules(text), [], `should not flag: ${text.slice(0, 24)}`);
  }
});

test('only self-drawn image extensions may skip content scan', () => {
  for (const p of [
    'a.jpg',
    'a.JPEG',
    'a.png',
    'a.webp',
    'a.gif',
    'a.ico',
  ]) {
    assert.equal(isSkippableImage(p), true, `should skip ${p}`);
  }
  for (const p of [
    'a.txt',
    'a.ets',
    'a.json5',
    'a.mp4',
    'a.ttf',
    'a.bin',
  ]) {
    assert.equal(isSkippableImage(p), false, `should scan ${p}`);
  }
});

test('content gate fails closed on boundary before any read', () => {
  // '..' always resolves (parent dir exists) and is outside the root, so this
  // deterministically exercises the outside-root branch without reading any
  // outside file content.
  const parentViolation = contentViolationFor('..');
  assert.ok(parentViolation, 'parent dir must fail');
  assert.match(parentViolation, /outside-root/);

  // Image extension must not bypass the boundary: if the skip ran before
  // realpath, this would return null. It must fail instead (unresolvable when
  // missing, outside-root when present) without reading the target.
  const evilJpg = contentViolationFor('../evil-boundary-probe.jpg');
  assert.ok(evilJpg, 'outside .jpg must not be skipped');
  assert.ok(evilJpg.startsWith('../evil-boundary-probe.jpg '));
  assert.match(evilJpg, /outside-root|unresolvable/);

  // Missing file inside the root must fail closed, never pass silently.
  const missing = contentViolationFor('__missing_boundary_probe__/no-such-file.txt');
  assert.ok(missing, 'missing file must fail');
  assert.match(missing, /unresolvable|unreadable/);

  // Root resolution is strict: no fallback to an unverified path.
  assert.equal(resolveRootReal(), realpathSync(root));
});

test('content gate root failure is fail closed', () => {
  const bogusRoot = path.join(root, '__missing_root_probe__');
  const v = contentViolationForWithRoot('anything.txt', bogusRoot);
  assert.ok(v, 'bogus root must fail');
  assert.match(v, /unresolvable-root:/);
  assert.ok(v.startsWith('anything.txt '));
});

test('candidates contain no high-confidence secret content', () => {
  const failures = [];
  for (const rel of listCandidates()) {
    const v = contentViolationFor(rel);
    if (v) failures.push(v);
  }
  assert.deepStrictEqual(failures, [], `suspect content:\n${failures.join('\n')}`);
});
