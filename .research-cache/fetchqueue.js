
const fs=require('fs');
const D=process.argv[2];
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const MIRROR='https://reddit.synth.download';
const q=JSON.parse(fs.readFileSync(D+'/fetch_queue.json','utf8'));
async function jina(u){
  for(let i=0;i<2;i++){
    try{
      const res=await fetch('https://r.jina.ai/'+encodeURIComponent(u),{headers:{'User-Agent':'Mozilla/5.0','Accept':'text/plain'}});
      if(res.status===200){ const t=await res.text(); if(t.length>600) return t; }
      await sleep(5000);
    }catch(e){ await sleep(5000); }
  }
  return null;
}
(async()=>{
  fs.mkdirSync(D+'/threads2',{recursive:true});
  let n=0;
  for(const {id,sub} of q){
    const f=D+'/threads2/'+id+'.md';
    if(fs.existsSync(f)) continue;
    const md=await jina(MIRROR+'/r/'+sub+'/comments/'+id+'/');
    if(md){ fs.writeFileSync(f,md); n++; }
    if(n%10===0) console.log('fetched '+n+' last='+id);
    await sleep(3000);
  }
  console.log('DONE fetched='+n);
})();
