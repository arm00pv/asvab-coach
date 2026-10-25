
const fs=require('fs'), path=require('path');
const D=process.argv[2];
const files=fs.readdirSync(D+'/srch3').filter(f=>f.endsWith('.md'));
const out=[];
for(const f of files){
  const md=fs.readFileSync(path.join(D+'/srch3',f),'utf8');
  const lines=md.split('\n');
  out.push('===== '+f+' =====');
  for(let i=0;i<lines.length;i++){
    const m=lines[i].match(/^##\s*\[([^\]]*)\]\(https:\/\/reddit\.synth\.download\/r\/([A-Za-z0-9_]+)\/comments\/([a-z0-9]+)\/([^)]*)\)/);
    if(m){
      let preview='';
      for(let k=i+1;k<Math.min(i+9,lines.length);k++){ const t=lines[k].trim(); if(t && !/^\d+\s+Upvotes$/.test(t) && !t.startsWith('[')) { preview=t.slice(0,220); break; } }
      out.push(m[3]+' | '+m[1]+' | '+preview.replace(/\n/g,' '));
    }
  }
}
fs.writeFileSync(D+'/srch3_titles.txt',out.join('\n'));
console.log('lines='+out.length);
