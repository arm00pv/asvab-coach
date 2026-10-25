
const fs = require('fs');
const path = require('path');
const OUT = process.argv[2];
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';

const SUBS = ['army','Militaryfaq','nationalguard','newtothenavy','AirForceRecruits','USMC','airforce','navy','ArmyRecruiter','Military'];
const QUERIES = [
  'asvab experience',
  'took the asvab',
  'asvab harder than',
  'asvab assembling objects',
  'asvab practice test',
  'asvab score',
  'asvab math knowledge',
  'asvab word knowledge',
  'asvab tips adaptive',
  'piCAT asvab'
];

const sleep = ms => new Promise(r => setTimeout(r, ms));

async function get(url, tries = 4) {
  for (let i = 0; i < tries; i++) {
    try {
      const res = await fetch(url, { headers: { 'User-Agent': UA, 'Accept': 'application/json' } });
      if (res.status === 200) {
        const t = await res.text();
        if (t.startsWith('{')) return JSON.parse(t);
        // HTML block page
        if (i === tries - 1) return { __html: t.slice(0, 400) };
      } else if (res.status === 429 || res.status === 503) {
        await sleep(8000 * (i + 1));
        continue;
      } else {
        if (i === tries - 1) return { __status: res.status };
        await sleep(4000 * (i + 1));
        continue;
      }
    } catch (e) {
      if (i === tries - 1) return { __err: String(e).slice(0, 200) };
      await sleep(4000 * (i + 1));
    }
  }
}

function clean(s) {
  if (!s) return '';
  return s.replace(/\r/g, '').trim();
}

(async () => {
  const posts = new Map();
  const log = [];
  for (const sub of SUBS) {
    for (const q of QUERIES) {
      const url = 'https://old.reddit.com/r/' + sub + '/search.json?q=' + encodeURIComponent(q) +
        '&restrict_sr=1&sort=relevance&limit=50&t=all&include_over_18=on';
      const j = await get(url);
      let n = 0;
      if (j && j.data && Array.isArray(j.data.children)) {
        for (const c of j.data.children) {
          const d = c.data;
          if (!d) continue;
          const created = d.created_utc * 1000;
          if (created < Date.parse('2024-01-01')) continue;
          const id = d.id;
          if (!posts.has(id)) {
            posts.set(id, {
              id, sub: d.subreddit, title: d.title, created: new Date(created).toISOString().slice(0,10),
              score: d.score, num_comments: d.num_comments, permalink: d.permalink,
              selftext: clean(d.selftext).slice(0, 6000), matched: [q]
            });
          } else { posts.get(id).matched.push(q); }
          n++;
        }
      }
      log.push(sub + ' | ' + q + ' | +' + n + ' | total=' + posts.size + (j && j.__status ? ' | status=' + j.__status : '') + (j && j.__html ? ' | HTMLBLOCK' : ''));
      console.log(log[log.length-1]);
      await sleep(2200);
    }
  }
  const arr = [...posts.values()].sort((a,b) => a.created < b.created ? 1 : -1);
  fs.writeFileSync(path.join(OUT, 'posts.json'), JSON.stringify(arr, null, 1));
  console.log('DONE posts=' + arr.length);
})();
