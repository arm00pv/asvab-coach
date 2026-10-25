
const fs=require('fs');
const D=process.argv[2];
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const MIRROR='https://reddit.synth.download';
async function jina(u){
  for(let i=0;i<3;i++){
    try{
      const res=await fetch('https://r.jina.ai/'+encodeURIComponent(u),{headers:{'User-Agent':'Mozilla/5.0','Accept':'text/plain'}});
      if(res.status===200) return await res.text();
      await sleep(5000);
    }catch(e){ await sleep(5000); }
  }
  return null;
}
const SEARCHES=[
 ['Militaryfaq','flair_name%3A%22ASVAB%2FPiCAT%22&restrict_sr=on&sort=new&t=all'],
 ['Militaryfaq','asvab&restrict_sr=on&sort=relevance&t=year'],
 ['army','asvab&restrict_sr=on&sort=new&t=year'],
 ['newtothenavy','asvab&restrict_sr=on&sort=new&t=year'],
 ['AirForceRecruits','asvab&restrict_sr=on&sort=new&t=year'],
 ['USMC','asvab&restrict_sr=on&sort=new&t=year'],
 ['nationalguard','asvab&restrict_sr=on&sort=new&t=year'],
 ['asvab','asvab&restrict_sr=on&sort=new&t=all']
];
function parse(md){
  const found=[];
  const re=/\]\((https:\/\/reddit\.synth\.download\/r\/([A-Za-z0-9_]+)\/comments\/([a-z0-9]+)\/([^)]*?))\)/g;
  let m;
  while((m=re.exec(md))){
    if(!found.some(f=>f.id===m[3])) found.push({url:m[1],sub:m[2],id:m[3],slug:m[4]});
  }
  return found;
}
(async()=>{
  const all=new Map();
  for(const [sub,qs] of SEARCHES){
    const base=MIRROR+'/r/'+sub+'/search?q='+qs;
    const md=await jina(base);
    const n=md?parse(md).length:0;
    console.log('SEARCH r/'+sub+' '+qs.slice(0,40)+' -> '+(md?md.length:0)+' bytes, '+n+' links');
    if(md){
      fs.writeFileSync(D+'/srch_'+sub+'_'+qs.slice(0,10).replace(/[^a-z0-9]/gi,'')+'.md', md);
      for(const f of parse(md)) if(!all.has(f.id)) all.set(f.id,f);
    }
    await sleep(4000);
  }
  fs.writeFileSync(D+'/thread_index.json',JSON.stringify([...all.values()],null,1));
  console.log('TOTAL threads indexed: '+all.size);
})();
