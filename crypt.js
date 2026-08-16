// crypt.js — 给 Jekyll 文章正文做口令加密的本地小工具。
//
// 加密/解密逻辑与 _includes/encrypted-post.html 里的代码逐字相同，
// 只使用浏览器同款 Web Crypto API（crypto.subtle / atob / btoa / TextEncoder），
// 不使用 node:crypto。Node 只负责文件读写和口令输入。需要 Node 18+。
//
// 用法：
//   node crypt.js encrypt _posts/2026-08-16-my-post.md    （交互式输口令，加密后正文清空、密文写入 cipher 字段）
//   node crypt.js decrypt _posts/2026-08-16-my-post.md    （还原成明文 Markdown，便于编辑）
//   追加 -p <口令> 可跳过交互（供脚本/测试用；口令会留在 shell 历史里）
//
// 注意：编辑期间（解密状态）不要 commit；文件名 `YYYY-MM-DD-slug.md` 缺 title 时
// 会自动生成（去日期前缀、-/_ 转空格、英文单词首字母大写，中文原样）。

'use strict';

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// ---- enc core: keep byte-identical with _includes/encrypted-post.html ----
var ENC_ITER = 150000;

function b64uToBytes(s) {
  s = s.replace(/-/g, '+').replace(/_/g, '/');
  while (s.length % 4) s += '=';
  var bin = atob(s);
  var bytes = new Uint8Array(bin.length);
  for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return bytes;
}

