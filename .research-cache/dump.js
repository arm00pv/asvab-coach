
const fs=require('fs');
const D=process.argv[2]; const cats=JSON.parse(fs.readFileSync(D+'/cats.json','utf8'));
const pick=process.argv.slice(3);
let out=[];
for(const k of pick){
  out.push('##### '+k+' #####');
  for(const x of cats[k]){
    out.push('['+x.kind+' r/'+x.sub+' '+x.created+' id='+x.id+(x.title?' | '+x.title.slice(0,110):'')+']');
    out.push(x.text.slice(0,700).replace(/\n+/g,' '));
    out.push('');
  }
}
fs.writeFileSync(D+'/dump_'+pick.join('_')+'.txt', out.join('\n'));
console.log('written '+out.length+' lines');
