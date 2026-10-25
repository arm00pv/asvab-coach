
const fs=require('fs');const path=require('path');
const D=process.argv[2];
const files=fs.readdirSync(D).filter(f=>/^srch_?2?_.*\.md$/.test(f)).concat(fs.readdirSync(D+'/srch3').map(f=>'srch3/'+f));
const out=[];
for(const f of files){
  const md=fs.readFileSync(path.join(D,f),'utf8');
  out.push('===== '+f+' =====');
  const lines=md.split('\n');
  for(let i=0;i<lines.length;i++){
    const l=lines[i];
    const idm=l.match(/comments\/([a-z0-9]{5,8})\//);
    if(!idm) continue;
    const tm=l.match(/\)\s*\[([^\]]{6,})\]/) || l.match(/\[([^\]]{6,})\]\(https:\/\/reddit\.synth\.download\/r\/[A-Za-z0-9_]+\/comments/);
    if(tm) out.push(idm[1]+' | '+tm[1]);
  }
}
fs.writeFileSync(D+'/all_titles.txt',out.join('\n'));
console.log('lines '+out.length);
