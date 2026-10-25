
const fs=require('fs');const path=require('path');
const D=process.argv[2];
const T=D+'/threads';
const files=fs.readdirSync(T).filter(f=>f.endsWith('.md'));
const out=[];
for(const f of files){
  const md=fs.readFileSync(path.join(T,f),'utf8');
  const lines=md.split('\n');
  const keep=[];
  let started=false;
  for(let l of lines){
    if(/^# /.test(l)) started=true;
    if(!started) continue;
    if(/You are about to leave Redlib|go back!|take me to Reddit|reddit\.synth\.download\/settings|Code\]\(https:\/\/github|v0\.36|instance info/i.test(l)) continue;
    if(/^\[!\[Image/.test(l)) continue;
    keep.push(l
      .replace(/\(https:\/\/reddit\.synth\.download[^)]*\)/g,'')
      .replace(/\[([^\]]*)\]\([^)]*\)/g,'$1')
      .replace(/\s+/g,' ')
      .trim());
  }
  out.push('\n\n########## '+f+' ##########\n'+keep.filter(Boolean).join('\n'));
}
fs.writeFileSync(D+'/threads_clean.txt',out.join('\n'));
console.log('files='+files.length+' bytes='+out.join('').length);