function bytesToB64u(bytes) {
  var bin = '';
  for (var i = 0; i < bytes.length; i++) bin += String.fromCharCode(bytes[i]);
  return btoa(bin).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

async function deriveKey(password, salt, iter) {
  var mat = await crypto.subtle.importKey(
    'raw', new TextEncoder().encode(password), 'PBKDF2', false, ['deriveKey']);
  return crypto.subtle.deriveKey(
    { name: 'PBKDF2', hash: 'SHA-256', salt: salt, iterations: iter },
    mat, { name: 'AES-GCM', length: 256 }, false, ['encrypt', 'decrypt']);
}

async function encryptText(password, text, iter) {
  iter = iter || ENC_ITER;
  var salt = crypto.getRandomValues(new Uint8Array(16));
  var iv = crypto.getRandomValues(new Uint8Array(12));
  var key = await deriveKey(password, salt, iter);
  var ct = new Uint8Array(await crypto.subtle.encrypt(
    { name: 'AES-GCM', iv: iv }, key, new TextEncoder().encode(text)));
  return 'ENC1.' + bytesToB64u(salt) + '.' + bytesToB64u(iv) + '.' + bytesToB64u(ct);
}

async function decryptText(password, envelope, iter) {
  iter = iter || ENC_ITER;
  var parts = envelope.trim().split('.');
  if (parts.length !== 4 || parts[0] !== 'ENC1') throw new Error('bad envelope');
  var key = await deriveKey(password, b64uToBytes(parts[1]), iter);
  var pt = await crypto.subtle.decrypt(
    { name: 'AES-GCM', iv: b64uToBytes(parts[2]) }, key, b64uToBytes(parts[3]));
  return new TextDecoder().decode(pt);
}
// ---- end enc core ----

function die(msg) {
  console.error(msg);
  process.exit(1);
}

// 把文件拆成 front matter 行数组 + 正文
function splitFile(raw) {
  raw = raw.replace(/^\uFEFF/, '');
  var m = raw.match(/^---\r?\n([\s\S]*?)\r?\n---[ \t]*(?:\r?\n|$)/);
  if (!m) return { fmLines: [], body: raw };
  return { fmLines: m[1] ? m[1].split(/\r?\n/) : [], body: raw.slice(m[0].length) };
}

function fmGet(lines, key) {
  var re = new RegExp('^' + key + ':\\s*(.*)$');
  for (var i = 0; i < lines.length; i++) {
    var m = lines[i].match(re);
    if (m) return m[1].trim();
  }
  return undefined;
}

function fmSet(lines, key, value) {
  var re = new RegExp('^' + key + ':');
  for (var i = 0; i < lines.length; i++) {
    if (re.test(lines[i])) { lines[i] = key + ': ' + value; return; }
  }
  lines.push(key + ': ' + value);
}

function fmRemove(lines, key) {
  var re = new RegExp('^' + key + ':');
  return lines.filter(function (l) { return !re.test(l); });
}

function titleFromFilename(file) {
  var base = path.basename(file).replace(/\.(md|markdown|html)$/i, '');
  base = base.replace(/^\d{4}-\d{2}-\d{2}-/, '');
  return base.split(/[-_]+/).filter(Boolean).map(function (w) {
    return /^[a-z]/.test(w) ? w.charAt(0).toUpperCase() + w.slice(1) : w;
  }).join(' ');
}

async function doEncrypt(file, password) {
  var raw = fs.readFileSync(file, 'utf8');
  var parts = splitFile(raw);
  if (fmGet(parts.fmLines, 'cipher') !== undefined) {
    die('该文件已有 cipher 字段（已加密）。请先 decrypt 再重新加密。');
  }
  var body = parts.body.replace(/\r\n/g, '\n').trim();
  if (!body) die('正文为空，没有可加密的内容。');
  if (fmGet(parts.fmLines, 'layout') === undefined) fmSet(parts.fmLines, 'layout', 'post');
  if (fmGet(parts.fmLines, 'title') === undefined) fmSet(parts.fmLines, 'title', titleFromFilename(file));
  var envelope = await encryptText(password, body);
  fmSet(parts.fmLines, 'cipher', envelope);
  fs.writeFileSync(file, '---\n' + parts.fmLines.join('\n') + '\n---\n', 'utf8');
  console.log('已加密: ' + file);
}

async function doDecrypt(file, password) {
  var raw = fs.readFileSync(file, 'utf8');
  var parts = splitFile(raw);
  var cipher = fmGet(parts.fmLines, 'cipher');
  if (cipher === undefined) die('未找到 cipher 字段，该文件似乎不是加密文章。');
  var body;
  try {
    body = await decryptText(password, cipher);
  } catch (e) {
    die('口令错误或数据损坏。');
  }
  var lines = fmRemove(parts.fmLines, 'cipher');
  fs.writeFileSync(file, '---\n' + lines.join('\n') + '\n---\n\n' + body + '\n', 'utf8');
  console.log('已解密: ' + file);
}

function askHidden(question) {
  return new Promise(function (resolve) {
    var rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    rl.question(question, function (answer) {
      rl.close();
      process.stdout.write('\n');
      resolve(answer);
    });
    rl.stdoutMuted = true;
    rl._writeToOutput = function (s) {
      if (!rl.stdoutMuted || /^[\r\n]+$/.test(s)) rl.output.write(s);
      else rl.output.write('*');
    };
  });
}

async function main() {
  if (!globalThis.crypto || !globalThis.crypto.subtle) {
    die('当前 Node 没有全局 Web Crypto，请使用 Node 18+。');
  }
  var argv = process.argv.slice(2);
  var cmd = argv[0];
  var file = argv[1];
  var pIdx = argv.indexOf('-p');
  var pFlag = pIdx !== -1 ? argv[pIdx + 1] : null;
  if ((cmd !== 'encrypt' && cmd !== 'decrypt') || !file || (pIdx !== -1 && !pFlag)) {
    die('用法:\n  node crypt.js encrypt <post.md> [-p 口令]\n  node crypt.js decrypt <post.md> [-p 口令]');
  }
  if (!fs.existsSync(file)) die('文件不存在: ' + file);

  var password = pFlag;
  if (!password) {
    if (!process.stdin.isTTY) die('非交互终端，请用 -p <口令> 传入。');
    password = await askHidden('口令: ');
    if (cmd === 'encrypt') {
      var again = await askHidden('确认口令: ');
      if (again !== password) die('两次输入的口令不一致。');
    }
  }

  if (cmd === 'encrypt') await doEncrypt(file, password);
  else await doDecrypt(file, password);
}

main().catch(function (e) { die(e.stack || String(e)); });
