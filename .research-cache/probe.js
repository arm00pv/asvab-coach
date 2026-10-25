
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
async function t(url,label){
  const t0=Date.now();
  try{
    const c=new AbortController();
    const res=await fetch(url,{headers:{'User-Agent':'asvab-research/1.0'},signal:c.signal});
    const txt=await res.text();
    let n=-1, oldest='';
    try{const j=JSON.parse(txt); n=(j.data||[]).length; if(n) oldest=new Date(Math.min(...j.data.map(d=>d.created_utc))*1000).toISOString().slice(0,10);}catch(e){}
    console.log(label+' status='+res.status+' bytes='+txt.length+' n='+n+' oldest='+oldest+' ms='+(Date.now()-t0));
  }catch(e){ console.log(label+' ERR '+String(e).slice(0,160)+' ms='+(Date.now()-t0)); }
}
(async()=>{
  const A=Math.floor(Date.parse('2024-01-01T00:00:00Z')/1000);
  const N=Math.floor(Date.now()/1000);
  await t('https://api.pullpush.io/reddit/search/comment/?q=asvab&subreddit=army&after='+A+'&before='+N+'&size=25&sort=desc&sort_type=created_utc','army-c25');
  await sleep(1500);
  await t('https://api.pullpush.io/reddit/search/comment/?q=asvab&subreddit=Militaryfaq&after='+A+'&before='+N+'&size=25&sort=desc&sort_type=created_utc','milfaq-c25');
  await sleep(1500);
  await t('https://api.pullpush.io/reddit/search/submission/?q=asvab&subreddit=Militaryfaq&after='+A+'&before='+N+'&size=25&sort=desc&sort_type=created_utc','milfaq-s25');
})();
