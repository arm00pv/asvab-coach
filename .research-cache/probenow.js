
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
(async()=>{
  const A=Math.floor(Date.parse('2024-01-01T00:00:00Z')/1000);
  const N=Math.floor(Date.now()/1000);
  const url='https://api.pullpush.io/reddit/search/comment/?q=asvab&subreddit=Militaryfaq&after='+A+'&before='+N+'&size=100&sort=desc&sort_type=created_utc';
  const t0=Date.now();
  const res=await fetch(url,{headers:{'User-Agent':'asvab-research/1.0'}});
  const txt=await res.text();
  console.log('status',res.status,'bytes',txt.length,'ms',Date.now()-t0);
  if(res.status===200){ const j=JSON.parse(txt); console.log('n=',j.data.length); }
})();
