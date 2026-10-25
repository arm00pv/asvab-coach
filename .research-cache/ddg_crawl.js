
const fs=require('fs');
const OUT=process.argv[2];
const UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
function strip(s){return s.replace(/<[^>]+>/g,'').replace(/&amp;/g,'&').replace(/&#x27;/g,"'").replace(/&quot;/g,'"').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/\s+/g,' ').trim();}
async function ddg(q){
  const u='https://html.duckduckgo.com/html/?q='+encodeURIComponent(q);
  for(let i=0;i<3;i++){
    try{
      const res=await fetch(u,{headers:{'User-Agent':UA,'Accept-Language':'en-US,en;q=0.9'}});
      if(res.status!==200){await sleep(5000);continue;}
      const html=await res.text();
      const out=[];
      const re=/<a rel="nofollow" class="result__a" href="([^"]+)"[^>]*>([\s\S]*?)<\/a>[\s\S]*?<a class="result__snippet"[^>]*>([\s\S]*?)<\/a>/g;
      let m;
      while((m=re.exec(html))){
        let href=m[1];
        const uu=href.match(/uddg=([^&]+)/); if(uu) href=decodeURIComponent(uu[1]);
        if(href.includes('duckduckgo.com/y.js')) continue;
        out.push({url:href,title:strip(m[2]),snippet:strip(m[3])});
      }
      return out;
    }catch(e){await sleep(5000);}
  }
  return [];
}
const Q=[
 'site:reddit.com "took the asvab" 2025 experience harder',
 'site:reddit.com asvab 2026 experience what was on it',
 'site:reddit.com asvab "assembling objects" was easy',
 'site:reddit.com asvab "assembling objects" brutal',
 'site:reddit.com asvab word knowledge "words I" never heard',
 'site:reddit.com asvab math knowledge "mostly algebra"',
 'site:reddit.com asvab "ran out of time" arithmetic reasoning',
 'site:reddit.com asvab adaptive "kept getting harder"',
 'site:reddit.com asvab practice test "way easier" than real',
 'site:reddit.com picat asvab harder 2025',
 'site:reddit.com asvab "auto and shop" studied nothing',
 'site:reddit.com asvab "general science" questions surprised',
 'site:reddit.com asvab paragraph comprehension short passages',
 'site:reddit.com asvab electronics information hard',
 'site:reddit.com asvab mechanical comprehension pulleys gears',
 'site:reddit.com asvab retest score improved studying',
 'site:reddit.com asvab "GT score" studied how long',
 'site:quora.com ASVAB "assembling objects"',
 'site:quora.com "I took the ASVAB" what questions',
 'site:youtube.com ASVAB 2025 experience questions comments',
 'ASVAB experience 2025 blog recruit "what to expect" harder',
 'ASVAB test 2026 changes adaptive harder article'
];
(async()=>{
  const all={};
  for(const q of Q){
    const r=await ddg(q);
    all[q]=r;
    console.log(q+' => '+r.length);
    await sleep(2500);
  }
  fs.writeFileSync(OUT+'/ddg.json',JSON.stringify(all,null,1));
  console.log('DONE');
})();
