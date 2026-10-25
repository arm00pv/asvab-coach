
const fs=require('fs');const path=require('path');
const D=process.argv[2];
const files=['srch_Militaryfaq_flairname.md','srch_AirForceRecruits_asvabrest.md','srch_nationalguard_asvabrest.md','srch_newtothenavy_asvabrest.md'];
const out=[];
for(const f of files){
  const md=fs.readFileSync(path.join(D,f),'utf8');
  out.push('===== '+f+' =====');
  for(const l of md.split('\n')){
    const m=l.match(/^##\s*\[([^\]]*)\]\(https:\/\/reddit\.synth\.download\/r\/([A-Za-z0-9_]+)\/comments\/([a-z0-9]+)\//);
    if(m) out.push(m[3]+' | '+m[1]);
  }
}
fs.writeFileSync(D+'/titles2.txt',out.join('\n'));
console.log(out.length);
