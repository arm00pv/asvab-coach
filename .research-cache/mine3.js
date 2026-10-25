
const fs=require('fs'),path=require('path');
const D=process.argv[2];
const pats={
 AOTYPE:/connect(ing)? (the )?(dots|lines)|labeled|letters? (on|next to) the|draw lines|which piece|two (types|kinds) of|fit together|doesn.t fit/i,
 PACING2:/minutes? (left|remaining)|per question|time (per|each)|finish(ed)? (early|with)|guessed on|rushed|half the time/i,
 DIFF:/harder than (i|I) expected|harder than expected|easier than (i|I) expected|way harder|not that hard|surprisingly/i
};
const docs=[];
for(const dd of ['threads','threads2']){
  const p=path.join(D,dd); if(!fs.existsSync(p))continue;
  for(const f of fs.readdirSync(p).filter(f=>f.endsWith('.md'))){
    let md=fs.readFileSync(path.join(p,f),'utf8');
    md=md.replace(/\(https:\/\/reddit\.synth\.download[^)]*\)/g,'').replace(/\[([^\]]*)\]\([^)]*\)/g,'$1').replace(/\s+/g,' ');
    docs.push({id:f.replace('.md',''),txt:md});
  }
}
const out=[];
for(const k of Object.keys(pats)){
  out.push('##### '+k+' #####');
  for(const d of docs){
    const m=d.txt.match(pats[k]); if(!m) continue;
    const i=m.index||0;
    out.push('['+d.id+'] '+d.txt.slice(Math.max(0,i-220), i+380));
    out.push('');
  }
}
fs.writeFileSync(D+'/excerpts_x.txt',out.join('\n'));
console.log('lines='+out.length+' docs='+docs.length);
