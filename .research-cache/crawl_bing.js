
const fs = require('fs');
const OUT = process.argv[2];
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';
const sleep = ms => new Promise(r => setTimeout(r, ms));

function strip(s){ return s.replace(/<[^>]+>/g,'').replace(/&amp;/g,'&').replace(/&#39;/g,"'").replace(/&quot;/g,'"').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/\s+/g,' ').trim(); }

async function bing(q){
  const u = 'https://www.bing.com/search?q=' + encodeURIComponent(q) + '&count=30&setlang=en-US&cc=US';
  for (let i=0;i<3;i++){
    try{
      const res = await fetch(u, { headers: { 'User-Agent': UA, 'Accept-Language':'en-US,en;q=0.9' } });
      if (res.status!==200){ await sleep(3000); continue; }
      const html = await res.text();
      const out=[];
      const re = /<li class="b_algo"[\s\S]*?<\/li>/g;
      let m;
      while((m=re.exec(html))){
        const b=m[0];
        const t=(b.match(/<h2[\s\S]*?<\/h2>/)||[''])[0];
        const h=(b.match(/<a[^>]+href="(http[^"]+)"/)||[])[1]||'';
        const p=(b.match(/<p[^>]*>([\s\S]*?)<\/p>/)||[])[1]||'';
        if(h) out.push({title:strip(t),url:h,snippet:strip(p)});
      }
      return out;
    }catch(e){ await sleep(3000); }
  }
  return [];
}

const QUERIES = [
  'site:reddit.com asvab "assembling objects" hardest',
  'site:reddit.com "took the asvab" 2026 experience',
  'site:reddit.com asvab "harder than" practice test',
  'site:reddit.com asvab word knowledge words',
  'site:reddit.com asvab "ran out of time"',
  'site:reddit.com asvab math knowledge algebra',
  'site:reddit.com asvab adaptive got harder',
  'site:reddit.com asvab "auto and shop"',
  'site:reddit.com asvab electronics information',
  'site:reddit.com asvab mechanical comprehension levers',
  'site:reddit.com picat vs asvab harder',
  'site:reddit.com asvab "ASVAB for dummies" helped score',
  'asvab experience blog "I took the ASVAB" 2025 recruit',
  'ASVAB 2026 harder than before article test changes',
  'youtube asvab test experience what was on it',
  'quora "I took the ASVAB" math questions what was on it',
  'site:reddit.com asvab paragraph comprehension',
  'site:reddit.com asvab general science questions'
];

(async()=>{
  const all={};
  for(const q of QUERIES){
    const r = await bing(q);
    all[q]=r;
    console.log(q+' => '+r.length);
    await sleep(1500);
  }
  fs.writeFileSync(OUT+'/bing.json', JSON.stringify(all,null,1));
  console.log('DONE');
})();
