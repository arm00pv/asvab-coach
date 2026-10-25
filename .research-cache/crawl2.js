
const fs=require('fs');
const D=process.argv[2];
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const AFTER=Math.floor(Date.parse('2024-01-01T00:00:00Z')/1000);
const STATE=D+'/state2.json';
const state = fs.existsSync(STATE) ? JSON.parse(fs.readFileSync(STATE,'utf8')) : {done:{}, comments:{}, subs:{}};
const C = fs.existsSync(D+'/c2_comments.json')? new Map(JSON.parse(fs.readFileSync(D+'/c2_comments.json','utf8')).map(x=>[x.id,x])) : new Map();
const S = fs.existsSync(D+'/c2_submissions.json')? new Map(JSON.parse(fs.readFileSync(D+'/c2_submissions.json','utf8')).map(x=>[x.id,x])) : new Map();

const SUBS=['Militaryfaq','army','newtothenavy','USMC','airforce','navy','Military','SpaceForce','MarineCorps','usmc'];
const QUERIES=['asvab','assembling objects','word knowledge','math knowledge','picat'];

function save(){
  fs.writeFileSync(D+'/c2_comments.json', JSON.stringify([...C.values()]));
  fs.writeFileSync(D+'/c2_submissions.json', JSON.stringify([...S.values()]));
  fs.writeFileSync(STATE, JSON.stringify(state));
}
async function get(url){
  for(let i=0;i<6;i++){
    try{
      const res=await fetch(url,{headers:{'User-Agent':'asvab-research/1.0','Accept':'application/json'}});
      if(res.status===200){ const t=await res.text(); try{return JSON.parse(t);}catch{return null;} }
      if(res.status===429){ const w=25000*(i+1); console.log('  429 backoff '+w+'ms'); await sleep(w); continue; }
      await sleep(8000);
    }catch(e){ await sleep(8000); }
  }
  return null;
}
(async()=>{
  for(const sub of SUBS){
    for(const kind of ['submission','comment']){
      for(const q of QUERIES){
        const key=kind+':'+sub+':'+q;
        if(state.done[key]) continue;
        let before=Math.floor(Date.now()/1000);
        const maxPages = kind==='comment'?6:4;
        for(let p=0;p<maxPages;p++){
          const url='https://api.pullpush.io/reddit/search/'+kind+'/?q='+encodeURIComponent(q)+'&subreddit='+sub+'&after='+AFTER+'&before='+before+'&size=100&sort=desc&sort_type=created_utc';
          const j=await get(url);
          if(!j||!Array.isArray(j.data)){ console.log('FAIL '+key+' p'+p); break; }
          const arr=j.data;
          if(!arr.length){ break; }
          for(const d of arr){
            const text=String(d.selftext!==undefined? d.selftext : d.body||'').replace(/\r/g,'').trim();
            if(!text||text.length<25) continue;
            const rec={id:d.id,sub:d.subreddit,created:new Date(d.created_utc*1000).toISOString().slice(0,10),
              author:d.author,score:d.score,title:d.title||'',permalink:d.permalink||'',
              link_id:d.link_id||'',text};
            (kind==='comment'?C:S).set(rec.id,rec);
          }
          const oldest=Math.min(...arr.map(d=>d.created_utc));
          console.log('OK '+key+' p'+p+' n='+arr.length+' oldest='+new Date(oldest*1000).toISOString().slice(0,10)+' C='+C.size+' S='+S.size);
          before=oldest-1;
          save();
          await sleep(6000);
          if(arr.length<100) break;
        }
        state.done[key]=true; save();
        await sleep(4000);
      }
    }
  }
  console.log('DONE C='+C.size+' S='+S.size);
})();
