
const fs=require('fs');
const D=process.argv[2];
const C=JSON.parse(fs.readFileSync(D+'/pp_comments.json','utf8'));
const S=JSON.parse(fs.readFileSync(D+'/pp_submissions.json','utf8'));
function cnt(arr){const m={};for(const x of arr){m[x.sub]=(m[x.sub]||0)+1;}return m;}
console.log('comments by sub', JSON.stringify(cnt(C)));
console.log('submissions by sub', JSON.stringify(cnt(S)));
const byYear=(arr)=>{const m={};for(const x of arr){const y=x.created.slice(0,4);m[y]=(m[y]||0)+1;}return m;};
console.log('comments by year', JSON.stringify(byYear(C)));
console.log('submissions by year', JSON.stringify(byYear(S)));
const lens=C.map(x=>x.text.length).sort((a,b)=>a-b);
console.log('comment len median', lens[Math.floor(lens.length/2)]);
const slens=S.map(x=>x.text.length).sort((a,b)=>a-b);
console.log('submission len median', slens[Math.floor(slens.length/2)]);
