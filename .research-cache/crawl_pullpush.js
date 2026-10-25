
const fs = require('fs');
const OUT = process.argv[2];
const SUBS = ['army','Militaryfaq','nationalguard','newtothenavy','AirForceRecruits','USMC','airforce','navy','Military','ArmyRecruiter','SpaceForce','MilitarySpouse'];
const AFTER = Math.floor(Date.parse('2024-01-01T00:00:00Z') / 1000);
const sleep = ms => new Promise(r => setTimeout(r, ms));

async function get(url, tries = 3) {
  for (let i = 0; i < tries; i++) {
    try {
      const res = await fetch(url, { headers: { 'User-Agent': 'asvab-research/1.0', 'Accept': 'application/json' } });
      if (res.status === 200) {
        const t = await res.text();
        try { return JSON.parse(t); } catch { return null; }
      }
      await sleep(3000 * (i + 1));
    } catch (e) { await sleep(3000 * (i + 1)); }
  }
  return null;
}

(async () => {
  const comments = new Map();
  const subs2 = new Map();
  const stats = [];
  for (const sub of SUBS) {
    for (const kind of ['comment', 'submission']) {
      let before = Math.floor(Date.now() / 1000);
      const pages = kind === 'comment' ? 6 : 3;
      for (let p = 0; p < pages; p++) {
        const url = 'https://api.pullpush.io/reddit/search/' + kind + '/?q=asvab&subreddit=' + sub +
          '&after=' + AFTER + '&before=' + before + '&size=100&sort=desc&sort_type=created_utc';
        const j = await get(url);
        const arr = (j && j.data) || [];
        if (!arr.length) break;
        for (const d of arr) {
          const rec = {
            id: d.id, sub: d.subreddit, created: new Date(d.created_utc * 1000).toISOString().slice(0, 10),
            author: d.author, score: d.score,
            title: d.title || '', text: String(d.selftext || d.body || '').replace(/\r/g,'').trim()
          };
          if (!rec.text || rec.text.length < 20) continue;
          (kind === 'comment' ? comments : subs2).set(rec.id, rec);
        }
        const oldest = Math.min(...arr.map(d => d.created_utc));
        stats.push(kind + ' ' + sub + ' p' + p + ' n=' + arr.length + ' oldest=' + new Date(oldest*1000).toISOString().slice(0,10));
        console.log(stats[stats.length - 1]);
        before = oldest - 1;
        await sleep(1200);
        if (arr.length < 100) break;
      }
    }
  }
  fs.writeFileSync(OUT + '/pp_comments.json', JSON.stringify([...comments.values()]));
  fs.writeFileSync(OUT + '/pp_submissions.json', JSON.stringify([...subs2.values()]));
  console.log('DONE comments=' + comments.size + ' submissions=' + subs2.size);
})();
