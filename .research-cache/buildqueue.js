
const fs=require('fs'),path=require('path');
const D=process.argv[2];
const ids=new Map();
for(const f of fs.readdirSync(D).filter(f=>/^srch_.*\.md$/.test(f))){
  const md=fs.readFileSync(path.join(D,f),'utf8');
  const re=/https:\/\/reddit\.synth\.download\/r\/([A-Za-z0-9_]+)\/comments\/([a-z0-9]+)\//g;
  let m; while((m=re.exec(md))) ids.set(m[2],m[1]);
}
const arr=[...ids.entries()].map(([id,sub])=>({id,sub}));
fs.writeFileSync(D+'/fetch_queue.json',JSON.stringify(arr,null,1));
console.log('queued='+arr.length);
