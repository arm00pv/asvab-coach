
const fs=require('fs');
const D=process.argv[2];
const m=JSON.parse(fs.readFileSync(D+'/mined.json','utf8'));
const pick=process.argv.slice(3);
const out=[];
for(const k of pick){
  out.push('##### '+k+' ('+m[k].length+') #####');
  for(const x of m[k]){ out.push('['+x.id+'] '+x.ctx); out.push(''); }
}
fs.writeFileSync(D+'/excerpts_'+pick.join('_')+'.txt',out.join('\n'));
console.log(out.length);
