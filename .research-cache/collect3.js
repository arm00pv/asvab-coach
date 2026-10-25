
const fs=require('fs');
const D=process.argv[2];
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
const MIRROR='https://reddit.synth.download';
async function jina(u){
  for(let i=0;i<3;i++){
    try{
      const res=await fetch('https://r.jina.ai/'+encodeURIComponent(u),{headers:{'User-Agent':'Mozilla/5.0','Accept':'text/plain'}});
      if(res.status===200) return await res.text();
      await sleep(6000*(i+1));
    }catch(e){ await sleep(6000*(i+1)); }
  }
  return null;
}
const SEARCHES=[
 ['ASVAB','word%20knowledge&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','math%20knowledge&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','assembling%20objects&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','auto%20and%20shop&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','general%20science&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','mechanical%20comprehension&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','took%20the%20asvab%20today&restrict_sr=on&sort=new&t=all'],
 ['ASVAB','harder&restrict_sr=on&sort=new&t=all'],
 ['ASVAB','time&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','gt%20score&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','retest&restrict_sr=on&sort=new&t=all'],
 ['ASVAB','adaptive&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','easier&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','electronics&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','paragraph%20comprehension&restrict_sr=on&sort=relevance&t=all']
];
(async()=>{
  fs.mkdirSync(D+'/srch3',{recursive:true});
  for(const [sub,qs] of SEARCHES){
    const tag=qs.slice(0,10).replace(/[^a-z0-9]/gi,'');
    const f=D+'/srch3/'+sub+'_'+tag+'.md';
    if(fs.existsSync(f)){ console.log('skip '+tag); continue; }
    const md=await jina(MIRROR+'/r/'+sub+'/search?q='+qs);
    if(md) fs.writeFileSync(f,md);
    console.log('SEARCH '+tag+' -> '+(md?md.length:0));
    await sleep(3000);
  }
  console.log('DONE');
})();
