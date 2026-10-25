
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
 ['ASVAB','assembling%20objects&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','practice%20test%20easier&restrict_sr=on&sort=relevance&t=all'],
 ['ASVAB','harder%20than&restrict_sr=on&sort=relevance&t=all'],
 ['Militaryfaq','assembling%20objects&restrict_sr=on&sort=relevance&t=year'],
 ['Militaryfaq','harder%20than%20practice&restrict_sr=on&sort=relevance&t=year'],
 ['army','asvab%20practice%20test&restrict_sr=on&sort=relevance&t=year']
];
const FETCH=['1x5ckj2','1x7xvs8','1wmccjj','1wyvd87','1wgbi3j','1vsqzdx','1w163p9','1xa9pvn','1v5liyl','1w7lav4','1w3l3gt','1xbz45j','1x77f7q','1xb4d56','1wq3qpz','1wt0c5z','1wwcaid','1x73ksl','1w4ip2g','1vrcvoy','1x4zqlu','1w163p9','1x2reg8','1x7agzl'];
const SUBSLUG={
 '1x5ckj2':'ASVAB','1x7xvs8':'ASVAB','1wmccjj':'ASVAB','1wyvd87':'ASVAB','1wgbi3j':'ASVAB','1vsqzdx':'ASVAB',
 '1w163p9':'ASVAB','1xa9pvn':'Militaryfaq','1v5liyl':'AirForceRecruits','1w7lav4':'ASVAB','1w3l3gt':'ASVAB',
 '1xbz45j':'newtothenavy','1x77f7q':'newtothenavy','1xb4d56':'ASVAB','1wq3qpz':'ASVAB','1wt0c5z':'ASVAB',
 '1wwcaid':'ASVAB','1x73ksl':'ASVAB','1w4ip2g':'ASVAB','1vrcvoy':'ASVAB','1x4zqlu':'ASVAB','1x2reg8':'newtothenavy','1x7agzl':'newtothenavy'
};
(async()=>{
  fs.mkdirSync(D+'/threads',{recursive:true});
  for(const [sub,qs] of SEARCHES){
    const md=await jina(MIRROR+'/r/'+sub+'/search?q='+qs);
    console.log('SEARCH '+sub+' '+qs.slice(0,30)+' -> '+(md?md.length:0));
    if(md) fs.writeFileSync(D+'/srch2_'+sub+'_'+qs.slice(0,8).replace(/[^a-z0-9]/gi,'')+'.md',md);
    await sleep(3500);
  }
  for(const id of [...new Set(FETCH)]){
    const f=D+'/threads/'+id+'.md';
    if(fs.existsSync(f)){ console.log('skip '+id); continue; }
    const sub=SUBSLUG[id]||'Militaryfaq';
    const md=await jina(MIRROR+'/r/'+sub+'/comments/'+id+'/');
    if(md){ fs.writeFileSync(f,md); console.log('OK '+id+' '+md.length); } else console.log('FAIL '+id);
    await sleep(3500);
  }
  console.log('DONE');
})();
