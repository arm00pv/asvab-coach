
const fs=require('fs'),path=require('path');
const D=process.argv[2];
const dirs=['threads','threads2'];
const docs=[];
for(const dd of dirs){
  const p=path.join(D,dd); if(!fs.existsSync(p)) continue;
  for(const f of fs.readdirSync(p).filter(f=>f.endsWith('.md'))){
    let md=fs.readFileSync(path.join(p,f),'utf8');
    md=md.replace(/\(https:\/\/reddit\.synth\.download[^)]*\)/g,'').replace(/\[([^\]]*)\]\([^)]*\)/g,'$1').replace(/\s+/g,' ');
    docs.push({id:f.replace('.md',''),txt:md});
  }
}
const CATS={
 AO:/assembl|\bAO\b|shapes|line.s? (connect|draw)|put together the parts/i,
 WK:/word knowledge|vocab|synonym|antonym|"most nearly"|words i/i,
 MK:/math knowledge|\bMK\b|algebra|quadratic|exponent|fraction|geometry|slope|factoring/i,
 AR:/arithmetic reasoning|\bAR\b|word problem|story problem|percent|ratio|proportion/i,
 MC:/mechanical comprehension|pulley|lever|gear|torque/i,
 EI:/electronics information|circuit|ohm|resistor|voltage|amp/i,
 AS:/auto (info|shop)|shop information|auto shop|wrench|engine/i,
 GS:/general science|science section/i,
 PC:/paragraph comprehension|reading comp|passage/i,
 ADAPT:/adaptiv|got harder|getting harder|kept getting|more difficult|harder questions/i,
 PACE:/ran out of time|out of time|timer|time limit|rushed|time crunch|didn.t finish|guessed/i,
 MISLEAD:/practice test|dummies|easier than|harder than|too easy|not like|different from|uniontest|crackasvab|march2success|grammar hero/i,
 SCORE:/AFQT|GT\b|scored a?\s?\d|got a\s?\d/i,
 RETEST:/retest|retake|took it twice|second time|confirmation test|c-test/i,
 PICAT:/picat|verification/i
};
const res={};
for(const k of Object.keys(CATS)){
  res[k]=[];
  for(const d of docs){
    const m=d.txt.match(CATS[k]);
    if(!m) continue;
    const idx=m.index||0;
    const ctx=d.txt.slice(Math.max(0,idx-260), Math.min(d.txt.length, idx+420));
    res[k].push({id:d.id,ctx});
  }
}
for(const k of Object.keys(res)) console.log(k+': '+res[k].length);
fs.writeFileSync(D+'/mined.json',JSON.stringify(res));
