
const fs=require('fs');
const UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
function strip(s){return s.replace(/<[^>]+>/g,'').replace(/&amp;/g,'&').replace(/&#x27;/g,"'").replace(/&quot;/g,'"').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/\s+/g,' ').trim();}
async function ddg(q){
  const u='https://html.duckduckgo.com/html/?q='+encodeURIComponent(q);
  for(let i=0;i<3;i++){
    try{
      const res=await fetch(u,{headers:{'User-Agent':UA,'Accept-Language':'en-US,en;q=0.9'}});
      if(res.status!==200){await sleep(4000);continue;}
      const html=await res.text();
      const out=[];
      const re=/<a rel="nofollow" class="result__a" href="([^"]+)"[^>]*>([\s\S]*?)<\/a>[\s\S]*?<a class="result__snippet"[^>]*>([\s\S]*?)<\/a>/g;
      let m;
      while((m=re.exec(html))){
        let href=m[1];
        const uu=href.match(/uddg=([^&]+)/); if(uu) href=decodeURIComponent(uu[1]);
        out.push({url:href,title:strip(m[2]),snippet:strip(m[3])});
      }
      return out;
    }catch(e){await sleep(4000);}
  }
  return [];
}
(async()=>{
  const q=process.argv[3]||'site:reddit.com asvab "assembling objects"';
  const r=await ddg(q);
  console.log('n='+r.length);
  for(const it of r) console.log('- '+it.title+' :: '+it.url+'\n    '+it.snippet);
})();
