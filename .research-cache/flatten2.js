
const fs=require('fs');
const D=process.argv[2];
const j=JSON.parse(fs.readFileSync(D+'/ddg.json','utf8'));
const lines=[];
for(const q of Object.keys(j)){
  if(!j[q].length) continue;
  lines.push('=== '+q+' ('+j[q].length+') ===');
  for(const it of j[q]){ lines.push('- '+it.title+' :: '+it.url); lines.push('   '+it.snippet.slice(0,400)); }
}
fs.writeFileSync(D+'/ddg_flat.txt',lines.join('\n'));
console.log('lines='+lines.length);
