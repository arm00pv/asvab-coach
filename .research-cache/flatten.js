
const fs=require('fs');
const j=JSON.parse(fs.readFileSync(process.argv[2]+'/bing.json','utf8'));
const lines=[];
for(const q of Object.keys(j)){ for(const it of j[q]){ lines.push('['+q+'] '+it.title+' :: '+it.url); lines.push('    '+it.snippet); } }
fs.writeFileSync(process.argv[2]+'/bing_flat.txt', lines.join('\n'));
console.log('lines='+lines.length);
