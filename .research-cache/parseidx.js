
const fs=require('fs');const path=require('path');
const D=process.argv[2];
const files=fs.readdirSync(D).filter(f=>/^srch_.*\.md$/.test(f));
const out=[];
for(const f of files){
  const md=fs.readFileSync(path.join(D,f),'utf8');
  const lines=md.split('\n');
  for(let i=0;i<lines.length;i++){
    const m=lines[i].match(/^##\s*\[([^\]]*)\]\(https:\/\/reddit\.synth\.download\/r\/([A-Za-z0-9_]+)\/comments\/([a-z0-9]+)\/([^)]*)\)/);
    if(m){
      // capture next few lines as preview
      let preview='';
      for(let k=i+1;k<Math.min(i+8,lines.length);k++){ const t=lines[k].trim(); if(t && !/^\d+\s+Upvotes$/.test(t)){ preview=t.slice(0,300); break; } }
      let date='';
      for(let k=i;k<Math.min(i+12,lines.length);k++){ const dm=lines[k].match(/\[([A-Z][a-z]{2} \d{1,2} '?\d{2,4})\]\(/); if(dm){date=dm[1];break;} }
      out.push({file:f,flair:m[1],sub:m[2],id:m[3],slug:m[4],preview,date});
    }
  }
}
fs.writeFileSync(D+'/threads_titled.json',JSON.stringify(out,null,1));
console.log('threads='+out.length);
